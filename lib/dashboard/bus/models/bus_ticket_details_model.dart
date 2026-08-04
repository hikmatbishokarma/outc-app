double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}

/// Parses `data.cancellationPolicy`'s `"window" * "charge" : "window" * "charge" ...`
/// format into (window, charge) pairs for display — shared by the on-screen
/// ticket card and the PDF builder rather than duplicated in each.
List<(String, String)> parseCancellationPolicy(String raw) {
  if (raw.trim().isEmpty) return const [];
  final rules = <(String, String)>[];
  for (final part in raw.split(':')) {
    final segments = part.split('*');
    if (segments.length != 2) continue;
    final window = segments[0].trim().replaceAll('"', '');
    final charge = segments[1].trim().replaceAll('"', '');
    if (window.isEmpty || charge.isEmpty) continue;
    rules.add((window, charge));
  }
  return rules;
}

/// One row of `data.passengerInfo` from `GET /api/v1/buses/ticketDetails`.
class BusTicketPassenger {
  BusTicketPassenger({
    required this.name,
    required this.age,
    required this.gender,
    required this.seatNo,
    required this.fare,
    required this.gst,
    required this.baseFare,
  });

  final String name;
  final String age;
  final String gender;
  final String seatNo;
  final double fare;
  final double gst;
  final double baseFare;

  factory BusTicketPassenger.fromJson(Map<String, dynamic> json) => BusTicketPassenger(
        name: json['names']?.toString() ?? '',
        age: json['ages']?.toString() ?? '',
        gender: json['genders']?.toString() ?? '',
        seatNo: json['seatNos']?.toString() ?? '',
        fare: _toDouble(json['fares']),
        gst: _toDouble(json['gst']),
        baseFare: _toDouble(json['base']),
      );
}

/// One entry of `data.adminDetails` — the operator/support contact shown on
/// the ticket footer.
class BusTicketSupportContact {
  BusTicketSupportContact({
    required this.companyName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.cityName,
  });

  final String companyName;
  final String email;
  final String phoneNumber;
  final String address;
  final String cityName;

  factory BusTicketSupportContact.fromJson(Map<String, dynamic> json) => BusTicketSupportContact(
        companyName: json['CompanyName']?.toString() ?? '',
        email: json['Email']?.toString() ?? '',
        phoneNumber: json['PhoneNumber']?.toString() ?? '',
        address: json['Address']?.toString() ?? '',
        cityName: json['CityName']?.toString() ?? '',
      );
}

/// `data` object of `GET /api/v1/buses/ticketDetails?refNo=`. Maps only the
/// clean lowerCamel-ish fields the endpoint returns for display purposes —
/// the response also embeds a much larger set of internal/legacy
/// PascalCase fields (a duplicate `Operator`, a raw `Request` JSON string,
/// etc.) that are provider bookkeeping, not ticket content, so they're left
/// unparsed here.
class BusTicketDetails {
  BusTicketDetails({
    required this.bookingRefNo,
    required this.pnr,
    required this.bookingStatus,
    required this.noOfSeats,
    required this.operator,
    required this.busTypeName,
    required this.boardingPoint,
    required this.droppingPoint,
    required this.departureTime,
    required this.arrivalTime,
    required this.journeyDate,
    required this.sourceName,
    required this.destinationName,
    required this.mobileNo,
    required this.emailId,
    required this.cancellable,
    required this.cancellationPolicy,
    required this.currency,
    required this.totalPrice,
    required this.passengers,
    this.support,
  });

  final String bookingRefNo;
  final String pnr;
  final String bookingStatus;
  final int noOfSeats;
  final String operator;
  final String busTypeName;
  final String boardingPoint;
  final String droppingPoint;
  final String departureTime;
  final String arrivalTime;

  /// Raw `dd-MM-yyyy`, as sent by the endpoint.
  final String journeyDate;
  final String sourceName;
  final String destinationName;
  final String mobileNo;
  final String emailId;
  final bool cancellable;
  final String cancellationPolicy;
  final String currency;
  final double totalPrice;
  final List<BusTicketPassenger> passengers;
  final BusTicketSupportContact? support;

  bool get isConfirmed {
    final status = bookingStatus.toLowerCase();
    return status == 'booked' || status == 'confirmed';
  }

  factory BusTicketDetails.fromJson(Map<String, dynamic> json) {
    final adminList = json['adminDetails'];
    BusTicketSupportContact? support;
    if (adminList is List && adminList.isNotEmpty) {
      support = BusTicketSupportContact.fromJson(adminList.first as Map<String, dynamic>);
    }
    final passengerList = json['passengerInfo'];
    return BusTicketDetails(
      bookingRefNo: json['bookingRefNo']?.toString() ?? '',
      pnr: json['pnr']?.toString() ?? '',
      bookingStatus: json['bookingStatus']?.toString() ?? '',
      noOfSeats: json['noOfSeats'] is int
          ? json['noOfSeats'] as int
          : int.tryParse(json['noOfSeats']?.toString() ?? '') ?? 0,
      operator: json['operator']?.toString() ?? '',
      busTypeName: json['busTypeName']?.toString() ?? '',
      boardingPoint: json['boardingPoint']?.toString() ?? '',
      droppingPoint: json['droppingPoint']?.toString() ?? '',
      departureTime: json['departureTime']?.toString() ?? '',
      arrivalTime: json['ArrivalTime']?.toString() ?? '',
      journeyDate: json['JourneyDate']?.toString() ?? '',
      sourceName: json['sourceName']?.toString() ?? '',
      destinationName: json['destinationName']?.toString() ?? '',
      mobileNo: json['mobileNo']?.toString() ?? '',
      emailId: json['emailId']?.toString() ?? '',
      cancellable: json['cancellable'] == true,
      cancellationPolicy: json['cancellationPolicy']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'INR',
      totalPrice: _toDouble(json['totalPrice']),
      passengers: passengerList is List
          ? passengerList
              .whereType<Map<String, dynamic>>()
              .map(BusTicketPassenger.fromJson)
              .toList()
          : const [],
      support: support,
    );
  }
}

class BusTicketDetailsResponse {
  BusTicketDetailsResponse({this.statusCode, this.message, this.data});

  final int? statusCode;
  final String? message;
  final BusTicketDetails? data;

  factory BusTicketDetailsResponse.fromJson(Map<String, dynamic> json) => BusTicketDetailsResponse(
        statusCode: json['statusCode'] is int
            ? json['statusCode'] as int
            : int.tryParse(json['statusCode']?.toString() ?? ''),
        message: json['message']?.toString(),
        data: json['data'] == null
            ? null
            : BusTicketDetails.fromJson(json['data'] as Map<String, dynamic>),
      );
}
