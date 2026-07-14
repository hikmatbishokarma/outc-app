// To parse this JSON data, do
//
//     final citiesbySearch = citiesbySearchFromJson(jsonString);

import 'dart:convert';

CitiesbySearch citiesbySearchFromJson(String str) =>
    CitiesbySearch.fromJson(json.decode(str));

String citiesbySearchToJson(CitiesbySearch data) => json.encode(data.toJson());

class CitiesbySearch {
  final int? statusCode;
  final List<Datum>? data;
  final String? message;

  CitiesbySearch({
    this.statusCode,
    this.data,
    this.message,
  });

  factory CitiesbySearch.fromJson(Map<String, dynamic> json) => CitiesbySearch(
        statusCode: json["statusCode"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  final String? airportCode;
  final String? city;
  final String? country;
  final String? countryCode;
  final String? airportDesc;
  // final Type? type;
  final String? displayName;

  Datum({
    this.airportCode,
    this.city,
    this.country,
    this.countryCode,
    this.airportDesc,
    // this.type,
    this.displayName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        airportCode: json["AirportCode"],
        city: json["City"],
        country: json["Country"],
        countryCode: json["CountryCode"],
        airportDesc: json["AirportDesc"],
        // type: json["Type"],
        displayName: json["displayName"],
      );

  Map<String, dynamic> toJson() => {
        "AirportCode": airportCode,
        "City": city,
        "Country": country,
        "CountryCode": countryCode,
        "AirportDesc": airportDesc,
        // "Type": type,
        "displayName": displayName,
      };
}

class CitiesRequestmodel {
  String cityCode;

  CitiesRequestmodel({
    required this.cityCode,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'cityCode': cityCode.trim().isEmpty ? "" : cityCode.trim(),
    };
    return map;
  }
}
