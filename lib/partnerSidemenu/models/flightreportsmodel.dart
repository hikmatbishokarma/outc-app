// To parse this JSON data, do
//
//     final getFlightReportsResponse = getFlightReportsResponseFromJson(jsonString);

import 'dart:convert';

GetFlightReportsResponse getFlightReportsResponseFromJson(String str) =>
    GetFlightReportsResponse.fromJson(json.decode(str));

String getFlightReportsResponseToJson(GetFlightReportsResponse data) =>
    json.encode(data.toJson());

class GetFlightReportsResponse {
  final int? statusCode;
  final String? message;
  final List<Datum>? data;

  GetFlightReportsResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetFlightReportsResponse.fromJson(Map<String, dynamic> json) =>
      GetFlightReportsResponse(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final String? referenceNumber;

  final DateTime? bookingDate;

  final String? bookingStatus;
  final Pax? pax;
  final String? journeyDate;
  final String? guestName;
  final String? guestEmaiId;
  final String? guestMobileNo;
  final List<OneWaySegmentElement>? oneWaySegment;

  Datum({
    this.referenceNumber,
    this.bookingDate,
    this.bookingStatus,
    this.pax,
    this.journeyDate,
    this.guestName,
    this.guestEmaiId,
    this.guestMobileNo,
    this.oneWaySegment,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        referenceNumber: json["referenceNumber"] ?? "",
        bookingDate: json["bookingDate"] == null
            ? null
            : DateTime.parse(json["bookingDate"]),
        bookingStatus: json["BookingStatus"] ?? "",
        pax: json["pax"] == null ? null : Pax.fromJson(json["pax"]),
        journeyDate: json["journeyDate"] ?? "",
        guestName: json["guestName"] ?? "",
        guestEmaiId: json["guestEmaiId"] ?? "",
        guestMobileNo: json["guestMobileNo"] ?? "",
        oneWaySegment: json["oneWaySegment"] == null
            ? []
            : List<OneWaySegmentElement>.from(json["oneWaySegment"]!
                .map((x) => OneWaySegmentElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "referenceNumber": referenceNumber,
        "bookingDate": bookingDate?.toIso8601String(),
        "BookingStatus": bookingStatus,
        "pax": pax?.toJson(),
        "journeyDate": journeyDate,
        "guestName": guestName,
        "guestEmaiId": guestEmaiId,
        "guestMobileNo": guestMobileNo,
        "oneWaySegment": oneWaySegment == null
            ? []
            : List<dynamic>.from(oneWaySegment!.map((x) => x.toJson())),
      };
}

class OneWaySegmentElement {
  final DateTime? departureDateTime;
  final DateTime? arrivalDateTime;

  final String? originCity;

  final String? destinationCity;

  OneWaySegmentElement({
    this.departureDateTime,
    this.arrivalDateTime,
    this.originCity,
    this.destinationCity,
  });

  factory OneWaySegmentElement.fromJson(Map<String, dynamic> json) =>
      OneWaySegmentElement(
        departureDateTime: json["departureDateTime"] == null
            ? null
            : DateTime.parse(json["departureDateTime"]),
        arrivalDateTime: json["arrivalDateTime"] == null
            ? null
            : DateTime.parse(json["arrivalDateTime"]),
        originCity: json["originCity"] ?? "",
        destinationCity: json["destinationCity"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "departureDateTime": departureDateTime?.toIso8601String(),
        "arrivalDateTime": arrivalDateTime?.toIso8601String(),
        "originCity": originCity,
        "destinationCity": destinationCity,
      };
}

class Pax {
  final int? adults;
  final int? childCount;
  final int? infantCount;

  Pax({
    this.adults,
    this.childCount,
    this.infantCount,
  });

  factory Pax.fromJson(Map<String, dynamic> json) => Pax(
        adults: json["adults"] ?? 0,
        childCount: json["childCount"] ?? 0,
        infantCount: json["infantCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "adults": adults,
        "childCount": childCount,
        "infantCount": infantCount,
      };
}
