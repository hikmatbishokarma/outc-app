// To parse this JSON data, do
//
//     final currencyConversionmodel = currencyConversionmodelFromJson(jsonString);

import 'dart:convert';

CurrencyConversionmodel currencyConversionmodelFromJson(String str) =>
    CurrencyConversionmodel.fromJson(json.decode(str));

String currencyConversionmodelToJson(CurrencyConversionmodel data) =>
    json.encode(data.toJson());

class CurrencyConversionmodel {
  final int? status;
  final String? message;
  final List<Datum>? data;

  CurrencyConversionmodel({
    this.status,
    this.message,
    this.data,
  });

  factory CurrencyConversionmodel.fromJson(Map<String, dynamic> json) =>
      CurrencyConversionmodel(
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
  final int? currencyConversionId;
  final DateTime? currencyDate;
  final int? hours;
  final String? inr;
  final String? usd;
  final String? eur;
  final String? gbp;
  final String? aed;
  final String? ang;
  final String? ars;
  final String? aud;
  final String? bdt;
  final String? bgn;
  final String? bhd;
  final String? bnd;
  final String? bob;
  final String? brl;
  final String? bwp;
  final String? cad;
  final String? chf;
  final String? clp;
  final String? cny;
  final String? cop;
  final String? crc;
  final String? czk;
  final String? dkk;
  final String? dop;
  final String? dzd;
  final String? egp;
  final String? zar;
  final String? npr;
  final String? nzd;
  final String? mxn;
  final String? thb;
  final String? sgd;
  final String? myr;
  final String? sar;
  final String? uah;
  final String? rub;
  final DateTime? createdDate;
  final int? modifiedBy;
  final DateTime? modifiedDate;
  final int? deviceOs;
  final String? deviceOsVersion;
  final String? deviceToken;
  final int? applicationType;
  final String? firBaseToken;

  Datum({
    this.currencyConversionId,
    this.currencyDate,
    this.hours,
    this.inr,
    this.usd,
    this.eur,
    this.gbp,
    this.aed,
    this.ang,
    this.ars,
    this.aud,
    this.bdt,
    this.bgn,
    this.bhd,
    this.bnd,
    this.bob,
    this.brl,
    this.bwp,
    this.cad,
    this.chf,
    this.clp,
    this.cny,
    this.cop,
    this.crc,
    this.czk,
    this.dkk,
    this.dop,
    this.dzd,
    this.egp,
    this.zar,
    this.npr,
    this.nzd,
    this.mxn,
    this.thb,
    this.sgd,
    this.myr,
    this.sar,
    this.uah,
    this.rub,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.deviceOs,
    this.deviceOsVersion,
    this.deviceToken,
    this.applicationType,
    this.firBaseToken,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        currencyConversionId: json["CurrencyConversionID"],
        currencyDate: json["CurrencyDate"] == null
            ? null
            : DateTime.parse(json["CurrencyDate"]),
        hours: json["Hours"],
        inr: json["INR"],
        usd: json["USD"],
        eur: json["EUR"],
        gbp: json["GBP"],
        aed: json["AED"],
        ang: json["ANG"],
        ars: json["ARS"],
        aud: json["AUD"],
        bdt: json["BDT"],
        bgn: json["BGN"],
        bhd: json["BHD"],
        bnd: json["BND"],
        bob: json["BOB"],
        brl: json["BRL"],
        bwp: json["BWP"],
        cad: json["CAD"],
        chf: json["CHF"],
        clp: json["CLP"],
        cny: json["CNY"],
        cop: json["COP"],
        crc: json["CRC"],
        czk: json["CZK"],
        dkk: json["DKK"],
        dop: json["DOP"],
        dzd: json["DZD"],
        egp: json["EGP"],
        zar: json["ZAR"],
        npr: json["NPR"],
        nzd: json["NZD"],
        mxn: json["MXN"],
        thb: json["THB"],
        sgd: json["SGD"],
        myr: json["MYR"],
        sar: json["SAR"],
        uah: json["UAH"],
        rub: json["RUB"],
        createdDate: json["CreatedDate"] == null
            ? null
            : DateTime.parse(json["CreatedDate"]),
        modifiedBy: json["ModifiedBy"],
        modifiedDate: json["ModifiedDate"] == null
            ? null
            : DateTime.parse(json["ModifiedDate"]),
        deviceOs: json["DeviceOS"],
        deviceOsVersion: json["DeviceOSVersion"],
        deviceToken: json["DeviceToken"],
        applicationType: json["ApplicationType"],
        firBaseToken: json["FirBaseToken"],
      );

  Map<String, dynamic> toJson() => {
        "CurrencyConversionID": currencyConversionId,
        "CurrencyDate":
            "${currencyDate!.year.toString().padLeft(4, '0')}-${currencyDate!.month.toString().padLeft(2, '0')}-${currencyDate!.day.toString().padLeft(2, '0')}",
        "Hours": hours,
        "INR": inr,
        "USD": usd,
        "EUR": eur,
        "GBP": gbp,
        "AED": aed,
        "ANG": ang,
        "ARS": ars,
        "AUD": aud,
        "BDT": bdt,
        "BGN": bgn,
        "BHD": bhd,
        "BND": bnd,
        "BOB": bob,
        "BRL": brl,
        "BWP": bwp,
        "CAD": cad,
        "CHF": chf,
        "CLP": clp,
        "CNY": cny,
        "COP": cop,
        "CRC": crc,
        "CZK": czk,
        "DKK": dkk,
        "DOP": dop,
        "DZD": dzd,
        "EGP": egp,
        "ZAR": zar,
        "NPR": npr,
        "NZD": nzd,
        "MXN": mxn,
        "THB": thb,
        "SGD": sgd,
        "MYR": myr,
        "SAR": sar,
        "UAH": uah,
        "RUB": rub,
        "CreatedDate": createdDate?.toIso8601String(),
        "ModifiedBy": modifiedBy,
        "ModifiedDate": modifiedDate?.toIso8601String(),
        "DeviceOS": deviceOs,
        "DeviceOSVersion": deviceOsVersion,
        "DeviceToken": deviceToken,
        "ApplicationType": applicationType,
        "FirBaseToken": firBaseToken,
      };
}
