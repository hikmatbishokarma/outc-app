// To parse this JSON data, do
//
//     final getHotelReportsResponse = getHotelReportsResponseFromJson(jsonString);

import 'dart:convert';

GetHotelReportsResponse getHotelReportsResponseFromJson(String str) =>
    GetHotelReportsResponse.fromJson(json.decode(str));

String getHotelReportsResponseToJson(GetHotelReportsResponse data) =>
    json.encode(data.toJson());

class GetHotelReportsResponse {
  final int? statusCode;
  final String? message;
  final List<Datum>? data;

  GetHotelReportsResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetHotelReportsResponse.fromJson(Map<String, dynamic> json) =>
      GetHotelReportsResponse(
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
  final String? guestName;
  final String? hotelName;
  final String? city;
  final int? noOfRooms;

  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? bookingStatus;

  final DateTime? bookingDate;

  Datum({
    this.referenceNumber,
    this.guestName,
    this.hotelName,
    this.city,
    this.noOfRooms,
    this.checkInDate,
    this.checkOutDate,
    this.bookingStatus,
    this.bookingDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        referenceNumber: json["referenceNumber"],
        guestName: json["guestName"],
        hotelName: json["HotelName"],
        city: json["City"],
        noOfRooms: json["NoOfRooms"],
        checkInDate: json["CheckInDate"] == null
            ? null
            : DateTime.parse(json["CheckInDate"]),
        checkOutDate: json["CheckOutDate"] == null
            ? null
            : DateTime.parse(json["CheckOutDate"]),
        bookingStatus: json["BookingStatus"],
        bookingDate: json["bookingDate"] == null
            ? null
            : DateTime.parse(json["bookingDate"]),
      );

  Map<String, dynamic> toJson() => {
        "referenceNumber": referenceNumber,
        "guestName": guestName,
        "HotelName": hotelName,
        "City": city,
        "NoOfRooms": noOfRooms,
        "CheckInDate":
            "${checkInDate!.year.toString().padLeft(4, '0')}-${checkInDate!.month.toString().padLeft(2, '0')}-${checkInDate!.day.toString().padLeft(2, '0')}",
        "CheckOutDate":
            "${checkOutDate!.year.toString().padLeft(4, '0')}-${checkOutDate!.month.toString().padLeft(2, '0')}-${checkOutDate!.day.toString().padLeft(2, '0')}",
        "BookingStatus": bookingStatus,
        "bookingDate": bookingDate?.toIso8601String(),
      };
}
