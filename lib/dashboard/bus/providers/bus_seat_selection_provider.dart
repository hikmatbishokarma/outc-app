import 'package:flutter/foundation.dart';

import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/dashboard/bus/services/bus_service.dart';

/// Seat-selection state for one trip (spec 0008). Scoped to the seat-
/// selection screen only, same pattern as `BusResultsProvider` being scoped
/// to the results screen. Boarding/dropping-point selection is its own
/// subsequent screen/step (`BusPickupDropScreen`), matching how real bus-
/// booking apps sequence the flow, so it isn't tracked here.
class BusSeatSelectionProvider extends ChangeNotifier {
  BusSeatSelectionProvider({
    required this.searchId,
    required this.tripId,
    required this.passengerCount,
  });

  final BusService _service = BusService();

  final String searchId;
  final String tripId;
  final int passengerCount;

  List<BusSeat> seats = [];
  bool isLoading = false;
  String? errorMessage;

  final Set<String> selectedSeatCodes = <String>{};

  List<BusSeat> get lowerDeckSeats => seats.where((s) => s.zIndex == 0).toList();
  List<BusSeat> get upperDeckSeats => seats.where((s) => s.zIndex != 0).toList();
  bool get hasUpperDeck => upperDeckSeats.isNotEmpty;

  double get totalFare => seats
      .where((s) => selectedSeatCodes.contains(s.seatCode))
      .fold(0.0, (sum, s) => sum + s.fare);

  bool get canContinue => selectedSeatCodes.length == passengerCount;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getTripAvailability(searchId: searchId, tripId: tripId);
      seats = response.seats;
    } catch (e) {
      errorMessage = 'Could not load seat availability. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleSeat(BusSeat seat) {
    if (!seat.isAvailableSeat) return;
    if (selectedSeatCodes.contains(seat.seatCode)) {
      selectedSeatCodes.remove(seat.seatCode);
    } else {
      if (selectedSeatCodes.length >= passengerCount) return;
      selectedSeatCodes.add(seat.seatCode);
    }
    notifyListeners();
  }
}
