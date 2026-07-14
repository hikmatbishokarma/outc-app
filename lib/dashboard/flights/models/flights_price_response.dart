// To parse this JSON data, do
//
//     final priceBookResponse = priceBookResponseFromJson(jsonString);

import 'dart:convert';

PriceBookResponse priceBookResponseFromJson(String str) =>
    PriceBookResponse.fromJson(json.decode(str));

String priceBookResponseToJson(PriceBookResponse data) =>
    json.encode(data.toJson());

class PriceBookResponse {
  int statusCode;
  Data data;
  String message;

  PriceBookResponse({
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory PriceBookResponse.fromJson(Map<String, dynamic> json) =>
      PriceBookResponse(
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  String traceId;
  String mappingType;
  // List<dynamic> errors;
  // List<FlightDetail> flightDetails;
  // List<PassengerRequiredField> passengerRequiredFields;
  // GstDetails gstDetails;
  // String airPriceId;
  // SearchRequest searchRequest;
  // List<SpecialServiceRequest> specialServiceRequest;
  bool isPriceChange;

  Data({
    required this.traceId,
    required this.mappingType,
    // required this.errors,
    // required this.flightDetails,
    // required this.passengerRequiredFields,
    // required this.gstDetails,
    // required this.airPriceId,
    // required this.searchRequest,
    // required this.specialServiceRequest,
    required this.isPriceChange,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        traceId: json["traceId"],
        mappingType: json["mappingType"],
        // errors: List<dynamic>.from(json["errors"].map((x) => x)),
        // flightDetails: List<FlightDetail>.from(json["flightDetails"].map((x) => FlightDetail.fromJson(x))),
        // passengerRequiredFields: List<PassengerRequiredField>.from(json["passengerRequiredFields"].map((x) => PassengerRequiredField.fromJson(x))),
        // gstDetails: GstDetails.fromJson(json["gstDetails"]),
        // airPriceId: json["airPriceId"],
        // searchRequest: SearchRequest.fromJson(json["searchRequest"]),
        // specialServiceRequest: List<SpecialServiceRequest>.from(json["specialServiceRequest"].map((x) => SpecialServiceRequest.fromJson(x))),
        isPriceChange: json["isPriceChange"],
      );

  Map<String, dynamic> toJson() => {
        "traceId": traceId,
        "mappingType": mappingType,
        // "errors": List<dynamic>.from(errors.map((x) => x)),
        // "flightDetails": List<dynamic>.from(flightDetails.map((x) => x.toJson())),
        // "passengerRequiredFields": List<dynamic>.from(passengerRequiredFields.map((x) => x.toJson())),
        // "gstDetails": gstDetails.toJson(),
        // "airPriceId": airPriceId,
        // "searchRequest": searchRequest.toJson(),
        // "specialServiceRequest": List<dynamic>.from(specialServiceRequest.map((x) => x.toJson())),
        "isPriceChange": isPriceChange,
      };
}

class FlightDetail {
  Origin origin;
  Destination destination;
  String airLineName;
  AirLine airLine;
  String airLineLogo;
  AirLine validatingCarrier;
  String pnr;
  String accountCode;
  String supplierParameter;
  String corporateCode;
  int adultCount;
  int childCount;
  int infantCount;
  List<FlightSegment> flightSegments;
  List<FareFamily> fareFamilies;
  List<dynamic> additionalServices;
  List<dynamic> flightRemarks;
  bool isLcc;
  bool isRefundable;
  bool isPanRequiredAtBook;
  bool isPanRequiredAtTicket;
  bool isPassportRequiredAtBook;
  bool isPassportRequiredAtTicket;
  bool isGstMandatory;
  String pccCode;
  String supplierName;
  dynamic supplierSearchConfig;
  dynamic includeCarrier;
  dynamic excludeCarrier;
  String supplierKey;

  FlightDetail({
    required this.origin,
    required this.destination,
    required this.airLineName,
    required this.airLine,
    required this.airLineLogo,
    required this.validatingCarrier,
    required this.pnr,
    required this.accountCode,
    required this.supplierParameter,
    required this.corporateCode,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.flightSegments,
    required this.fareFamilies,
    required this.additionalServices,
    required this.flightRemarks,
    required this.isLcc,
    required this.isRefundable,
    required this.isPanRequiredAtBook,
    required this.isPanRequiredAtTicket,
    required this.isPassportRequiredAtBook,
    required this.isPassportRequiredAtTicket,
    required this.isGstMandatory,
    required this.pccCode,
    required this.supplierName,
    required this.supplierSearchConfig,
    required this.includeCarrier,
    required this.excludeCarrier,
    required this.supplierKey,
  });

  factory FlightDetail.fromJson(Map<String, dynamic> json) => FlightDetail(
        origin: originValues.map[json["origin"]]!,
        destination: destinationValues.map[json["destination"]]!,
        airLineName: json["airLineName"],
        airLine: airLineValues.map[json["airLine"]]!,
        airLineLogo: json["airLineLogo"],
        validatingCarrier: airLineValues.map[json["validatingCarrier"]]!,
        pnr: json["pnr"],
        accountCode: json["accountCode"],
        supplierParameter: json["supplierParameter"],
        corporateCode: json["corporateCode"],
        adultCount: json["adultCount"],
        childCount: json["childCount"],
        infantCount: json["infantCount"],
        flightSegments: List<FlightSegment>.from(
            json["flightSegments"].map((x) => FlightSegment.fromJson(x))),
        fareFamilies: List<FareFamily>.from(
            json["fareFamilies"].map((x) => FareFamily.fromJson(x))),
        additionalServices:
            List<dynamic>.from(json["additionalServices"].map((x) => x)),
        flightRemarks: List<dynamic>.from(json["flightRemarks"].map((x) => x)),
        isLcc: json["isLCC"],
        isRefundable: json["isRefundable"],
        isPanRequiredAtBook: json["isPanRequiredAtBook"],
        isPanRequiredAtTicket: json["isPanRequiredAtTicket"],
        isPassportRequiredAtBook: json["isPassportRequiredAtBook"],
        isPassportRequiredAtTicket: json["isPassportRequiredAtTicket"],
        isGstMandatory: json["isGSTMandatory"],
        pccCode: json["pccCode"],
        supplierName: json["supplierName"],
        supplierSearchConfig: json["supplierSearchConfig"],
        includeCarrier: json["includeCarrier"],
        excludeCarrier: json["excludeCarrier"],
        supplierKey: json["supplierKey"],
      );

  Map<String, dynamic> toJson() => {
        "origin": originValues.reverse[origin],
        "destination": destinationValues.reverse[destination],
        "airLineName": airLineName,
        "airLine": airLineValues.reverse[airLine],
        "airLineLogo": airLineLogo,
        "validatingCarrier": airLineValues.reverse[validatingCarrier],
        "pnr": pnr,
        "accountCode": accountCode,
        "supplierParameter": supplierParameter,
        "corporateCode": corporateCode,
        "adultCount": adultCount,
        "childCount": childCount,
        "infantCount": infantCount,
        "flightSegments":
            List<dynamic>.from(flightSegments.map((x) => x.toJson())),
        "fareFamilies": List<dynamic>.from(fareFamilies.map((x) => x.toJson())),
        "additionalServices":
            List<dynamic>.from(additionalServices.map((x) => x)),
        "flightRemarks": List<dynamic>.from(flightRemarks.map((x) => x)),
        "isLCC": isLcc,
        "isRefundable": isRefundable,
        "isPanRequiredAtBook": isPanRequiredAtBook,
        "isPanRequiredAtTicket": isPanRequiredAtTicket,
        "isPassportRequiredAtBook": isPassportRequiredAtBook,
        "isPassportRequiredAtTicket": isPassportRequiredAtTicket,
        "isGSTMandatory": isGstMandatory,
        "pccCode": pccCode,
        "supplierName": supplierName,
        "supplierSearchConfig": supplierSearchConfig,
        "includeCarrier": includeCarrier,
        "excludeCarrier": excludeCarrier,
        "supplierKey": supplierKey,
      };
}

enum AirLine { THE_6_E }

final airLineValues = EnumValues({"6E": AirLine.THE_6_E});

enum Destination { DEL, HYD }

final destinationValues =
    EnumValues({"DEL": Destination.DEL, "HYD": Destination.HYD});

class FareFamily {
  String fareId;
  String purchaseType;
  String fareType;
  String coupanType;
  Currency currency;
  String supplierParameter;
  List<FlightFare> flightFares;
  List<FareRule> fareRules;
  List<BaggageElement> baggage;
  List<List<MiniRule>> miniRules;
  List<SegmentInfo> segmentInfos;
  bool isGstMandatory;
  int commission;
  int plb;
  int markup;
  int adultNetFare;
  int otherCharges;
  int childNetFare;
  int infantNetFare;
  int totalNetFare;
  int adultPublishFare;
  int totalPublishFare;
  int adultFare;
  int agentMarkup;

  FareFamily({
    required this.fareId,
    required this.purchaseType,
    required this.fareType,
    required this.coupanType,
    required this.currency,
    required this.supplierParameter,
    required this.flightFares,
    required this.fareRules,
    required this.baggage,
    required this.miniRules,
    required this.segmentInfos,
    required this.isGstMandatory,
    required this.commission,
    required this.plb,
    required this.markup,
    required this.adultNetFare,
    required this.otherCharges,
    required this.childNetFare,
    required this.infantNetFare,
    required this.totalNetFare,
    required this.adultPublishFare,
    required this.totalPublishFare,
    required this.adultFare,
    required this.agentMarkup,
  });

  factory FareFamily.fromJson(Map<String, dynamic> json) => FareFamily(
        fareId: json["fareId"],
        purchaseType: json["purchaseType"],
        fareType: json["fareType"],
        coupanType: json["coupanType"],
        currency: currencyValues.map[json["currency"]]!,
        supplierParameter: json["supplierParameter"],
        flightFares: List<FlightFare>.from(
            json["flightFares"].map((x) => FlightFare.fromJson(x))),
        fareRules: List<FareRule>.from(
            json["fareRules"].map((x) => FareRule.fromJson(x))),
        baggage: List<BaggageElement>.from(
            json["baggage"].map((x) => BaggageElement.fromJson(x))),
        miniRules: List<List<MiniRule>>.from(json["miniRules"].map(
            (x) => List<MiniRule>.from(x.map((x) => MiniRule.fromJson(x))))),
        segmentInfos: List<SegmentInfo>.from(
            json["segmentInfos"].map((x) => SegmentInfo.fromJson(x))),
        isGstMandatory: json["isGstMandatory"],
        commission: json["commission"],
        plb: json["plb"],
        markup: json["markup"],
        adultNetFare: json["adultNetFare"],
        otherCharges: json["otherCharges"],
        childNetFare: json["childNetFare"],
        infantNetFare: json["infantNetFare"],
        totalNetFare: json["totalNetFare"],
        adultPublishFare: json["adultPublishFare"],
        totalPublishFare: json["totalPublishFare"],
        adultFare: json["adultFare"],
        agentMarkup: json["agentMarkup"],
      );

  Map<String, dynamic> toJson() => {
        "fareId": fareId,
        "purchaseType": purchaseType,
        "fareType": fareType,
        "coupanType": coupanType,
        "currency": currencyValues.reverse[currency],
        "supplierParameter": supplierParameter,
        "flightFares": List<dynamic>.from(flightFares.map((x) => x.toJson())),
        "fareRules": List<dynamic>.from(fareRules.map((x) => x.toJson())),
        "baggage": List<dynamic>.from(baggage.map((x) => x.toJson())),
        "miniRules": List<dynamic>.from(
            miniRules.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "segmentInfos": List<dynamic>.from(segmentInfos.map((x) => x.toJson())),
        "isGstMandatory": isGstMandatory,
        "commission": commission,
        "plb": plb,
        "markup": markup,
        "adultNetFare": adultNetFare,
        "otherCharges": otherCharges,
        "childNetFare": childNetFare,
        "infantNetFare": infantNetFare,
        "totalNetFare": totalNetFare,
        "adultPublishFare": adultPublishFare,
        "totalPublishFare": totalPublishFare,
        "adultFare": adultFare,
        "agentMarkup": agentMarkup,
      };
}

class BaggageElement {
  AirLine airline;
  String paxType;
  String baggageInfo;
  CityPair cityPair;
  String cabinBaggageInfo;

  BaggageElement({
    required this.airline,
    required this.paxType,
    required this.baggageInfo,
    required this.cityPair,
    required this.cabinBaggageInfo,
  });

  factory BaggageElement.fromJson(Map<String, dynamic> json) => BaggageElement(
        airline: airLineValues.map[json["airline"]]!,
        paxType: json["paxType"],
        baggageInfo: json["baggageInfo"],
        cityPair: cityPairValues.map[json["cityPair"]]!,
        cabinBaggageInfo: json["cabinBaggageInfo"],
      );

  Map<String, dynamic> toJson() => {
        "airline": airLineValues.reverse[airline],
        "paxType": paxType,
        "baggageInfo": baggageInfo,
        "cityPair": cityPairValues.reverse[cityPair],
        "cabinBaggageInfo": cabinBaggageInfo,
      };
}

enum CityPair { BOM_DEL, BOM_HYD, HYD_DEL }

final cityPairValues = EnumValues({
  "BOM-DEL": CityPair.BOM_DEL,
  "BOM-HYD": CityPair.BOM_HYD,
  "HYD-DEL": CityPair.HYD_DEL
});

enum Currency { INR }

final currencyValues = EnumValues({"INR": Currency.INR});

class FareRule {
  Origin origin;
  Destination destination;
  AirLine airline;
  String fareBasisCode;
  String fareRuleDetail;
  String fareRestriction;
  String fareFamilyCode;
  String fareRuleIndex;

  FareRule({
    required this.origin,
    required this.destination,
    required this.airline,
    required this.fareBasisCode,
    required this.fareRuleDetail,
    required this.fareRestriction,
    required this.fareFamilyCode,
    required this.fareRuleIndex,
  });

  factory FareRule.fromJson(Map<String, dynamic> json) => FareRule(
        origin: originValues.map[json["Origin"]]!,
        destination: destinationValues.map[json["Destination"]]!,
        airline: airLineValues.map[json["Airline"]]!,
        fareBasisCode: json["FareBasisCode"],
        fareRuleDetail: json["FareRuleDetail"],
        fareRestriction: json["FareRestriction"],
        fareFamilyCode: json["FareFamilyCode"],
        fareRuleIndex: json["FareRuleIndex"],
      );

  Map<String, dynamic> toJson() => {
        "Origin": originValues.reverse[origin],
        "Destination": destinationValues.reverse[destination],
        "Airline": airLineValues.reverse[airline],
        "FareBasisCode": fareBasisCode,
        "FareRuleDetail": fareRuleDetail,
        "FareRestriction": fareRestriction,
        "FareFamilyCode": fareFamilyCode,
        "FareRuleIndex": fareRuleIndex,
      };
}

enum Origin { BOM, HYD }

final originValues = EnumValues({"BOM": Origin.BOM, "HYD": Origin.HYD});

class FlightFare {
  String paxType;
  String fareDescription;
  int amount;
  String fareTag;
  String fareCode;

  FlightFare({
    required this.paxType,
    required this.fareDescription,
    required this.amount,
    required this.fareTag,
    required this.fareCode,
  });

  factory FlightFare.fromJson(Map<String, dynamic> json) => FlightFare(
        paxType: json["paxType"],
        fareDescription: json["fareDescription"],
        amount: json["amount"],
        fareTag: json["fareTag"],
        fareCode: json["fareCode"],
      );

  Map<String, dynamic> toJson() => {
        "paxType": paxType,
        "fareDescription": fareDescription,
        "amount": amount,
        "fareTag": fareTag,
        "fareCode": fareCode,
      };
}

class MiniRule {
  String journeyPoints;
  String type;
  String from;
  String to;
  String unit;
  String details;

  MiniRule({
    required this.journeyPoints,
    required this.type,
    required this.from,
    required this.to,
    required this.unit,
    required this.details,
  });

  factory MiniRule.fromJson(Map<String, dynamic> json) => MiniRule(
        journeyPoints: json["JourneyPoints"],
        type: json["Type"],
        from: json["From"],
        to: json["To"],
        unit: json["Unit"],
        details: json["Details"],
      );

  Map<String, dynamic> toJson() => {
        "JourneyPoints": journeyPoints,
        "Type": type,
        "From": from,
        "To": to,
        "Unit": unit,
        "Details": details,
      };
}

class SegmentInfo {
  CityPair cityPair;
  String cabinSubClass;
  String cabinClass;
  String bookingClass;
  String supplierParameter;

  SegmentInfo({
    required this.cityPair,
    required this.cabinSubClass,
    required this.cabinClass,
    required this.bookingClass,
    required this.supplierParameter,
  });

  factory SegmentInfo.fromJson(Map<String, dynamic> json) => SegmentInfo(
        cityPair: cityPairValues.map[json["cityPair"]]!,
        cabinSubClass: json["cabinSubClass"],
        cabinClass: json["cabinClass"],
        bookingClass: json["bookingClass"],
        supplierParameter: json["supplierParameter"],
      );

  Map<String, dynamic> toJson() => {
        "cityPair": cityPairValues.reverse[cityPair],
        "cabinSubClass": cabinSubClass,
        "cabinClass": cabinClass,
        "bookingClass": bookingClass,
        "supplierParameter": supplierParameter,
      };
}

class FlightSegment {
  String segId;
  bool isReturn;
  Origin origin;
  String originName;
  String originCity;
  String originCountry;
  String originCountryCode;
  Destination destination;
  String destinationName;
  String destinationCity;
  String destinationCountry;
  String destinationCountryCode;
  DateTime departureDateTime;
  DateTime arrivalDateTime;
  String journeyDuration;
  int duration;
  String flightNumber;
  String layOverTime;
  AirLine operatingAirline;
  String airLineLogo;
  String airLineName;
  AirLine marketingAirline;
  String departureTerminal;
  String arrivalTerminal;
  String operatingFlightNumber;
  String departureTimeZone;
  String arrivalTimeZone;
  String checkInBaggage;
  String cabinBaggage;
  dynamic ssrInfo;

  FlightSegment({
    required this.segId,
    required this.isReturn,
    required this.origin,
    required this.originName,
    required this.originCity,
    required this.originCountry,
    required this.originCountryCode,
    required this.destination,
    required this.destinationName,
    required this.destinationCity,
    required this.destinationCountry,
    required this.destinationCountryCode,
    required this.departureDateTime,
    required this.arrivalDateTime,
    required this.journeyDuration,
    required this.duration,
    required this.flightNumber,
    required this.layOverTime,
    required this.operatingAirline,
    required this.airLineLogo,
    required this.airLineName,
    required this.marketingAirline,
    required this.departureTerminal,
    required this.arrivalTerminal,
    required this.operatingFlightNumber,
    required this.departureTimeZone,
    required this.arrivalTimeZone,
    required this.checkInBaggage,
    required this.cabinBaggage,
    required this.ssrInfo,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) => FlightSegment(
        segId: json["segId"],
        isReturn: json["isReturn"],
        origin: originValues.map[json["origin"]]!,
        originName: json["originName"],
        originCity: json["originCity"],
        originCountry: json["originCountry"],
        originCountryCode: json["originCountryCode"],
        destination: destinationValues.map[json["destination"]]!,
        destinationName: json["destinationName"],
        destinationCity: json["destinationCity"],
        destinationCountry: json["destinationCountry"],
        destinationCountryCode: json["destinationCountryCode"],
        departureDateTime: DateTime.parse(json["departureDateTime"]),
        arrivalDateTime: DateTime.parse(json["arrivalDateTime"]),
        journeyDuration: json["journeyDuration"],
        duration: json["duration"],
        flightNumber: json["flightNumber"],
        layOverTime: json["layOverTime"],
        operatingAirline: airLineValues.map[json["operatingAirline"]]!,
        airLineLogo: json["airLineLogo"],
        airLineName: json["airLineName"],
        marketingAirline: airLineValues.map[json["marketingAirline"]]!,
        departureTerminal: json["departureTerminal"],
        arrivalTerminal: json["arrivalTerminal"],
        operatingFlightNumber: json["operatingFlightNumber"],
        departureTimeZone: json["departureTimeZone"],
        arrivalTimeZone: json["arrivalTimeZone"],
        checkInBaggage: json["checkInBaggage"],
        cabinBaggage: json["cabinBaggage"],
        ssrInfo: json["ssrInfo"],
      );

  Map<String, dynamic> toJson() => {
        "segId": segId,
        "isReturn": isReturn,
        "origin": originValues.reverse[origin],
        "originName": originName,
        "originCity": originCity,
        "originCountry": originCountry,
        "originCountryCode": originCountryCode,
        "destination": destinationValues.reverse[destination],
        "destinationName": destinationName,
        "destinationCity": destinationCity,
        "destinationCountry": destinationCountry,
        "destinationCountryCode": destinationCountryCode,
        "departureDateTime": departureDateTime.toIso8601String(),
        "arrivalDateTime": arrivalDateTime.toIso8601String(),
        "journeyDuration": journeyDuration,
        "duration": duration,
        "flightNumber": flightNumber,
        "layOverTime": layOverTime,
        "operatingAirline": airLineValues.reverse[operatingAirline],
        "airLineLogo": airLineLogo,
        "airLineName": airLineName,
        "marketingAirline": airLineValues.reverse[marketingAirline],
        "departureTerminal": departureTerminal,
        "arrivalTerminal": arrivalTerminal,
        "operatingFlightNumber": operatingFlightNumber,
        "departureTimeZone": departureTimeZone,
        "arrivalTimeZone": arrivalTimeZone,
        "checkInBaggage": checkInBaggage,
        "cabinBaggage": cabinBaggage,
        "ssrInfo": ssrInfo,
      };
}

class GstDetails {
  String gstAddressLine1;
  String gstAddressLine2;
  String gstCity;
  String gstState;
  String gstpinCode;
  String gstEmailId;
  String gstNumber;
  String gstPhoneNo;
  String gstCompanyName;

  GstDetails({
    required this.gstAddressLine1,
    required this.gstAddressLine2,
    required this.gstCity,
    required this.gstState,
    required this.gstpinCode,
    required this.gstEmailId,
    required this.gstNumber,
    required this.gstPhoneNo,
    required this.gstCompanyName,
  });

  factory GstDetails.fromJson(Map<String, dynamic> json) => GstDetails(
        gstAddressLine1: json["gstAddressLine1"],
        gstAddressLine2: json["gstAddressLine2"],
        gstCity: json["gstCity"],
        gstState: json["gstState"],
        gstpinCode: json["gstpinCode"],
        gstEmailId: json["gstEmailId"],
        gstNumber: json["gstNumber"],
        gstPhoneNo: json["gstPhoneNo"],
        gstCompanyName: json["gstCompanyName"],
      );

  Map<String, dynamic> toJson() => {
        "gstAddressLine1": gstAddressLine1,
        "gstAddressLine2": gstAddressLine2,
        "gstCity": gstCity,
        "gstState": gstState,
        "gstpinCode": gstpinCode,
        "gstEmailId": gstEmailId,
        "gstNumber": gstNumber,
        "gstPhoneNo": gstPhoneNo,
        "gstCompanyName": gstCompanyName,
      };
}

class PassengerRequiredField {
  String paxType;
  bool email;
  bool dob;
  bool gender;
  bool mobile;
  bool passportIssuedCountry;
  bool passportDoe;
  bool passportNumber;
  bool passengerNationality;
  bool passportDoi;
  bool address;
  bool areaCode;
  bool countryCode;
  bool countryName;
  bool state;
  bool postalCode;
  bool city;

  PassengerRequiredField({
    required this.paxType,
    required this.email,
    required this.dob,
    required this.gender,
    required this.mobile,
    required this.passportIssuedCountry,
    required this.passportDoe,
    required this.passportNumber,
    required this.passengerNationality,
    required this.passportDoi,
    required this.address,
    required this.areaCode,
    required this.countryCode,
    required this.countryName,
    required this.state,
    required this.postalCode,
    required this.city,
  });

  factory PassengerRequiredField.fromJson(Map<String, dynamic> json) =>
      PassengerRequiredField(
        paxType: json["paxType"],
        email: json["email"],
        dob: json["dob"],
        gender: json["gender"],
        mobile: json["mobile"],
        passportIssuedCountry: json["passportIssuedCountry"],
        passportDoe: json["passportDOE"],
        passportNumber: json["passportNumber"],
        passengerNationality: json["passengerNationality"],
        passportDoi: json["passportDOI"],
        address: json["address"],
        areaCode: json["areaCode"],
        countryCode: json["countryCode"],
        countryName: json["countryName"],
        state: json["state"],
        postalCode: json["postalCode"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "paxType": paxType,
        "email": email,
        "dob": dob,
        "gender": gender,
        "mobile": mobile,
        "passportIssuedCountry": passportIssuedCountry,
        "passportDOE": passportDoe,
        "passportNumber": passportNumber,
        "passengerNationality": passengerNationality,
        "passportDOI": passportDoi,
        "address": address,
        "areaCode": areaCode,
        "countryCode": countryCode,
        "countryName": countryName,
        "state": state,
        "postalCode": postalCode,
        "city": city,
      };
}

class SearchRequest {
  List<OriginDestination> originDestinations;
  String priceForTrip;
  int adultCount;
  int childCount;
  int infantCount;
  String cabinClass;
  String includeCarrier;
  String excludeCarrier;
  String stopOver;
  String airTravelType;
  int flightDateFlex;
  String itineraryViewType;
  int userId;
  int roleType;
  int membership;

  SearchRequest({
    required this.originDestinations,
    required this.priceForTrip,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.cabinClass,
    required this.includeCarrier,
    required this.excludeCarrier,
    required this.stopOver,
    required this.airTravelType,
    required this.flightDateFlex,
    required this.itineraryViewType,
    required this.userId,
    required this.roleType,
    required this.membership,
  });

  factory SearchRequest.fromJson(Map<String, dynamic> json) => SearchRequest(
        originDestinations: List<OriginDestination>.from(
            json["originDestinations"]
                .map((x) => OriginDestination.fromJson(x))),
        priceForTrip: json["priceForTrip"],
        adultCount: json["adultCount"],
        childCount: json["childCount"],
        infantCount: json["infantCount"],
        cabinClass: json["cabinClass"],
        includeCarrier: json["includeCarrier"],
        excludeCarrier: json["excludeCarrier"],
        stopOver: json["stopOver"],
        airTravelType: json["airTravelType"],
        flightDateFlex: json["flightDateFlex"],
        itineraryViewType: json["itineraryViewType"],
        userId: json["userId"],
        roleType: json["roleType"],
        membership: json["membership"],
      );

  Map<String, dynamic> toJson() => {
        "originDestinations":
            List<dynamic>.from(originDestinations.map((x) => x.toJson())),
        "priceForTrip": priceForTrip,
        "adultCount": adultCount,
        "childCount": childCount,
        "infantCount": infantCount,
        "cabinClass": cabinClass,
        "includeCarrier": includeCarrier,
        "excludeCarrier": excludeCarrier,
        "stopOver": stopOver,
        "airTravelType": airTravelType,
        "flightDateFlex": flightDateFlex,
        "itineraryViewType": itineraryViewType,
        "userId": userId,
        "roleType": roleType,
        "membership": membership,
      };
}

class OriginDestination {
  DateTime departureDateTime;
  Origin origin;
  Destination destination;
  int flightDateFlex;

  OriginDestination({
    required this.departureDateTime,
    required this.origin,
    required this.destination,
    required this.flightDateFlex,
  });

  factory OriginDestination.fromJson(Map<String, dynamic> json) =>
      OriginDestination(
        departureDateTime: DateTime.parse(json["departureDateTime"]),
        origin: originValues.map[json["origin"]]!,
        destination: destinationValues.map[json["destination"]]!,
        flightDateFlex: json["flightDateFlex"],
      );

  Map<String, dynamic> toJson() => {
        "departureDateTime": departureDateTime.toIso8601String(),
        "origin": originValues.reverse[origin],
        "destination": destinationValues.reverse[destination],
        "flightDateFlex": flightDateFlex,
      };
}

class SpecialServiceRequest {
  List<MealElement> meal;
  List<MealElement> baggage;
  List<dynamic> extraservices;

  SpecialServiceRequest({
    required this.meal,
    required this.baggage,
    required this.extraservices,
  });

  factory SpecialServiceRequest.fromJson(Map<String, dynamic> json) =>
      SpecialServiceRequest(
        meal: List<MealElement>.from(
            json["MEAL"].map((x) => MealElement.fromJson(x))),
        baggage: List<MealElement>.from(
            json["BAGGAGE"].map((x) => MealElement.fromJson(x))),
        extraservices: List<dynamic>.from(json["EXTRASERVICES"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "MEAL": List<dynamic>.from(meal.map((x) => x.toJson())),
        "BAGGAGE": List<dynamic>.from(baggage.map((x) => x.toJson())),
        "EXTRASERVICES": List<dynamic>.from(extraservices.map((x) => x)),
      };
}

class MealElement {
  String code;
  int amount;
  Desc desc;
  int weight;
  CityPair cityPair;
  AirLine airlineCode;
  String flightNumber;
  int wayType;
  Currency currency;
  Origin origin;
  Destination destination;
  String airlineDesc;
  int quantity;

  MealElement({
    required this.code,
    required this.amount,
    required this.desc,
    required this.weight,
    required this.cityPair,
    required this.airlineCode,
    required this.flightNumber,
    required this.wayType,
    required this.currency,
    required this.origin,
    required this.destination,
    required this.airlineDesc,
    required this.quantity,
  });

  factory MealElement.fromJson(Map<String, dynamic> json) => MealElement(
        code: json["code"],
        amount: json["amount"],
        desc: descValues.map[json["desc"]]!,
        weight: json["weight"],
        cityPair: cityPairValues.map[json["cityPair"]]!,
        airlineCode: airLineValues.map[json["airlineCode"]]!,
        flightNumber: json["flightNumber"],
        wayType: json["wayType"],
        currency: currencyValues.map[json["currency"]]!,
        origin: originValues.map[json["origin"]]!,
        destination: destinationValues.map[json["destination"]]!,
        airlineDesc: json["airlineDesc"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "amount": amount,
        "desc": descValues.reverse[desc],
        "weight": weight,
        "cityPair": cityPairValues.reverse[cityPair],
        "airlineCode": airLineValues.reverse[airlineCode],
        "flightNumber": flightNumber,
        "wayType": wayType,
        "currency": currencyValues.reverse[currency],
        "origin": originValues.reverse[origin],
        "destination": destinationValues.reverse[destination],
        "airlineDesc": airlineDesc,
        "quantity": quantity,
      };
}

enum Desc {
  DIRECT_IN_CASE_OF_DIRECT_BAGGAGE_CAN_T_BE_UPGRADED,
  DIRECT_THE_MEAL_CHARGES_ARE_ADDED_WHILE_MAKING_THE_TICKET
}

final descValues = EnumValues({
  "Direct ( In case of Direct, baggage can't be upgraded.)":
      Desc.DIRECT_IN_CASE_OF_DIRECT_BAGGAGE_CAN_T_BE_UPGRADED,
  "Direct (The Meal charges are added while making the ticket)":
      Desc.DIRECT_THE_MEAL_CHARGES_ARE_ADDED_WHILE_MAKING_THE_TICKET
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
