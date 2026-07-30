import 'package:flutter/foundation.dart';

import 'package:outc/dashboard/bus/models/bus_booking_models.dart';
import 'package:outc/dashboard/bus/models/bus_passenger_model.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/dashboard/bus/services/bus_service.dart';

/// Checkout (trip summary + passenger details) state for a chosen set of
/// seats (spec 0009), plus submission (block -> book) once the customer taps
/// "Proceed". Scoped to the checkout screen only, same pattern as
/// `BusSeatSelectionProvider` being scoped to the seat-selection screen.
class BusCheckoutProvider extends ChangeNotifier {
  BusCheckoutProvider({
    required this.searchId,
    required this.tripId,
    required this.trip,
    required this.selectedSeats,
    required this.boardingPoint,
    required this.droppingPoint,
  }) : passengers = List.generate(selectedSeats.length, (_) => BusPassengerDetails());

  final BusService _service = BusService();

  final String searchId;
  final String tripId;
  final BusTrip trip;
  final List<BusSeat> selectedSeats;
  final BusBoardingPoint boardingPoint;
  final BusBoardingPoint droppingPoint;

  final List<BusPassengerDetails> passengers;

  String phone = '';
  String email = '';
  bool termsAccepted = false;

  bool isBooking = false;
  String? errorMessage;

  /// Set once `blockSeats()` succeeds; `confirmBooking()` books against it.
  String? _blockedReferenceNo;

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

  /// Blocks the selected seats. The checkout screen routes the response's
  /// `pgType`/`paymentLink` through `paymentGatewayFor` (`lib/core/
  /// payment_gateway.dart`, the same abstraction flights uses) before
  /// calling `confirmBooking()`. Returns the blocked data (including
  /// `bookingReferenceNo`/`paymentLink`/`pgType`) on success, or `null` with
  /// `errorMessage` set on failure.
  Future<BusBlockData?> blockSeats() async {
    isBooking = true;
    errorMessage = null;
    notifyListeners();

    try {
      final blockRequest = BusBlockRequest.fromCheckout(
        tripId: tripId,
        searchId: searchId,
        boardingPoint: boardingPoint,
        droppingPoint: droppingPoint,
        emailId: email,
        mobileNo: phone,
        selectedSeats: selectedSeats,
        passengers: passengers,
        totalPrice: totalFare,
      );
      final blockResponse = await _service.blockTicket(blockRequest);
      if (!blockResponse.isBlocked || blockResponse.data == null) {
        errorMessage = blockResponse.message ?? 'Could not block the selected seats.';
        return null;
      }
      _blockedReferenceNo = blockResponse.data!.bookingReferenceNo;
      return blockResponse.data;
    } catch (e) {
      errorMessage = 'Something went wrong while blocking the seats. Please try again.';
      return null;
    } finally {
      isBooking = false;
      notifyListeners();
    }
  }

  /// Books against the reference number captured by a prior successful
  /// `blockSeats()` call. Returns the book response on success, or `null`
  /// with `errorMessage` set on failure.
  Future<BusBookResponse?> confirmBooking() async {
    final refNo = _blockedReferenceNo;
    if (refNo == null) {
      errorMessage = 'Seats were not blocked yet.';
      return null;
    }

    isBooking = true;
    errorMessage = null;
    notifyListeners();

    try {
      final bookResponse = await _service.bookTicket(refNo);
      if (!bookResponse.isConfirmed) {
        errorMessage = bookResponse.message ?? 'Could not confirm the booking.';
        return null;
      }
      return bookResponse;
    } catch (e) {
      errorMessage = 'Something went wrong while confirming the booking. Please try again.';
      return null;
    } finally {
      isBooking = false;
      notifyListeners();
    }
  }
}
