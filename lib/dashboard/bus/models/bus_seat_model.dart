/// Parses `POST /api/v1/buses/tripAvailability` (spec 0008) — a distinct
/// endpoint/contract from `bus_search_models.dart`'s search response, kept in
/// its own file for the same reason. Only fields the seat-selection screen
/// actually reads are modeled: `number`/`base`/`gst`/`markup`/`commission`/
/// `agentMarkup`/`adminCommission`/`serviceTax`/`operatorServiceCharge` are
/// deliberately skipped, matching this module's existing pattern.
class BusSeat {
  final String seatCode;
  final int row;
  final int column;
  final int length;
  final int width;
  final int zIndex;
  final double fare;
  final bool isAvailableSeat;
  final bool isMaleSeat;
  final bool isLadiesSeat;
  final bool isLadiesSeatReserv;

  BusSeat({
    required this.seatCode,
    required this.row,
    required this.column,
    required this.length,
    required this.width,
    required this.zIndex,
    required this.fare,
    required this.isAvailableSeat,
    required this.isMaleSeat,
    required this.isLadiesSeat,
    required this.isLadiesSeatReserv,
  });

  factory BusSeat.fromJson(Map<String, dynamic> json) => BusSeat(
        seatCode: json['seatCode']?.toString() ?? '',
        row: json['row'] is int ? json['row'] as int : int.tryParse(json['row']?.toString() ?? '') ?? 0,
        column: json['column'] is int
            ? json['column'] as int
            : int.tryParse(json['column']?.toString() ?? '') ?? 0,
        length: json['length'] is int
            ? json['length'] as int
            : int.tryParse(json['length']?.toString() ?? '') ?? 1,
        width: json['width'] is int
            ? json['width'] as int
            : int.tryParse(json['width']?.toString() ?? '') ?? 1,
        zIndex: json['zIndex'] is int
            ? json['zIndex'] as int
            : int.tryParse(json['zIndex']?.toString() ?? '') ?? 0,
        fare: (json['fare'] as num?)?.toDouble() ?? double.tryParse(json['fare']?.toString() ?? '') ?? 0,
        isAvailableSeat: json['isAvailableSeat'] == true,
        isMaleSeat: json['isMaleSeat'] == true,
        isLadiesSeat: json['isLadiesSeat'] == true,
        isLadiesSeatReserv: json['isLadiesSeatReserv'] == true,
      );
}

class BusSeatAvailabilityResponse {
  final int? statusCode;
  final String? message;
  final List<BusSeat> seats;

  BusSeatAvailabilityResponse({this.statusCode, this.message, this.seats = const []});

  factory BusSeatAvailabilityResponse.fromJson(Map<String, dynamic> json) => BusSeatAvailabilityResponse(
        statusCode: json['statusCode'] is int
            ? json['statusCode'] as int
            : int.tryParse(json['statusCode']?.toString() ?? ''),
        message: json['message']?.toString(),
        seats: json['data'] == null
            ? []
            : List<BusSeat>.from((json['data'] as List).map((x) => BusSeat.fromJson(x))),
      );
}
