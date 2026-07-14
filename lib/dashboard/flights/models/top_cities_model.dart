// To parse this JSON data, do
//
//     final topCities = topCitiesFromJson(jsonString);

import 'dart:convert';

TopCities topCitiesFromJson(String str) => TopCities.fromJson(json.decode(str));

String topCitiesToJson(TopCities data) => json.encode(data.toJson());

class TopCities {
  final int? status;
  final String? message;
  final List<Datum>? data;

  TopCities({
    this.status,
    this.message,
    this.data,
  });

  factory TopCities.fromJson(Map<String, dynamic> json) => TopCities(
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
  final int? id;
  final int? serviceType;
  final String? serviceName;
  final String? origin;
  final String? destination;
  final String? hotelCityCode;
  final String? sourceId;
  final String? destinationId;
  final String? holidayCityCode;
  final String? activitiesCityCode;
  final String? destinationCityCode;
  final String? country;
  final int? status;

  Datum({
    this.id,
    this.serviceType,
    this.serviceName,
    this.origin,
    this.destination,
    this.hotelCityCode,
    this.sourceId,
    this.destinationId,
    this.holidayCityCode,
    this.activitiesCityCode,
    this.destinationCityCode,
    this.country,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["Id"],
        serviceType: json["ServiceType"],
        serviceName: json["ServiceName"],
        origin: json["origin"],
        destination: json["destination"],
        hotelCityCode: json["hotelCityCode"],
        sourceId: json["sourceId"],
        destinationId: json["destinationId"],
        holidayCityCode: json["HolidayCityCode"],
        activitiesCityCode: json["activitiesCityCode"],
        destinationCityCode: json["destinationCityCode"],
        country: json["Country"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ServiceType": serviceType,
        "ServiceName": serviceName,
        "origin": origin,
        "destination": destination,
        "hotelCityCode": hotelCityCode,
        "sourceId": sourceId,
        "destinationId": destinationId,
        "HolidayCityCode": holidayCityCode,
        "activitiesCityCode": activitiesCityCode,
        "destinationCityCode": destinationCityCode,
        "Country": country,
        "Status": status,
      };
}
