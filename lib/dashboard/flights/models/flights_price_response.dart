// To parse this JSON data, do
//
//     final priceBookResponse = priceBookResponseFromJson(jsonString);
//
// Scoped to what `FlightCheckoutProvider.confirmFare()` actually needs — the
// confirmed fare breakdown to display and to send on to `airBlock` — against
// a real, successful `airPrice` response body (captured live, not guessed;
// see specs/0013). The previous version of this file modeled a different,
// mismatched shape (flat origin/destination/airline fields directly on
// FlightDetail, an enum-keyed Origin/Destination/AirLine set, no
// `flightSegments`/`fareFamilies` nesting) that didn't match what this
// endpoint actually returns — it was never wired into `Data.fromJson`
// because of that mismatch, which is exactly why `confirmFare()` used to
// only check `statusCode` and throw away the fare numbers entirely.

import 'dart:convert';

/// The airline-fare fields below have come back as a plain int for some
/// fares and a double for others in live testing (same session, different
/// flights) — coerce either through `num` rather than assume one.
int _asInt(dynamic value) => (value as num?)?.round() ?? 0;

PriceBookResponse priceBookResponseFromJson(String str) =>
    PriceBookResponse.fromJson(json.decode(str));

String priceBookResponseToJson(PriceBookResponse data) =>
    json.encode(data.toJson());

class PriceBookResponse {
  int statusCode;
  // Nullable: a failed price call (backend crash, expired trace/fare) comes
  // back with `data: null` — this used to crash `Data.fromJson(null)`
  // trying to read a field off a null map, which is what turned a clean
  // "fare expired" signal into a generic thrown exception.
  Data? data;
  String message;

  PriceBookResponse({
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory PriceBookResponse.fromJson(Map<String, dynamic> json) =>
      PriceBookResponse(
        statusCode: _asInt(json["statusCode"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  String traceId;
  String mappingType;
  List<FlightDetail> flightDetails;
  bool isPriceChange;

  Data({
    required this.traceId,
    required this.mappingType,
    required this.flightDetails,
    required this.isPriceChange,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        traceId: json["traceId"] ?? '',
        mappingType: json["mappingType"] ?? '',
        flightDetails: json["flightDetails"] == null
            ? []
            : List<FlightDetail>.from(
                json["flightDetails"].map((x) => FlightDetail.fromJson(x))),
        isPriceChange: json["isPriceChange"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "traceId": traceId,
        "mappingType": mappingType,
        "flightDetails": List<dynamic>.from(flightDetails.map((x) => x.toJson())),
        "isPriceChange": isPriceChange,
      };
}

/// One priced itinerary. Only `fareFamilies` is actually used today (the
/// confirmed price) — `flightSegments`/`additionalServices`/etc. exist in
/// the real response too but aren't modeled here since nothing reads them
/// yet; add them the same way (against a real captured response, not a
/// guess) if a future screen needs them.
class FlightDetail {
  List<FareFamily> fareFamilies;
  int adultCount;
  int childCount;
  int infantCount;

  FlightDetail({
    required this.fareFamilies,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
  });

  factory FlightDetail.fromJson(Map<String, dynamic> json) => FlightDetail(
        fareFamilies: json["fareFamilies"] == null
            ? []
            : List<FareFamily>.from(
                json["fareFamilies"].map((x) => FareFamily.fromJson(x))),
        adultCount: _asInt(json["adultCount"]),
        childCount: _asInt(json["childCount"]),
        infantCount: _asInt(json["infantCount"]),
      );

  Map<String, dynamic> toJson() => {
        "fareFamilies": List<dynamic>.from(fareFamilies.map((x) => x.toJson())),
        "adultCount": adultCount,
        "childCount": childCount,
        "infantCount": infantCount,
      };
}

/// The confirmed price for one fare option. `totalPublishFare` is the
/// authoritative bottom line for this exact passenger mix (not a per-
/// passenger rate to multiply further — a 1-adult capture showed
/// `adultPublishFare` (2623) + `totalTaxFare` (2309) == `totalPublishFare`
/// (4932), consistent with this already being the total for the query's
/// passenger count). Multi-passenger searches haven't been captured yet to
/// confirm that holds beyond 1 adult — if a booking with 2+ adults/children
/// ever shows a base/tax split that doesn't sum to `totalPublishFare`,
/// that's the assumption to revisit first.
class FareFamily {
  String fareId;
  int adultNetFare;
  int totalTaxFare;
  int childNetFare;
  int infantNetFare;
  int otherCharges;
  int totalNetFare;
  int adultPublishFare;
  int totalPublishFare;

  FareFamily({
    required this.fareId,
    required this.adultNetFare,
    required this.totalTaxFare,
    required this.childNetFare,
    required this.infantNetFare,
    required this.otherCharges,
    required this.totalNetFare,
    required this.adultPublishFare,
    required this.totalPublishFare,
  });

  factory FareFamily.fromJson(Map<String, dynamic> json) => FareFamily(
        fareId: json["fareId"] ?? '',
        adultNetFare: _asInt(json["adultNetFare"]),
        totalTaxFare: _asInt(json["totalTaxFare"]),
        childNetFare: _asInt(json["childNetFare"]),
        infantNetFare: _asInt(json["infantNetFare"]),
        otherCharges: _asInt(json["otherCharges"]),
        totalNetFare: _asInt(json["totalNetFare"]),
        adultPublishFare: _asInt(json["adultPublishFare"]),
        totalPublishFare: _asInt(json["totalPublishFare"]),
      );

  Map<String, dynamic> toJson() => {
        "fareId": fareId,
        "adultNetFare": adultNetFare,
        "totalTaxFare": totalTaxFare,
        "childNetFare": childNetFare,
        "infantNetFare": infantNetFare,
        "otherCharges": otherCharges,
        "totalNetFare": totalNetFare,
        "adultPublishFare": adultPublishFare,
        "totalPublishFare": totalPublishFare,
      };
}
