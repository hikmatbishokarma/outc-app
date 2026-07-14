// To parse this JSON data, do
//
//     final getVisaReportsResponse = getVisaReportsResponseFromJson(jsonString);

import 'dart:convert';

GetVisaReportsResponse getVisaReportsResponseFromJson(String str) =>
    GetVisaReportsResponse.fromJson(json.decode(str));

String getVisaReportsResponseToJson(GetVisaReportsResponse data) =>
    json.encode(data.toJson());

class GetVisaReportsResponse {
  final int? status;
  final String? message;
  final List<Datum>? data;

  GetVisaReportsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetVisaReportsResponse.fromJson(Map<String, dynamic> json) =>
      GetVisaReportsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final String? customerEmail;
  final String? customerMobile;
  final String? customerFirstName;
  final String? customerLastName;

  final String? customerNationality;
  final String? referenceNumber;
  final String? passportNumber;
  final int? bookingStatus;
  final dynamic bookingConfirmationNumber;
  final DateTime? createdDate;

  final List<Passenger>? passengers;

  Datum(
      {this.customerEmail,
      this.customerMobile,
      this.customerFirstName,
      this.customerLastName,
      this.customerNationality,
      this.referenceNumber,
      this.bookingStatus,
      this.passportNumber,
      this.bookingConfirmationNumber,
      this.passengers,
      this.createdDate});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        customerEmail: json["customerEmail"],
        customerMobile: json["customerMobile"],
        customerFirstName: json["customerFirstName"],
        customerLastName: json["customerLastName"],
        customerNationality: json["customerNationality"],
        referenceNumber: json["ReferenceNumber"],
        bookingStatus: json["BookingStatus"],
        passportNumber: json["passportNumber"],
        bookingConfirmationNumber: json["BookingConfirmationNumber"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        passengers: json["passengers"] == null
            ? []
            : List<Passenger>.from(
                json["passengers"]!.map((x) => Passenger.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customerEmail": customerEmail,
        "customerMobile": customerMobile,
        "customerFirstName": customerFirstName,
        "customerLastName": customerLastName,
        "customerNationality": customerNationality,
        "ReferenceNumber": referenceNumber,
        "BookingStatus": bookingStatus,
        "passportNumber": passportNumber,
        "BookingConfirmationNumber": bookingConfirmationNumber,
        "createdDate": createdDate?.toIso8601String(),
        "passengers": passengers == null
            ? []
            : List<dynamic>.from(passengers!.map((x) => x.toJson())),
      };
}

class Passenger {
  final DateTime? dob;

  // final String? pan;
  // final String? passport;
  // final String? photo;
  // final DateTime? createdDate;

  Passenger({
    this.dob,

    // this.pan,
    // this.passport,
    // this.photo,
    // this.createdDate,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),

        // pan: json["pan"],
        // passport: json["passport"],
        // photo: json["photo"],
        // createdDate: json["createdDate"] == null
        //     ? null
        //     : DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "dob": dob?.toIso8601String(),

        // "pan": pan,
        // "passport": passport,
        // "photo": photo,
        // "createdDate": createdDate?.toIso8601String(),
      };
}
