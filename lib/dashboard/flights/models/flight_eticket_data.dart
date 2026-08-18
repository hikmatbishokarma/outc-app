import 'package:outc/dashboard/flights/models/one_way_book_response.dart';

/// Everything [FlightETicketScreen] and `buildFlightTicketPdf` need to
/// render an e-ticket. Not JSON-parsed like bus's `BusTicketDetails` — there
/// is no `ticketDetails`-equivalent GET endpoint for flights (spec 0013),
/// so this is just a bundle built directly from the `flightOnewayBook`
/// response already in hand, plus the two fields that response doesn't
/// carry (cabin class, refund policy) but the original search result did.
class FlightETicketData {
  const FlightETicketData({
    required this.ticketAllData,
    required this.cabinClass,
    required this.refundPolicy,
  });

  final TicketAllData ticketAllData;
  final String cabinClass;
  final String refundPolicy;

  String get pnr => ticketAllData.pnr;
  String get bookingRefNo => ticketAllData.referenceNumber;
  String get operatorName => ticketAllData.ticketAllDataOperator;
  String get bookingStatus => ticketAllData.bookingStatus;
  DateTime get journeyDate => ticketAllData.journeyDate;
  DateTime get bookingDate => ticketAllData.bookingDate;
  List<OneWaySegment> get segments => ticketAllData.oneWaySegment;
  List<Passenger> get passengers => ticketAllData.passengers;
  List<OneWayBaggageInfo> get baggageInfo => ticketAllData.oneWayBaggageInfo;
  YflightFare get fare => ticketAllData.oneWayflightFare;

  bool get isRefundable =>
      refundPolicy.toLowerCase().contains('non') ? false : true;

  /// Same "is this actually confirmed" convention `BusTicketDetails.isConfirmed`
  /// uses, widened with a couple of extra wordings flights' backend has been
  /// seen to use.
  bool get isConfirmed {
    final status = bookingStatus.toLowerCase();
    return status.contains('confirm') ||
        status.contains('book') ||
        status.contains('ticket') ||
        status.contains('success');
  }
}
