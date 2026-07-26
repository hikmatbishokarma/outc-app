import 'package:flutter/foundation.dart';

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

  bool isSearching = false;
  String? errorMessage;

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

  /// Builds the request, calls the search endpoint, and returns the parsed
  /// response. Navigation/snackbars are the screen's responsibility, not
  /// the provider's.
  Future<BusSearchResponse?> search() async {
    if (!canSearch) return null;

    isSearching = true;
    errorMessage = null;
    notifyListeners();

    try {
      final request = BusSearchRequest(
        sourceId: originCity!.cityId,
        destinationId: destinationCity!.cityId,
        journeyDate: journeyDate,
        src: originCity!.name,
        dst: destinationCity!.name,
      );
      final response = await _service.searchBuses(request);
      return response;
    } catch (e) {
      errorMessage = 'Could not fetch buses. Please try again.';
      return null;
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }
}
