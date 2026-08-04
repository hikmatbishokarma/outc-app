import 'package:flutter/foundation.dart';

import 'package:outc/core/async_state.dart';
import 'package:outc/core/services/connectivity_service.dart';
import 'package:outc/dashboard/bus/models/bus_ticket_details_model.dart';
import 'package:outc/dashboard/bus/services/bus_service.dart';

/// Fetches and holds the e-ticket for one booking (`refNo`), for the
/// view/download/share screen shown right after a booking is confirmed.
/// Scoped to that screen only, same pattern as `BusSeatSelectionProvider`.
class BusETicketProvider extends ChangeNotifier {
  BusETicketProvider({required this.refNo});

  final BusService _service = BusService();
  final String refNo;

  AsyncState<BusTicketDetails> state = const AsyncLoading();

  Future<void> load() async {
    state = const AsyncLoading();
    notifyListeners();

    if (!await ConnectivityService.isOnline()) {
      state = const AsyncOffline();
      notifyListeners();
      return;
    }

    try {
      final response = await _service.getTicketDetails(refNo);
      state = response.data == null ? const AsyncEmpty() : AsyncData(response.data!);
    } catch (e) {
      state = const AsyncError('Could not load your ticket. Please try again.');
    }
    notifyListeners();
  }
}
