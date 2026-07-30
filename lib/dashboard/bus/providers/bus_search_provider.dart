import 'package:flutter/foundation.dart';

import 'package:outc/core/services/connectivity_service.dart';
import 'package:outc/core/state/async_state.dart';
import 'package:outc/dashboard/bus/models/bus_city_model.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/services/bus_service.dart';

/// Search form state for the bus module (one-way only — spec 0006).
class BusSearchProvider extends ChangeNotifier {
  final BusService _service = BusService();

  static const int minPassengers = 1;
  static const int maxPassengers = 6;

  BusCity? originCity;
  BusCity? destinationCity;
  DateTime journeyDate = DateTime.now();
  int passengerCount = minPassengers;

  /// Null until the first search is attempted (spec 0012). `AsyncData`
  /// always carries the response even when `data.trips` is empty —
  /// `BusResultsScreen` is the one that renders `EmptyState`, since it
  /// already owns the "what does the result set look like" rendering.
  AsyncState<BusSearchResponse>? state;

  bool get canSearch => originCity != null && destinationCity != null;

  void setOrigin(BusCity city) {
    originCity = city;
    notifyListeners();
  }

  void setDestination(BusCity city) {
    destinationCity = city;
    notifyListeners();
  }

  void setDate(DateTime date) {
    journeyDate = date;
    notifyListeners();
  }

  void setPassengerCount(int count) {
    if (count < minPassengers || count > maxPassengers) return;
    passengerCount = count;
    notifyListeners();
  }

  void swapCities() {
    final origin = originCity;
    originCity = destinationCity;
    destinationCity = origin;
    notifyListeners();
  }

  /// Builds the request and calls the search endpoint, storing the outcome
  /// in [state]. Navigation is the screen's responsibility, not the
  /// provider's — it reads [state] after this resolves.
  Future<void> search() async {
    if (!canSearch) return;

    state = const AsyncLoading();
    notifyListeners();

    if (!await ConnectivityService.isOnline()) {
      state = const AsyncOffline();
      notifyListeners();
      return;
    }

    try {
      final request = BusSearchRequest(
        sourceId: originCity!.cityId,
        destinationId: destinationCity!.cityId,
        journeyDate: journeyDate,
        src: originCity!.name,
        dst: destinationCity!.name,
      );
      final response = await _service.searchBuses(request);
      state = AsyncData(response);
    } catch (e) {
      state = const AsyncError('Could not fetch buses. Please try again.');
    } finally {
      notifyListeners();
    }
  }
}
