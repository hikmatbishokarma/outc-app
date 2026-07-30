import 'package:flutter/foundation.dart';

import 'package:outc/dashboard/bus/models/bus_passenger_model.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';

/// Checkout (trip summary + passenger details) state for a chosen set of
/// seats (spec 0009). Scoped to the checkout screen only, same pattern as
/// `BusSeatSelectionProvider` being scoped to the seat-selection screen. No
/// network calls — everything here is either already-fetched data (trip,
/// seats, points) or plain form input with nowhere to submit yet.
class BusCheckoutProvider extends ChangeNotifier {
  BusCheckoutProvider({
    required this.trip,
    required this.selectedSeats,
    required this.boardingPoint,
    required this.droppingPoint,
  }) : passengers = List.generate(selectedSeats.length, (_) => BusPassengerDetails());

  final BusTrip trip;
  final List<BusSeat> selectedSeats;
  final BusBoardingPoint boardingPoint;
  final BusBoardingPoint droppingPoint;

  final List<BusPassengerDetails> passengers;

  String phone = '';
  String email = '';
  bool termsAccepted = false;

  double get totalFare => selectedSeats.fold(0.0, (sum, s) => sum + s.fare);

  bool get canProceed {
    if (!termsAccepted) return false;
    if (phone.trim().length < 10) return false;
    if (!email.contains('@') || !email.contains('.')) return false;
    for (final p in passengers) {
      if (p.name.trim().isEmpty) return false;
      if (p.gender == null) return false;
      final age = int.tryParse(p.age.trim());
      if (age == null || age <= 0 || age > 120) return false;
    }
    return true;
  }

  void updatePassenger(int index, {String? name, String? age, String? gender}) {
    final passenger = passengers[index];
    if (name != null) passenger.name = name;
    if (age != null) passenger.age = age;
    if (gender != null) passenger.gender = gender;
    notifyListeners();
  }

  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    termsAccepted = value;
    notifyListeners();
  }
}
