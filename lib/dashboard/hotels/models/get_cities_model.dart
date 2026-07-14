// To parse this JSON data, do
//
//     final citieslistModel = citieslistModelFromJson(jsonString);

import 'dart:convert';

CitieslistModel citieslistModelFromJson(String str) =>
    CitieslistModel.fromJson(json.decode(str));

String citieslistModelToJson(CitieslistModel data) =>
    json.encode(data.toJson());

class CitieslistModel {
  final int? status;
  final String? message;
  final List<Datum>? data;

  CitieslistModel({
    this.status,
    this.message,
    this.data,
  });

  factory CitieslistModel.fromJson(Map<String, dynamic> json) =>
      CitieslistModel(
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
  final int? cityId;
  final String? name;
  final String? cityName;
  final String? fullName;
  final String? countryCode;
  final String? country;
  final String? state;
  final String? type;

  Datum({
    this.cityId,
    this.name,
    this.cityName,
    this.fullName,
    this.countryCode,
    this.country,
    this.state,
    this.type,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        cityId: json["cityId"],
        name: json["name"],
        cityName: json["cityName"],
        fullName: json["fullName"],
        countryCode: json["countryCode"],
        country: json["country"],
        state: json["state"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "cityId": cityId,
        "name": name,
        "cityName": cityName,
        "fullName": fullName,
        "countryCode": countryCode,
        "country": country,
        "state": state,
        "type": type,
      };
}
