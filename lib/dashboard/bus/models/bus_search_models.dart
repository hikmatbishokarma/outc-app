import 'package:intl/intl.dart';

/// Always one-way (spec 0006 explicitly excludes round trip) — `tripType` and
/// `returnDate` are fixed constants, not variables derived from user input.
class BusSearchRequest {
  final String sourceId;
  final String destinationId;
  final DateTime journeyDate;
  final String src;
  final String dst;

  BusSearchRequest({
    required this.sourceId,
    required this.destinationId,
    required this.journeyDate,
    required this.src,
    required this.dst,
  });

  Map<String, dynamic> toJson() => {
        'tripType': 1,
        'sourceId': sourceId,
        'destinationId': destinationId,
        'journeyDate': DateFormat('dd-MM-yyyy').format(journeyDate),
        'returnDate': '',
        'src': src,
        'dst': dst,
        'userId': 1,
        'roleType': 4,
        'membership': 1,
      };
}

/// A single boarding/dropping point, same shape for both arrays on a trip.
/// Not used by spec 0007's UI (boarding/dropping-point filtering is out of
/// scope there) — parsed and kept on `BusTrip` for a future boarding-point
/// selection step to consume.
class BusBoardingPoint {
  final String pointId;
  final String name;
  final String time;
  final String address;
  final String landmark;
  final String location;

  BusBoardingPoint({
    required this.pointId,
    required this.name,
    required this.time,
    required this.address,
    required this.landmark,
    required this.location,
  });

  factory BusBoardingPoint.fromJson(Map<String, dynamic> json) => BusBoardingPoint(
        pointId: json['PointId']?.toString() ?? '',
        name: json['Name']?.toString() ?? '',
        time: json['Time']?.toString() ?? '',
        address: json['Address']?.toString() ?? '',
        landmark: json['Landmark']?.toString() ?? '',
        location: json['Location']?.toString() ?? '',
      );
}

/// Fields consumed by spec 0006 (search→placeholder) and spec 0007 (results/
/// filters). Deliberately not parsed: `commission`, `markup`, `agentMarkup`,
/// `base`, `nextDay`, `isRtc`, `apikey`, `cancellationPolicy`,
/// `partialCancellationAllowed`, `seatType` — none are used by either
/// spec's UI (the numeric `seatType` was confirmed useless for filtering;
/// the real seat-type signal is the `busType` text).
class BusTrip {
  final String id;
  final String displayName;
  final String busType;
  final int availableSeats;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String netFare;
  final String startingFare;
  final String source;
  final String destination;
  final List<String> amenities;
  final List<BusBoardingPoint> boardingPoints;
  final List<BusBoardingPoint> droppingPoints;

  BusTrip({
    required this.id,
    required this.displayName,
    required this.busType,
    required this.availableSeats,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.netFare,
    required this.startingFare,
    required this.source,
    required this.destination,
    this.amenities = const [],
    this.boardingPoints = const [],
    this.droppingPoints = const [],
  });

  /// `netFare`/`startingFare` are inconsistently typed (string vs number) in
  /// the sample response — parse defensively rather than assuming one type.
  double get fare => _parseFare(netFare) ?? _parseFare(startingFare) ?? 0;

  /// Some trips (confirmed in a live 290-trip capture) report multiple
  /// slash-delimited fare tiers in one string, e.g. `"6300/7350"` or
  /// `"1260/1155/1470/1365/1050/945"` — likely several seat-class prices
  /// collapsed into one row. Take the lowest of whatever numbers parse,
  /// matching how a single "starting fare" figure is normally shown.
  static double? _parseFare(String value) {
    if (value.isEmpty) return null;
    final parsed = value.split('/').map((p) => double.tryParse(p.trim())).whereType<double>().toList();
    if (parsed.isEmpty) return null;
    return parsed.reduce((a, b) => a < b ? a : b);
  }

  factory BusTrip.fromJson(Map<String, dynamic> json) => BusTrip(
        id: json['id']?.toString() ?? '',
        displayName: json['displayName']?.toString() ?? '',
        busType: json['busType']?.toString() ?? '',
        availableSeats: json['availableSeats'] is int
            ? json['availableSeats'] as int
            : int.tryParse(json['availableSeats']?.toString() ?? '') ?? 0,
        departureTime: json['departureTime']?.toString() ?? '',
        arrivalTime: json['arrivalTime']?.toString() ?? '',
        duration: json['duration']?.toString() ?? '',
        netFare: json['netFare']?.toString() ?? '',
        startingFare: json['startingFare']?.toString() ?? '',
        source: json['source']?.toString() ?? '',
        destination: json['destination']?.toString() ?? '',
        amenities: json['amenities'] == null
            ? []
            : List<String>.from((json['amenities'] as List).map((x) => x.toString())),
        boardingPoints: json['boardingPoints'] == null
            ? []
            : List<BusBoardingPoint>.from(
                (json['boardingPoints'] as List).map((x) => BusBoardingPoint.fromJson(x))),
        droppingPoints: json['droppingPoints'] == null
            ? []
            : List<BusBoardingPoint>.from(
                (json['droppingPoints'] as List).map((x) => BusBoardingPoint.fromJson(x))),
      );
}

/// One entry of the `filters.busTypes` facet. Confirmed (spec 0007) to be
/// two independent dimensions packed into one list — AC/NON-AC and
/// Seater/Semi-Sleeper/Sleeper — not one mutually-exclusive category.
class BusTypeFacet {
  final String type;
  final int count;

  BusTypeFacet({required this.type, required this.count});

  factory BusTypeFacet.fromJson(Map<String, dynamic> json) => BusTypeFacet(
        type: json['type']?.toString() ?? '',
        count: json['count'] is int ? json['count'] as int : int.tryParse(json['count']?.toString() ?? '') ?? 0,
      );
}

/// Parsed from `data.filters`. `busOperators`/`boardingPoints`/
/// `droppingPoints` are intentionally not parsed here — confirmed (spec
/// 0007) that `busOperators` never has a per-operator list (operators are
/// derived from `trips[].displayName` instead), and boarding/dropping-point
/// filtering is out of scope for the results screen.
class BusFilters {
  final double priceMin;
  final double priceMax;
  final Map<String, int> arrivalTimes;
  final Map<String, int> departureTimes;
  final List<BusTypeFacet> busTypes;

  BusFilters({
    required this.priceMin,
    required this.priceMax,
    required this.arrivalTimes,
    required this.departureTimes,
    required this.busTypes,
  });

  factory BusFilters.fromJson(Map<String, dynamic> json) {
    final price = json['price'] as Map<String, dynamic>?;
    return BusFilters(
      priceMin: (price?['min'] as num?)?.toDouble() ?? 0,
      priceMax: (price?['max'] as num?)?.toDouble() ?? 0,
      arrivalTimes: json['arrivalTimes'] == null
          ? {}
          : Map<String, int>.from((json['arrivalTimes'] as Map).map(
              (k, v) => MapEntry(k.toString(), v is int ? v : int.tryParse(v.toString()) ?? 0))),
      departureTimes: json['departureTimes'] == null
          ? {}
          : Map<String, int>.from((json['departureTimes'] as Map).map(
              (k, v) => MapEntry(k.toString(), v is int ? v : int.tryParse(v.toString()) ?? 0))),
      busTypes: json['busTypes'] == null
          ? []
          : List<BusTypeFacet>.from((json['busTypes'] as List).map((x) => BusTypeFacet.fromJson(x))),
    );
  }

  /// Fallback used if a response ever omits `filters` entirely — derives a
  /// usable price range from the trips actually returned rather than crash.
  factory BusFilters.fromTrips(List<BusTrip> trips) {
    final fares = trips.map((t) => t.fare).where((f) => f > 0).toList();
    return BusFilters(
      priceMin: fares.isEmpty ? 0 : fares.reduce((a, b) => a < b ? a : b),
      priceMax: fares.isEmpty ? 0 : fares.reduce((a, b) => a > b ? a : b),
      arrivalTimes: const {},
      departureTimes: const {},
      busTypes: const [],
    );
  }
}

class BusSearchData {
  final int totalCount;
  final List<BusTrip> trips;
  final BusFilters? filters;

  BusSearchData({required this.totalCount, required this.trips, this.filters});

  factory BusSearchData.fromJson(Map<String, dynamic> json) {
    final trips = json['trips'] == null
        ? <BusTrip>[]
        : List<BusTrip>.from((json['trips'] as List).map((x) => BusTrip.fromJson(x)));
    return BusSearchData(
      totalCount: json['totalCount'] is int
          ? json['totalCount'] as int
          : int.tryParse(json['totalCount']?.toString() ?? '') ?? 0,
      trips: trips,
      filters: json['filters'] == null ? null : BusFilters.fromJson(json['filters']),
    );
  }
}

class BusSearchResponse {
  final int? statusCode;
  final String? message;
  final String? searchId;
  final BusSearchData? data;

  BusSearchResponse({this.statusCode, this.message, this.searchId, this.data});

  factory BusSearchResponse.fromJson(Map<String, dynamic> json) => BusSearchResponse(
        statusCode: json['statusCode'] is int
            ? json['statusCode'] as int
            : int.tryParse(json['statusCode']?.toString() ?? ''),
        message: json['message']?.toString(),
        searchId: json['searchId']?.toString(),
        data: json['data'] == null ? null : BusSearchData.fromJson(json['data']),
      );
}
