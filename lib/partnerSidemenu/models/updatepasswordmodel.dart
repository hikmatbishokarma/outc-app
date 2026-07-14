// To parse this JSON data, do
//
//     final updatePartnerPasswordResponse = updatePartnerPasswordResponseFromJson(jsonString);

import 'dart:convert';

UpdatePartnerPasswordResponse updatePartnerPasswordResponseFromJson(
        String str) =>
    UpdatePartnerPasswordResponse.fromJson(json.decode(str));

String updatePartnerPasswordResponseToJson(
        UpdatePartnerPasswordResponse data) =>
    json.encode(data.toJson());

class UpdatePartnerPasswordResponse {
  final int? status;
  final String? message;
  final Data? data;

  UpdatePartnerPasswordResponse({
    this.status,
    this.message,
    this.data,
  });

  factory UpdatePartnerPasswordResponse.fromJson(Map<String, dynamic> json) =>
      UpdatePartnerPasswordResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toJson() => {};
}
