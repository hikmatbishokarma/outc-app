import 'package:outc/core/booking_context.dart';
import 'package:outc/dashboard/bus/models/bus_passenger_model.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';

/// One passenger entry inside `BusBlockRequest.passengerDetails`. A few
/// fields the sample payload sends (`seatCodes`, `serviceTax`,
/// `serviceCharge`) have no real source in this app yet — no per-seat tax
/// breakdown is returned by `tripAvailability`, and `seatCodes` duplicates
/// `seatNo` in the captured sample — so they're sent as safe constants
/// rather than invented values.
class BusBookingPassenger {
  BusBookingPassenger({
    required this.age,
    required this.name,
    required this.gender,
    required this.seatNo,
    required this.fare,
  });

  final String age;
  final String name;
  final String gender;
  final String seatNo;
  final double fare;

  /// Derived from gender (Male -> Mr, Female -> Mrs), same rule as
  /// `BusPassengerDetails.title` — kept in sync here rather than reused
  /// directly since this model only needs the resolved string, not the UI
  /// form state.
  String get _title => gender == 'Female' ? 'mrs' : 'mr';

  Map<String, dynamic> toJson() => {
        'age': age,
        'name': name,
        'countryCode': '91',
        'title': _title,
        'gender': gender == 'Female' ? 'F' : 'M',
        'seatNo': seatNo,
        'fare': fare,
        'seatCodes': seatNo,
        'serviceTax': 0,
        'markup': 0,
        'serviceCharge': 0,
        'agentMarkup': 0,
      };
}

/// Request body for `POST /api/v1/buses/blockTicket`. Shape confirmed
/// directly against the backend team (2026-08-02): `fare`/`serviceTax`/
/// `serviceCharge` must be numbers (not strings), `countryCode` is the bare
/// dialing code with no `+`, and `convienenceData`/`promoData`/
/// `insuranceData` must be omitted rather than sent as "not applied"
/// placeholders — the endpoint rejects/mishandles them when present.
class BusBlockRequest {
  BusBlockRequest({
    required this.bookingContext,
    required this.tripId,
    required this.searchId,
    required this.boardingId,
    required this.droppingId,
    required this.emailId,
    required this.mobileNo,
    required this.passengerDetails,
    required this.totalPrice,
  });

  final BookingContext bookingContext;
  final String tripId;
  final String searchId;
  final String boardingId;
  final String droppingId;
  final String emailId;
  final String mobileNo;
  final List<BusBookingPassenger> passengerDetails;
  final double totalPrice;

  Map<String, dynamic> toJson() => {
        'tripId': tripId,
        'searchId': searchId,
        'boardingId': boardingId,
        'droppingId': droppingId,
        'noofSeats': passengerDetails.length,
        'emailId': emailId,
        'mobileNo': mobileNo,
        'countryCode': '91',
        'passengerDetails': passengerDetails.map((p) => p.toJson()).toList(),
        'insuranceRequired': 0,
        'userId': bookingContext.userId,
        // Confirmed by backend for the customer flow specifically; bus
        // booking as an agent isn't confirmed yet, so agents keep the
        // pre-existing guessed value rather than assuming it's also 2.
        'roleType': bookingContext.payerType == PayerType.agent ? bookingContext.roleTypeValue : 2,
        'membership': 1,
        'promoCode': '',
        'convienenceId': 0,
        'pgType': bookingContext.pgTypeValue,
        'currency': 'INR',
        'currencyRatio': 1,
        'totalPrice': totalPrice,
        'isCouponReedem': false,
      };

  factory BusBlockRequest.fromCheckout({
    required String tripId,
    required String searchId,
    required BusBoardingPoint boardingPoint,
    required BusBoardingPoint droppingPoint,
    required String emailId,
    required String mobileNo,
    required List<BusSeat> selectedSeats,
    required List<BusPassengerDetails> passengers,
    required double totalPrice,
  }) {
    final passengerDetails = <BusBookingPassenger>[];
    for (var i = 0; i < selectedSeats.length; i++) {
      passengerDetails.add(BusBookingPassenger(
        age: passengers[i].age,
        name: passengers[i].name,
        gender: passengers[i].gender ?? 'Male',
        seatNo: selectedSeats[i].seatCode,
        fare: selectedSeats[i].fare,
      ));
    }
    return BusBlockRequest(
      bookingContext: BookingContext.current(),
      tripId: tripId,
      searchId: searchId,
      boardingId: boardingPoint.pointId,
      droppingId: droppingPoint.pointId,
      emailId: emailId,
      mobileNo: mobileNo,
      passengerDetails: passengerDetails,
      totalPrice: totalPrice,
    );
  }
}

class BusBlockData {
  BusBlockData({
    required this.blockingReferenceNo,
    required this.bookingReferenceNo,
    required this.status,
    required this.pgType,
    this.paymentLink,
  });

  final String blockingReferenceNo;
  final String bookingReferenceNo;
  final String status;

  /// 1 = Cashfree, 3 = wallet (already paid server-side) — see
  /// `lib/core/payment_gateway.dart`'s `paymentGatewayFor`.
  final int pgType;
  final String? paymentLink;

  factory BusBlockData.fromJson(Map<String, dynamic> json) => BusBlockData(
        blockingReferenceNo: json['BlockingReferenceNo']?.toString() ?? '',
        bookingReferenceNo: json['BookingReferenceNo']?.toString() ?? '',
        status: json['Status']?.toString() ?? '',
        pgType: json['pgType'] is int
            ? json['pgType'] as int
            : int.tryParse(json['pgType']?.toString() ?? '') ?? 1,
        paymentLink: json['payment_link']?.toString(),
      );
}

class BusBlockResponse {
  BusBlockResponse({this.statusCode, this.message, this.data});

  final int? statusCode;
  final String? message;
  final BusBlockData? data;

  bool get isBlocked => statusCode == 200 && data?.status == 'BLOCKED';

  factory BusBlockResponse.fromJson(Map<String, dynamic> json) => BusBlockResponse(
        statusCode: json['statusCode'] is int
            ? json['statusCode'] as int
            : int.tryParse(json['statusCode']?.toString() ?? ''),
        message: json['message']?.toString(),
        data: json['data'] == null ? null : BusBlockData.fromJson(json['data']),
      );
}

class BusBookData {
  BusBookData({
    required this.referenceNo,
    required this.bookingStatus,
    required this.pnr,
    required this.status,
  });

  final String referenceNo;
  final int bookingStatus;
  final String pnr;
  final String status;

  factory BusBookData.fromJson(Map<String, dynamic> json) => BusBookData(
        referenceNo: json['referenceNo']?.toString() ?? '',
        bookingStatus: json['bookingStatus'] is int
            ? json['bookingStatus'] as int
            : int.tryParse(json['bookingStatus']?.toString() ?? '') ?? 0,
        pnr: json['pnr']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
      );
}

class BusBookResponse {
  BusBookResponse({this.statusCode, this.message, this.data});

  final int? statusCode;
  final String? message;
  final BusBookData? data;

  bool get isConfirmed => statusCode == 200 && data?.status == 'CONFIRMED';

  factory BusBookResponse.fromJson(Map<String, dynamic> json) => BusBookResponse(
        statusCode: json['statusCode'] is int
            ? json['statusCode'] as int
            : int.tryParse(json['statusCode']?.toString() ?? ''),
        message: json['message']?.toString(),
        data: json['data'] == null ? null : BusBookData.fromJson(json['data']),
      );
}
