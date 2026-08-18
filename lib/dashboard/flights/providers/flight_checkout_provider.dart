import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/booking_context.dart';
import 'package:outc/core/widgets/booking_step_overlay.dart';
import 'package:outc/dashboard/flights/models/flight_checkout_draft.dart';
import 'package:outc/dashboard/flights/models/flightbalaji.dart' as form_model;
import 'package:outc/dashboard/flights/models/flight_price_model.dart' as price_model;
import 'package:outc/dashboard/flights/models/one_way_book_response.dart';
import 'package:outc/loginflow/model/flight_oneway_book_response_model.dart' as block_model;
import 'package:outc/services/api_services_list.dart';
import 'package:outc/widgets/sharedprefservices.dart';

/// Which of the two booking-step overlays (if any) should be showing.
enum FlightBookingPhase { none, pricing, booking }

/// Checkout (passenger details) state for a chosen fare, plus submission
/// (price -> block -> book) once the customer taps "Proceed". Scoped to
/// `BookFlightFormpage` only, same pattern as `BusCheckoutProvider` being
/// scoped to the bus checkout screen. Ports the validation, request-
/// building, and block/pay/book orchestration that used to live inline in
/// `BookFlightFormpage`'s `setState` calls — the sequence itself
/// (`flightOnewayPrice` -> `flightOnewayBlock` -> payment -> `flightOnewayBook`)
/// is unchanged, just relocated out of the widget.
class FlightCheckoutProvider extends ChangeNotifier {
  FlightCheckoutProvider({
    required this.traceId,
    required this.flightId,
    required this.fareId,
    required int adultCount,
    required int childCount,
    required int infantCount,
    required this.adultBasefare,
    required this.adulttaxfare,
    required this.childBasefare,
    required this.childtaxfare,
    required this.infantBasefare,
    required this.infanttaxfare,
  })  : adultCount = adultCount,
        childCount = childCount,
        infantCount = infantCount,
        passengers = [
          for (var i = 0; i < adultCount; i++)
            FlightPassengerDraft(paxType: FlightPaxType.adult),
          for (var i = 0; i < childCount; i++)
            FlightPassengerDraft(paxType: FlightPaxType.child),
          for (var i = 0; i < infantCount; i++)
            FlightPassengerDraft(paxType: FlightPaxType.infant),
        ];

  final APIService _service = APIService();

  final String traceId;
  final String flightId;
  final String fareId;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final double adultBasefare;
  final double adulttaxfare;
  final double childBasefare;
  final double childtaxfare;
  final double infantBasefare;
  final double infanttaxfare;

  final List<FlightPassengerDraft> passengers;

  String phone = '';
  String email = '';
  String address = '';
  bool termsAccepted = false;

  double get basefare =>
      adultCount * adultBasefare +
      childCount * childBasefare +
      infantCount * infantBasefare;
  double get taxes =>
      adultCount * adulttaxfare +
      childCount * childtaxfare +
      infantCount * infanttaxfare;
  double get total => basefare + taxes;

  /// Same flat convenience fee `book_flight_formpage.dart` has always added
  /// on top of base fare + taxes — not sourced from the API.
  static const double convenienceFee = 200;
  double get grandTotal => total + convenienceFee;

  /// Neither `flightOnewayPrice`+`flightOnewayBlock` nor `flightOnewayBook`
  /// report real intermediate progress — same situation bus's block/book
  /// calls are in. Paced by `_runStepTimer` while the real calls run
  /// underneath.
  static const List<BookingStep> pricingSteps = [
    BookingStep('Checking fare', 'Confirming the latest price'),
    BookingStep('Holding your seat', 'Please wait a moment'),
    BookingStep('Redirecting to payment', 'Preparing your payment page'),
  ];
  static const List<BookingStep> bookingSteps = [
    BookingStep('Payment received', 'Your payment is confirmed'),
    BookingStep('Confirming with airline', "Please don't close the app"),
    BookingStep('Issuing ticket', 'Ticket is being generated'),
    BookingStep('Preparing your booking', 'Almost done...'),
  ];

  FlightBookingPhase phase = FlightBookingPhase.none;
  int currentStep = 0;
  Timer? _stepTimer;

  List<BookingStep> get activeSteps =>
      phase == FlightBookingPhase.pricing ? pricingSteps : bookingSteps;

  bool get isBooking => phase != FlightBookingPhase.none;

  String? errorMessage;

  /// Set once `priceAndBlock()` succeeds; `confirmBooking()` books against it.
  String? _bookingRefNo;

  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setAddress(String value) {
    address = value;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    termsAccepted = value;
    notifyListeners();
  }

  void updatePassenger(
    int index, {
    String? title,
    String? firstName,
    String? lastName,
    String? dob,
    String? nationality,
  }) {
    final passenger = passengers[index];
    if (title != null) passenger.title = title;
    if (firstName != null) passenger.firstName = firstName;
    if (lastName != null) passenger.lastName = lastName;
    if (dob != null) passenger.dob = dob;
    if (nationality != null) passenger.nationality = nationality;
    notifyListeners();
  }

  String _convertDateFormat(String dob) {
    if (dob.isEmpty) return '';
    try {
      final parsedDate = DateFormat('dd-MM-yyyy').parse(dob);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  /// Ports the inline validation `book_flight_formpage.dart`'s Proceed
  /// button used to run before any API call: required contact fields + T&C
  /// checkbox, then per-passenger required fields and an age-range check
  /// against the parsed DOB (adults 12+, children 2-12, infants under 2).
  /// Returns the first failing message, or `null` once everything passes.
  String? validate() {
    if (phone.trim().isEmpty ||
        email.trim().isEmpty ||
        address.trim().isEmpty ||
        !termsAccepted) {
      return 'Please fill Contact Details & Accept Terms & Conditions';
    }
    for (final passenger in passengers) {
      if (!passenger.hasRequiredFields) {
        return 'Please fill all required fields';
      }
      DateTime dob;
      try {
        final formatted = _convertDateFormat(passenger.dob);
        dob = DateTime.parse(formatted);
      } catch (e) {
        return 'Invalid date format. Please use DD-MM-YYYY.';
      }
      var ageInYears = DateTime.now().difference(dob).inDays ~/ 365;
      if (DateTime.now()
          .isBefore(DateTime(dob.year + ageInYears, dob.month, dob.day))) {
        ageInYears--;
      }
      switch (passenger.paxType) {
        case FlightPaxType.adult:
          if (ageInYears < 12) return 'Adults must be 12 years or older.';
        case FlightPaxType.child:
          if (ageInYears < 2 || ageInYears > 12) {
            return 'Children must be between 2 and 12 years old.';
          }
        case FlightPaxType.infant:
          if (ageInYears >= 2) return 'Infants must be under 2 years old.';
      }
    }
    return null;
  }

  List<form_model.Passenger> _buildRequestPassengers() {
    return [
      for (final passenger in passengers)
        form_model.Passenger(
          title: passenger.title,
          firstName: passenger.firstName,
          lastName: passenger.lastName,
          paxType: passenger.paxType.wireValue,
          email: SharedPrefServices.getemail().toString(),
          dob: _convertDateFormat(passenger.dob),
          // Gender isn't collected anywhere in this form today — preserved
          // as-is from the original inline request-building code, not a
          // change introduced here.
          gender: 'm',
          mobile: SharedPrefServices.getphonenumber().toString(),
          passengerNationality: passenger.nationality,
          areaCode: '+91',
          address_CountryCode: '',
          // Also preserved verbatim from the original code, which sent this
          // literal rather than the actual contact address field.
          address: 'hyd',
          additionalServicesIds: const [],
          mealPref: const [],
          baggagePref: const [],
          pax: 1,
        ),
    ];
  }

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

  /// Prices the fare one last time, then blocks it. The checkout screen
  /// routes the returned `Data`'s `pgType`/`paymentLink` through
  /// `paymentGatewayFor` (`lib/core/payment_gateway.dart`) before calling
  /// `confirmBooking()`. Returns the blocked data on success, or `null` with
  /// `errorMessage` set on failure.
  Future<block_model.Data?> priceAndBlock() async {
    phase = FlightBookingPhase.pricing;
    currentStep = 0;
    errorMessage = null;
    notifyListeners();
    _runStepTimer(pricingSteps.length);

    final stopwatch = Stopwatch()..start();
    try {
      final bookingContext = BookingContext.current();
      final priceRequest = price_model.FLightPriceRequestModel(
        userId: bookingContext.userId,
        roleType: bookingContext.roleTypeValue,
        membership: 1,
        traceId: traceId,
        flightIds: [flightId],
        selectedFlights: [
          price_model.SelectedFlight(
            fareId: fareId,
            flightId: flightId,
            coupanType: 'Discount',
            fareType: 'Economy',
            subCabinClass: 'A',
          ),
        ],
        airTravelType: 'oneWay',
        mappingType: 'Combined',
        itineraryViewType: '1',
        gstDetails: price_model.GstDetails(
          gstAddressLine1: '',
          gstAddressLine2: '',
          gstCity: '',
          gstState: '',
          gstpinCode: '',
          gstEmailId: '',
          gstNumber: '',
          gstPhoneNo: '',
          gstCompanyName: '',
        ),
      );

      final priceResponse = await _service.flightOnewayPrice(priceRequest);
      if (priceResponse.statusCode != 200 && priceResponse.statusCode != 201) {
        errorMessage = 'Could not fetch the latest fare. Please try again.';
        return null;
      }
      currentStep = 1;
      notifyListeners();

      final blockRequest = form_model.FlightFormRequestModel(
        pgType: bookingContext.pgTypeValue,
        userId: bookingContext.userId,
        traceId: traceId,
        currency: 'INR',
        currencyRatio: 1,
        membership: 1,
        promoData: '',
        roleType: bookingContext.roleTypeValue,
        passengers: _buildRequestPassengers(),
        gstDetails: form_model.GstDetails(
          gstAddressLine1: '',
          gstAddressLine2: '',
          gstCity: '',
          gstState: '',
          gstpinCode: '',
          gstEmailId: '',
          gstNumber: '',
          gstPhoneNo: '',
          gstCompanyName: '',
        ),
        additionalServices: const [],
        creditCardInfo: '',
        convienenceId: 0,
        insuranceRequired: 0,
        totalPrice: grandTotal,
        isCouponReedem: false,
      );

      final blockResponse = await _service.flightOnewayBlock(blockRequest);
      await _holdMinimumDisplay(stopwatch, const Duration(milliseconds: 900));
      if (blockResponse.statusCode != 200 && blockResponse.statusCode != 201) {
        errorMessage = blockResponse.message.isNotEmpty
            ? blockResponse.message
            : 'Could not hold this fare. Please try again.';
        return null;
      }
      if (blockResponse.data.bookingRefNo.isEmpty) {
        errorMessage = 'Could not hold this fare. Please try again.';
        return null;
      }
      currentStep = pricingSteps.length - 1;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 350));
      _bookingRefNo = blockResponse.data.bookingRefNo;
      return blockResponse.data;
    } catch (e) {
      await _holdMinimumDisplay(stopwatch, const Duration(milliseconds: 900));
      errorMessage =
          'Something went wrong while pricing this fare. Please try again.';
      return null;
    } finally {
      _stepTimer?.cancel();
      phase = FlightBookingPhase.none;
      notifyListeners();
    }
  }

  /// Books against the reference number captured by a prior successful
  /// `priceAndBlock()` call. Returns the book response on success, or `null`
  /// with `errorMessage` set on failure.
  Future<FlightOnewayBookResponse?> confirmBooking() async {
    final refNo = _bookingRefNo;
    if (refNo == null) {
      errorMessage = 'This fare was not held yet.';
      return null;
    }

    phase = FlightBookingPhase.booking;
    currentStep = 0;
    errorMessage = null;
    notifyListeners();
    _runStepTimer(bookingSteps.length);

    final stopwatch = Stopwatch()..start();
    try {
      final bookResponse = await _service.flightOnewayBook(refNo);
      await _holdMinimumDisplay(stopwatch, const Duration(milliseconds: 1400));
      if (bookResponse.statusCode != 200 && bookResponse.statusCode != 201) {
        errorMessage = bookResponse.message.isNotEmpty
            ? bookResponse.message
            : 'Could not confirm the booking.';
        return null;
      }
      currentStep = bookingSteps.length - 1;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 350));
      return bookResponse;
    } catch (e) {
      await _holdMinimumDisplay(stopwatch, const Duration(milliseconds: 1400));
      errorMessage =
          'Something went wrong while confirming the booking. Please try again.';
      return null;
    } finally {
      _stepTimer?.cancel();
      phase = FlightBookingPhase.none;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    super.dispose();
  }
}
