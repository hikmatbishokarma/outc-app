import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:outc/dashboard/bus/models/bus_booking_models.dart';
import 'package:outc/dashboard/bus/models/bus_passenger_model.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/dashboard/bus/services/bus_service.dart';
import 'package:outc/core/widgets/booking_step_overlay.dart';

/// Which of the two booking-step overlays (if any) should be showing.
enum BookingPhase { none, reservingSeat, bookingTrip }

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

  /// Neither `blockTicket` nor `bookTicket` report real intermediate
  /// progress — each is one atomic call. These step lists are paced by
  /// `_runStepTimer` while the real call is in flight, so the checklist
  /// overlay always has *something* concrete to show even though the steps
  /// themselves aren't individually observable from the backend.
  static const List<BookingStep> reservingSteps = [
    BookingStep('Checking availability', 'Seats are available'),
    BookingStep('Holding your seat', 'Please wait a moment'),
    BookingStep('Redirecting to payment', 'Preparing your payment page'),
  ];
  static const List<BookingStep> bookingSteps = [
    BookingStep('Payment received', 'Your payment is confirmed'),
    BookingStep('Seat confirmed', 'Your seat is confirmed'),
    BookingStep('Confirming with operator', "Please don't close the app"),
    BookingStep('Issuing ticket', 'Ticket is being generated'),
    BookingStep('Preparing your booking', 'Almost done...'),
  ];

  BookingPhase phase = BookingPhase.none;
  int currentStep = 0;
  Timer? _stepTimer;

  List<BookingStep> get activeSteps =>
      phase == BookingPhase.reservingSeat ? reservingSteps : bookingSteps;

  /// True while either booking-step overlay should be showing. Kept as a
  /// getter (rather than renaming every call site) so the "Proceed" button's
  /// existing `!provider.isBooking` disable/spinner logic needs no changes.
  bool get isBooking => phase != BookingPhase.none;

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

  /// Advances `currentStep` on a fixed tick until it reaches the last step,
  /// then holds there (still "active"/spinning) until the real call the
  /// caller is racing this against resolves.
  void _runStepTimer(int stepCount) {
    _stepTimer?.cancel();
    _stepTimer = Timer.periodic(const Duration(milliseconds: 650), (timer) {
      if (currentStep < stepCount - 1) {
        currentStep++;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _holdMinimumDisplay(Stopwatch stopwatch, Duration minimum) async {
    final remaining = minimum - stopwatch.elapsed;
    if (remaining > Duration.zero) await Future.delayed(remaining);
  }

  /// Blocks the selected seats. The checkout screen routes the response's
  /// `pgType`/`paymentLink` through `paymentGatewayFor` (`lib/core/
  /// payment_gateway.dart`, the same abstraction flights uses) before
  /// calling `confirmBooking()`. Returns the blocked data (including
  /// `bookingReferenceNo`/`paymentLink`/`pgType`) on success, or `null` with
  /// `errorMessage` set on failure.
  Future<BusBlockData?> blockSeats() async {
    phase = BookingPhase.reservingSeat;
    currentStep = 0;
    errorMessage = null;
    notifyListeners();
    _runStepTimer(reservingSteps.length);

    final stopwatch = Stopwatch()..start();
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
      await _holdMinimumDisplay(stopwatch, const Duration(milliseconds: 900));
      if (!blockResponse.isBlocked || blockResponse.data == null) {
        errorMessage = blockResponse.message ?? 'Could not block the selected seats.';
        return null;
      }
      currentStep = reservingSteps.length - 1;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 350));
      _blockedReferenceNo = blockResponse.data!.bookingReferenceNo;
      return blockResponse.data;
    } catch (e) {
      await _holdMinimumDisplay(stopwatch, const Duration(milliseconds: 900));
      errorMessage = 'Something went wrong while blocking the seats. Please try again.';
      return null;
    } finally {
      _stepTimer?.cancel();
      phase = BookingPhase.none;
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

    phase = BookingPhase.bookingTrip;
    currentStep = 0;
    errorMessage = null;
    notifyListeners();
    _runStepTimer(bookingSteps.length);

    final stopwatch = Stopwatch()..start();
    try {
      final bookResponse = await _service.bookTicket(refNo);
      await _holdMinimumDisplay(stopwatch, const Duration(milliseconds: 1400));
      if (!bookResponse.isConfirmed) {
        errorMessage = bookResponse.message ?? 'Could not confirm the booking.';
        return null;
      }
      currentStep = bookingSteps.length - 1;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 350));
      return bookResponse;
    } catch (e) {
      await _holdMinimumDisplay(stopwatch, const Duration(milliseconds: 1400));
      errorMessage = 'Something went wrong while confirming the booking. Please try again.';
      return null;
    } finally {
      _stepTimer?.cancel();
      phase = BookingPhase.none;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }
}
