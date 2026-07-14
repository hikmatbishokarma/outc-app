// To parse this JSON data, do
//
//     final flightsblockResponse = flightsblockResponseFromJson(jsonString);

import 'dart:convert';

FlightsblockResponse flightsblockResponseFromJson(String str) =>
    FlightsblockResponse.fromJson(json.decode(str));

String flightsblockResponseToJson(FlightsblockResponse data) =>
    json.encode(data.toJson());

class FlightsblockResponse {
  final int? statusCode;
  final Data? data;
  final String? message;

  FlightsblockResponse({
    this.statusCode,
    this.data,
    this.message,
  });

  factory FlightsblockResponse.fromJson(Map<String, dynamic> json) =>
      FlightsblockResponse(
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  final String? encRequest;
  final String? accessCode;
  final int? pgType;
  final String? bookingRefNo;
  final String? bookingStatus;

  Data({
    this.encRequest,
    this.accessCode,
    this.pgType,
    this.bookingRefNo,
    this.bookingStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        encRequest: json["encRequest"],
        accessCode: json["accessCode"],
        pgType: json["pgType"],
        bookingRefNo: json["BookingRefNo"],
        bookingStatus: json["BookingStatus"],
      );

  Map<String, dynamic> toJson() => {
        "encRequest": encRequest,
        "accessCode": accessCode,
        "pgType": pgType,
        "BookingRefNo": bookingRefNo,
        "BookingStatus": bookingStatus,
      };
}
