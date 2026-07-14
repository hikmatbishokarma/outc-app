// To parse this JSON data, do
//
//     final getCarReportsResponse = getCarReportsResponseFromJson(jsonString);

import 'dart:convert';

GetCarReportsResponse getCarReportsResponseFromJson(String str) =>
    GetCarReportsResponse.fromJson(json.decode(str));

String getCarReportsResponseToJson(GetCarReportsResponse data) =>
    json.encode(data.toJson());

class GetCarReportsResponse {
  final int? status;
  final List<Datum>? data;
  final String? message;

  GetCarReportsResponse({
    this.status,
    this.data,
    this.message,
  });

  factory GetCarReportsResponse.fromJson(Map<String, dynamic> json) =>
      GetCarReportsResponse(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  final String? bookingRefNo;
  final String? source;
  final String? destination;
  final String? journeyDate;
  final String? mobileNo;
  final String? emailId;
  final String? guestName;
  final DateTime? createdDate;
  final int? tripType;
  final int? travelType;
  final Vendor? vendor;

  Datum({
    this.bookingRefNo,
    this.source,
    this.destination,
    this.journeyDate,
    this.mobileNo,
    this.emailId,
    this.guestName,
    this.createdDate,
    this.tripType,
    this.travelType,
    this.vendor,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        bookingRefNo: json["BookingRefNo"],
        source: json["Source"],
        destination: json["Destination"],
        journeyDate: json["JourneyDate"],
        mobileNo: json["MobileNo"],
        emailId: json["EmailId"],
        guestName: json["GuestName"],
        createdDate: json["CreatedDate"] == null
            ? null
            : DateTime.parse(json["CreatedDate"]),
        tripType: json["TripType"],
        travelType: json["TravelType"],
        vendor: json["Vendor"] == null ? null : Vendor.fromJson(json["Vendor"]),
      );

  Map<String, dynamic> toJson() => {
        "BookingRefNo": bookingRefNo,
        "Source": source,
        "Destination": destination,
        "JourneyDate": journeyDate,
        "MobileNo": mobileNo,
        "EmailId": emailId,
        "GuestName": guestName,
        "CreatedDate": createdDate?.toIso8601String(),
        "TripType": tripType,
        "TravelType": travelType,
        "Vendor": vendor?.toJson(),
      };
}

class Vendor {
  final String? companyName;

  Vendor({
    this.companyName,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        companyName: json["CompanyName"],
      );

  Map<String, dynamic> toJson() => {
        "CompanyName": companyName,
      };
}
