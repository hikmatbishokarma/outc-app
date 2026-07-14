// // To parse this JSON data, do
// //
// //     final flightOnewayBlock = flightOnewayBlockFromJson(jsonString);

// // import 'package:meta/meta.dart';
// import 'dart:convert';

// FlightOnewayBlock flightOnewayBlockFromJson(String str) =>
//     FlightOnewayBlock.fromJson(json.decode(str));

// String flightOnewayBlockToJson(FlightOnewayBlock data) =>
//     json.encode(data.toJson());

// class FlightOnewayBlock {
//   int statusCode;
//   Data data;
//   String message;

//   FlightOnewayBlock({
//     required this.statusCode,
//     required this.data,
//     required this.message,
//   });

//   factory FlightOnewayBlock.fromJson(Map<String, dynamic> json) =>
//       FlightOnewayBlock(
//         statusCode: json["statusCode"],
//         data: Data.fromJson(json["data"]),
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "statusCode": statusCode,
//         "data": data.toJson(),
//         "message": message,
//       };
// }

// class Data {
//   String encRequest;
//   String accessCode;
//   int pgType;
//   String bookingRefNo;
//   String bookingStatus;

//   Data({
//     required this.encRequest,
//     required this.accessCode,
//     required this.pgType,
//     required this.bookingRefNo,
//     required this.bookingStatus,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         encRequest: json["encRequest"],
//         accessCode: json["accessCode"],
//         pgType: json["pgType"],
//         bookingRefNo: json["BookingRefNo"],
//         bookingStatus: json["BookingStatus"],
//       );

//   Map<String, dynamic> toJson() => {
//         "encRequest": encRequest,
//         "accessCode": accessCode,
//         "pgType": pgType,
//         "BookingRefNo": bookingRefNo,
//         "BookingStatus": bookingStatus,
//       };
// }

// new one null issue solved 
import 'dart:convert';


FlightOnewayBlock flightOnewayBlockFromJson(String str) =>
    FlightOnewayBlock.fromJson(json.decode(str));

String flightOnewayBlockToJson(FlightOnewayBlock data) =>
    json.encode(data.toJson());


class FlightOnewayBlock {
  final int statusCode;
  final Data data;
  final String message;

  FlightOnewayBlock({
    required this.statusCode,
    required this.data,
    required this.message,
  });

 
  factory FlightOnewayBlock.fromJson(Map<String, dynamic> json) {
    return FlightOnewayBlock(
      statusCode: json["statusCode"] ?? 0,
      data: Data.fromJson(json["data"] ?? {}),
      message: json["message"] ?? '',
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      "statusCode": statusCode,
      "data": data.toJson(),
      "message": message,
    };
  }
}


class Data {
  final String encRequest;
  final String accessCode;
  final int pgType;
  final String bookingRefNo;
  final String bookingStatus;

  Data({
    required this.encRequest,
    required this.accessCode,
    required this.pgType,
    required this.bookingRefNo,
    required this.bookingStatus,
  });

  
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      encRequest: json["encRequest"] ?? '',
      accessCode: json["accessCode"] ?? '',
      pgType: json["pgType"] ?? 0,
      bookingRefNo: json["BookingRefNo"] ?? '',
      bookingStatus: json["BookingStatus"] ?? '',
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      "encRequest": encRequest,
      "accessCode": accessCode,
      "pgType": pgType,
      "BookingRefNo": bookingRefNo,
      "BookingStatus": bookingStatus,
    };
  }
}
