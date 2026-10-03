import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:outc/core/booking_context.dart';
import 'package:outc/core/widgets/booking_step_overlay.dart';
import 'package:outc/dashboard/flights/models/flight_checkout_draft.dart';
import 'package:outc/dashboard/flights/models/flightbalaji.dart' as form_model;
import 'package:outc/dashboard/flights/models/flight_price_model.dart' as price_model;
import 'package:outc/dashboard/flights/models/flights_list_model.dart' show FlightDetail;
import 'package:outc/dashboard/flights/models/flights_price_response.dart'
    show FareFamily;
import 'package:outc/dashboard/flights/models/one_way_book_response.dart';
import 'package:outc/loginflow/model/flight_oneway_book_response_model.dart' as block_model;
import 'package:outc/services/api_services_list.dart';
import 'package:outc/widgets/sharedprefservices.dart';

/// Which of the two booking-step overlays (if any) should be showing.
/// `pricing` (the silent `confirmFare()` check) deliberately has no overlay
/// of its own — see `isConfirmingFare`.
enum FlightBookingPhase { none, blocking, booking }

/// Checkout (passenger details) state for a chosen fare, plus submission
/// (block -> pay -> book) once the customer taps "Proceed". Scoped to
/// `BookFlightFormpage` only, same pattern as `BusCheckoutProvider` being
/// scoped to the bus checkout screen. Ports the validation, request-
/// building, and block/pay/book orchestration that used to live inline in
/// `BookFlightFormpage`'s `setState` calls.
///
/// `flightOnewayPrice` used to run bundled with `flightOnewayBlock`, both
/// deferred until the customer tapped Proceed — after they'd already filled
/// in the entire passenger form. That made the price check pointless (it
/// couldn't inform anything the customer saw, and any staleness surfaced
/// only after the longest possible delay since search) and doesn't match
/// the website, which prices the fare right after selection, before
/// passenger details. `confirmFare()` now runs once, automatically, as soon
/// as this screen opens (see `BookFlightFormpage`'s `create:`) — quietly,
/// so it doesn't block the customer from filling in the form while it's in
/// flight — and `blockFare()` (Proceed) only runs `flightOnewayBlock`,
/// waiting on `confirmFare()` first if it's still running.
class FlightCheckoutProvider extends ChangeNotifier {
  /// The identity `search_flights.dart`'s original `/airSearch` call
  /// unconditionally uses (matches the website too), regardless of who's
  /// actually logged in — not `BookingContext`'s real customerId/
  /// roleTypeValue. Every request that references the traceId/flightId/
  /// fareId minted by that search (price, airSearch-echo, block) must
  /// reuse this same identity or the backend can't resolve them — see
  /// `_confirmFareInternal()`'s doc comment for how that was confirmed.
  static const int _searchUserId = 1;
  static const int _searchRoleType = 4;

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
    this.selectedFlightDetail,
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

  /// The exact object the fare sheet rendered this fare from — sent back
  /// verbatim as `airPrice`'s `selected` field (see `flight_price_model.dart`
  /// for why). Only the one-way flow (`flight_fares_sheet.dart`) passes this
  /// today.
  final FlightDetail? selectedFlightDetail;

  final List<FlightPassengerDraft> passengers;

  String phone = '';
  String email = '';
  String address = '';
  bool termsAccepted = false;

  /// Set once `confirmFare()` succeeds — the actual current price for this
  /// fare, confirmed via `airPrice`. Until then (or if pricing fails),
  /// `basefare`/`taxes`/`total` fall back to the estimate carried over from
  /// the search results screen, so the summary isn't blank while the
  /// automatic price check is still in flight.
  FareFamily? _confirmedFare;

  double get basefare {
    final confirmed = _confirmedFare;
    if (confirmed != null) return (confirmed.totalPublishFare - confirmed.totalTaxFare).toDouble();
    return adultCount * adultBasefare +
        childCount * childBasefare +
        infantCount * infantBasefare;
  }

  double get taxes {
    final confirmed = _confirmedFare;
    if (confirmed != null) return confirmed.totalTaxFare.toDouble();
    return adultCount * adulttaxfare +
        childCount * childtaxfare +
        infantCount * infanttaxfare;
  }

  double get total => basefare + taxes;

  /// Same flat convenience fee `book_flight_formpage.dart` has always added
  /// on top of base fare + taxes — not sourced from the API.
  static const double convenienceFee = 200;
  double get grandTotal => total + convenienceFee;

  /// Neither `flightOnewayBlock` nor `flightOnewayBook` report real
  /// intermediate progress — same situation bus's block/book calls are in.
  /// Paced by `_runStepTimer` while the real calls run underneath.
  static const List<BookingStep> blockingSteps = [
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
      phase == FlightBookingPhase.blocking ? blockingSteps : bookingSteps;

  /// True once `confirmFare()` has succeeded — `blockFare()` refuses to run
  /// `flightOnewayBlock` against an unconfirmed/failed fare.
  bool isFarePriced = false;

  /// True while `confirmFare()`'s network call is in flight. Deliberately
  /// not surfaced as a full-screen overlay (unlike `phase`) — this runs the
  /// moment the screen opens and shouldn't stop the customer from starting
  /// to fill in the form; `blockFare()` awaits it if Proceed is tapped
  /// before it's finished.
  bool isConfirmingFare = false;
  Future<void>? _confirmFareFuture;

  bool get isBooking => isConfirmingFare || phase != FlightBookingPhase.none;

  String? errorMessage;

  /// Dismisses the full-screen error state (see `book_flight_formpage.dart`)
  /// so the form underneath is tappable again — the form itself is left
  /// untouched, same as `FlightsListPage`'s search-error overlay. Also
  /// retries `confirmFare()` if the fare was never successfully priced —
  /// otherwise the customer would be dropped back onto a form that can
  /// never submit, with no obvious reason why.
  void clearError() {
    errorMessage = null;
    notifyListeners();
    if (!isFarePriced) confirmFare();
  }

  /// Set once `blockFare()` succeeds; `confirmBooking()` books against it.
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

  /// The `airSearch` field `confirmFare()`'s price request needs (see
  /// `flight_price_model.dart`) — reconstructed from `selectedFlightDetail`
  /// plus the same constants `search_flights.dart` already hardcodes for
  /// every one-way search (`priceForTrip`, `cabinClass`, `stopOver`, etc.),
  /// rather than threading the original search request through an extra
  /// screen. `null` when `selectedFlightDetail` wasn't passed in (round-
  /// trip/multi-city today), same as `selected`.
  Map<String, dynamic>? _buildAirSearch() {
    final flight = selectedFlightDetail;
    if (flight == null) return null;
    final departureDate = flight.flightSegments?.firstOrNull?.departureDateTime;
    final searchDate = departureDate == null
        ? null
        : DateTime(departureDate.year, departureDate.month, departureDate.day);
    return {
      'originDestinations': [
        {
          // DateTime.toIso8601String() appends milliseconds
          // ("...T00:00:00.000") — the real request has a clean
          // "...T00:00:00", so match that instead of leaving one more
          // unverified difference in a payload that's already been wrong
          // twice.
          'departureDateTime':
              DateFormat('yyyy-MM-ddTHH:mm:ss').format(searchDate ?? DateTime.now()),
          'origin': flight.origin ?? '',
          'destination': flight.destination ?? '',
          'flightDateFlex': 1,
        },
      ],
      'priceForTrip': 'REGULAR',
      'adultCount': adultCount,
      'childCount': childCount,
      'infantCount': infantCount,
      'cabinClass': 'Economy',
      'includeCarrier': '',
      'excludeCarrier': '',
      'stopOver': 'none',
      'airTravelType': 'oneWay',
      'flightDateFlex': 3,
      'itineraryViewType': '1',
      // Deliberately not bookingContext.userId/roleTypeValue — see
      // _searchUserId's doc comment above.
      'userId': _searchUserId,
      'roleType': _searchRoleType,
      'membership': 1,
      'traceId': traceId,
      'resultsType': 'COMBINED',
    };
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

  /// Confirms the fare's current price. Runs once, automatically, the
  /// moment the checkout screen opens (see `BookFlightFormpage`'s
  /// `create:`) — not deferred until Proceed — so a stale/invalid fare
  /// (an expired traceId/fareId, most likely, given how this backend call
  /// has crashed live before — see `flights_price_response.dart`) surfaces
  /// immediately instead of after the customer has spent time filling in
  /// the whole passenger form. Safe to call again (e.g. from `clearError()`
  /// after a failure) — each call replaces `_confirmFareFuture`.
  Future<void> confirmFare() {
    final future = _confirmFareInternal();
    _confirmFareFuture = future;
    return future;
  }

  Future<void> _confirmFareInternal() async {
    isConfirmingFare = true;
    errorMessage = null;
    notifyListeners();
    try {
      final priceRequest = price_model.FLightPriceRequestModel(
        // Pricing under a *different* userId/roleType than the one the
        // trace was created under is what was causing this to come back
        // with an empty flightDetails (no crash, no error, just nothing to
        // price) — confirmed by diffing a real successful website request
        // against ours down to this field. See _searchUserId's doc comment.
        userId: _searchUserId,
        roleType: _searchRoleType,
        membership: 1,
        traceId: traceId,
        flightIds: [flightId],
        selectedFlights: [
          price_model.SelectedFlight(
            fareId: fareId,
            flightId: flightId,
            // Matches a captured real website request exactly (see
            // flight_price_model.dart's doc comment on `selected`) — this
            // used to send 'Discount'/'Economy', neither of which the
            // website ever sends.
            coupanType: 'General',
            fareType: 'Publish',
            subCabinClass: 'A',
          ),
        ],
        selected: selectedFlightDetail == null ? null : [selectedFlightDetail!.toJson()],
        airSearch: _buildAirSearch(),
        airTravelType: 'oneWay',
        mappingType: 'COMBINED',
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
        return;
      }
      // Only one flight/fare was ever requested (flightIds/selectedFlights
      // above are single-element) — the response mirrors that shape back,
      // one flightDetail with one priced fareFamily.
      final fareFamilies = priceResponse.data?.flightDetails.firstOrNull?.fareFamilies;
      if (fareFamilies == null || fareFamilies.isEmpty) {
        errorMessage = 'Could not fetch the latest fare. Please try again.';
        return;
      }
      _confirmedFare = fareFamilies.first;
      isFarePriced = true;
    } catch (e) {
      errorMessage =
          'Something went wrong while pricing this fare. Please try again.';
    } finally {
      isConfirmingFare = false;
      notifyListeners();
    }
  }

  /// Blocks (holds) the already-`confirmFare()`-priced fare. The checkout
  /// screen routes the returned `Data`'s `pgType`/`paymentLink` through
  /// `paymentGatewayFor` (`lib/core/payment_gateway.dart`) before calling
  /// `confirmBooking()`. Returns the blocked data on success, or `null` with
  /// `errorMessage` set on failure.
  Future<block_model.Data?> blockFare() async {
    // Proceed can be tapped before the automatic confirmFare() finishes
    // (a fast typist, or a fast network) — wait for it rather than racing.
    if (isConfirmingFare) await _confirmFareFuture;
    if (!isFarePriced) {
      errorMessage ??= 'This fare could not be confirmed. Please try again.';
      notifyListeners();
      return null;
    }

    phase = FlightBookingPhase.blocking;
    currentStep = 0;
    errorMessage = null;
    notifyListeners();
    _runStepTimer(blockingSteps.length);

    final stopwatch = Stopwatch()..start();
    try {
      final bookingContext = BookingContext.current();
      final blockRequest = form_model.FlightFormRequestModel(
        pgType: bookingContext.pgTypeValue,
        // Same userId/roleType as confirmFare()'s price request, for the
        // same reason — see _searchUserId's doc comment.
        userId: _searchUserId,
        traceId: traceId,
        currency: 'INR',
        currencyRatio: 1,
        membership: 1,
        promoData: '',
        roleType: _searchRoleType,
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
      currentStep = blockingSteps.length - 1;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 350));
      _bookingRefNo = blockResponse.data.bookingRefNo;
      return blockResponse.data;
    } catch (e) {
      await _holdMinimumDisplay(stopwatch, const Duration(milliseconds: 900));
      errorMessage =
          'Something went wrong while holding this fare. Please try again.';
      return null;
    } finally {
      _stepTimer?.cancel();
      phase = FlightBookingPhase.none;
      notifyListeners();
    }
  }

  /// Books against the reference number captured by a prior successful
  /// `blockFare()` call. Returns the book response on success, or `null`
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
