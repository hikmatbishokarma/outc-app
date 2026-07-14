// To parse this JSON data, do
//
//     final flightRoundtripModel = flightRoundtripModelFromJson(jsonString);

import 'dart:convert';

FlightRoundtripModel flightRoundtripModelFromJson(String str) =>
    FlightRoundtripModel.fromJson(json.decode(str));

String flightRoundtripModelToJson(FlightRoundtripModel data) =>
    json.encode(data.toJson());

class FlightRoundtripModel {
  final int? statusCode;
  final Data? data;
  final String? message;

  FlightRoundtripModel({
    this.statusCode,
    this.data,
    this.message,
  });

  factory FlightRoundtripModel.fromJson(Map<String, dynamic> json) =>
      FlightRoundtripModel(
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  final String? traceId;
  final String? airTravelType;
  final String? resultsType;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final List<DataFlightDetail>? flightDetails;
  final List<dynamic>? ibFlightDetails;
  final List<dynamic>? multicityFlightDetails;
  final FiltersObj? filtersObj;

  Data({
    this.traceId,
    this.airTravelType,
    this.resultsType,
    this.adultCount,
    this.childCount,
    this.infantCount,
    this.flightDetails,
    this.ibFlightDetails,
    this.multicityFlightDetails,
    this.filtersObj,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        traceId: json["traceId"].toString() ?? "",
        airTravelType: json["airTravelType"].toString() ?? "",
        resultsType: json["resultsType"].toString() ?? "",
        adultCount: json["adultCount"] ?? 0,
        childCount: json["childCount"] ?? 0,
        infantCount: json["infantCount"] ?? 0,
        flightDetails: json["flightDetails"] == null
            ? []
            : List<DataFlightDetail>.from(json["flightDetails"]!
                .map((x) => DataFlightDetail.fromJson(x))),
        ibFlightDetails: json["ibFlightDetails"] == null
            ? []
            : List<dynamic>.from(json["ibFlightDetails"]!.map((x) => x)),
        filtersObj: json["filtersObj"] == null
            ? null
            : FiltersObj.fromJson(json["filtersObj"]),
        multicityFlightDetails: json["multicityFlightDetails"] == null
            ? []
            : List<dynamic>.from(json["multicityFlightDetails"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "traceId": traceId,
        "airTravelType": airTravelType,
        "resultsType": resultsType,
        "adultCount": adultCount,
        "childCount": childCount,
        "infantCount": infantCount,
        "flightDetails": flightDetails == null
            ? []
            : List<dynamic>.from(flightDetails!.map((x) => x.toJson())),
        "ibFlightDetails": ibFlightDetails == null
            ? []
            : List<dynamic>.from(ibFlightDetails!.map((x) => x)),
        "multicityFlightDetails": multicityFlightDetails == null
            ? []
            : List<dynamic>.from(multicityFlightDetails!.map((x) => x)),
        "filtersObj": filtersObj?.toJson(),
      };
}

class FiltersObj {
  final List<Stop>? stops;
  final Price? price;
  final Arrival? departure;
  final Arrival? arrival;
  final List<Airline>? airlines;
  final List<Airline>? fareTypes;
  final List<Airline>? connect;
  final List<Timing>? depatureTimings;
  final List<Timing>? arrivaltimings;
  final List<Airline>? fareType;

  FiltersObj({
    this.stops,
    this.price,
    this.departure,
    this.arrival,
    this.airlines,
    this.fareTypes,
    this.connect,
    this.depatureTimings,
    this.arrivaltimings,
    this.fareType,
  });

  factory FiltersObj.fromJson(Map<String, dynamic> json) => FiltersObj(
        stops: json["stops"] == null
            ? []
            : List<Stop>.from(json["stops"]!.map((x) => Stop.fromJson(x))),
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        departure: json["departure"] == null
            ? null
            : Arrival.fromJson(json["departure"]),
        arrival:
            json["arrival"] == null ? null : Arrival.fromJson(json["arrival"]),
        airlines: json["airlines"] == null
            ? []
            : List<Airline>.from(
                json["airlines"]!.map((x) => Airline.fromJson(x))),
        fareTypes: json["fareTypes"] == null
            ? []
            : List<Airline>.from(
                json["fareTypes"]!.map((x) => Airline.fromJson(x))),
        connect: json["connect"] == null
            ? []
            : List<Airline>.from(
                json["connect"]!.map((x) => Airline.fromJson(x))),
        depatureTimings: json["depatureTimings"] == null
            ? []
            : List<Timing>.from(
                json["depatureTimings"]!.map((x) => Timing.fromJson(x))),
        arrivaltimings: json["arrivaltimings"] == null
            ? []
            : List<Timing>.from(
                json["arrivaltimings"]!.map((x) => Timing.fromJson(x))),
        fareType: json["fareType"] == null
            ? []
            : List<Airline>.from(
                json["fareType"]!.map((x) => Airline.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stops": stops == null
            ? []
            : List<dynamic>.from(stops!.map((x) => x.toJson())),
        "price": price?.toJson(),
        "departure": departure?.toJson(),
        "arrival": arrival?.toJson(),
        "airlines": airlines == null
            ? []
            : List<dynamic>.from(airlines!.map((x) => x.toJson())),
        "fareTypes": fareTypes == null
            ? []
            : List<dynamic>.from(fareTypes!.map((x) => x.toJson())),
        "connect": connect == null
            ? []
            : List<dynamic>.from(connect!.map((x) => x.toJson())),
        "depatureTimings": depatureTimings == null
            ? []
            : List<dynamic>.from(depatureTimings!.map((x) => x.toJson())),
        "arrivaltimings": arrivaltimings == null
            ? []
            : List<dynamic>.from(arrivaltimings!.map((x) => x.toJson())),
        "fareType": fareType == null
            ? []
            : List<dynamic>.from(fareType!.map((x) => x.toJson())),
      };
}

class Airline {
  final String? id;
  final String? label;
  final String? logo;
  final bool? isChecked;

  Airline({
    this.id,
    this.label,
    this.logo,
    this.isChecked,
  });

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
        id: json["id"],
        label: json["label"],
        logo: json["logo"],
        isChecked: json["isChecked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "logo": logo,
        "isChecked": isChecked,
      };
}

class Arrival {
  final String? start;
  final String? end;

  Arrival({
    this.start,
    this.end,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) => Arrival(
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
      };
}

class Timing {
  final String? id;
  final String? start;
  final String? end;
  final String? label;
  final bool? isChecked;

  Timing({
    this.id,
    this.start,
    this.end,
    this.label,
    this.isChecked,
  });

  factory Timing.fromJson(Map<String, dynamic> json) => Timing(
        id: json["id"],
        start: json["start"],
        end: json["end"],
        label: json["label"],
        isChecked: json["isChecked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start": start,
        "end": end,
        "label": label,
        "isChecked": isChecked,
      };
}

class Price {
  final int? minPrice;
  final int? maxPrice;
  final int? maxPriceRange;
  final int? minPriceRange;

  Price({
    this.minPrice,
    this.maxPrice,
    this.maxPriceRange,
    this.minPriceRange,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        minPrice: json["minPrice"],
        maxPrice: json["maxPrice"],
        maxPriceRange: json["maxPriceRange"],
        minPriceRange: json["minPriceRange"],
      );

  Map<String, dynamic> toJson() => {
        "minPrice": minPrice,
        "maxPrice": maxPrice,
        "maxPriceRange": maxPriceRange,
        "minPriceRange": minPriceRange,
      };
}

class Stop {
  final int? id;
  final String? label;
  final bool? isChecked;

  Stop({
    this.id,
    this.label,
    this.isChecked,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        id: json["id"],
        label: json["label"],
        isChecked: json["isChecked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "isChecked": isChecked,
      };
}

class DataFlightDetail {
  final List<FlightDetailFlightDetail>? flightDetails;
  final FareFamilies? fareFamilies;

  DataFlightDetail({
    this.flightDetails,
    this.fareFamilies,
  });

  factory DataFlightDetail.fromJson(Map<String, dynamic> json) =>
      DataFlightDetail(
        flightDetails: json["flightDetails"] == null
            ? []
            : List<FlightDetailFlightDetail>.from(json["flightDetails"]!
                .map((x) => FlightDetailFlightDetail.fromJson(x))),
        fareFamilies: json["fareFamilies"] == null
            ? null
            : FareFamilies.fromJson(json["fareFamilies"]),
      );

  Map<String, dynamic> toJson() => {
        "flightDetails": flightDetails == null
            ? []
            : List<dynamic>.from(flightDetails!.map((x) => x.toJson())),
        "fareFamilies": fareFamilies?.toJson(),
      };
}

class FareFamilies {
  final String? fareId;
  final List<FareFamily>? fareFamilies;

  FareFamilies({
    this.fareId,
    this.fareFamilies,
  });

  factory FareFamilies.fromJson(Map<String, dynamic> json) => FareFamilies(
        fareId: json["fareId"] ?? "",
        fareFamilies: json["fareFamilies"] == null
            ? []
            : List<FareFamily>.from(
                json["fareFamilies"]!.map((x) => FareFamily.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fareId": fareId,
        "fareFamilies": fareFamilies == null
            ? []
            : List<dynamic>.from(fareFamilies!.map((x) => x.toJson())),
      };
}

class FareFamily {
  // final String? fareId;
  // final String? purchaseType;
  // final String? fareType;
  // final String? coupanType;
  // final String? currency;
  // final String? supplierParameter;
  final List<FlightFare>? flightFares;
  final List<FareRule>? fareRules;
  final List<Baggage>? baggage;
  // final List<List<MiniRule>>? miniRules;
  final List<SegmentInfo>? segmentInfos;
  final bool? isRefundable;
  final bool? isGstMandatory;
  // final double? commission;
  // final double? plb;
  final num? markup;
  final double? adultNetFare;
  final num? childNetFare;
  final num? infantNetFare;
  final double? totalNetFare;
  final double? adultPublishFare;
  final double? totalPublishFare;
  final num? otherCharges;
  final double? totalBaseFare;
  final double? adultFare;

  FareFamily({
    // this.fareId,
    // this.purchaseType,
    // this.fareType,
    // this.coupanType,
    // this.currency,
    // this.supplierParameter,
    this.flightFares,
    this.fareRules,
    this.baggage,
    // this.miniRules,
    this.segmentInfos,
    this.isRefundable,
    this.isGstMandatory,
    // this.commission,
    // this.plb,
    this.markup,
    this.adultNetFare,
    this.childNetFare,
    this.infantNetFare,
    this.totalNetFare,
    this.adultPublishFare,
    this.totalPublishFare,
    this.otherCharges,
    this.totalBaseFare,
    this.adultFare,
  });

  factory FareFamily.fromJson(Map<String, dynamic> json) => FareFamily(
        // fareId: json["fareId"] ?? "",
        // purchaseType: json["purchaseType"] ?? "",
        // fareType: json["fareType"] ?? "",
        // coupanType: json["coupanType"] ?? "",
        // currency: json["currency"] ?? "",
        // supplierParameter: json["supplierParameter"] ?? "",
        flightFares: json["flightFares"] == null
            ? []
            : List<FlightFare>.from(
                json["flightFares"]!.map((x) => FlightFare.fromJson(x))),
        fareRules: json["fareRules"] == null
            ? []
            : List<FareRule>.from(
                json["fareRules"]!.map((x) => FareRule.fromJson(x))),
        baggage: json["baggage"] == null
            ? []
            : List<Baggage>.from(
                json["baggage"]!.map((x) => Baggage.fromJson(x))),
        // miniRules: json["miniRules"] == null
        //     ? []
        // : List<List<MiniRule>>.from(json["miniRules"]!.map((x) =>
        //     List<MiniRule>.from(x.map((x) => MiniRule.fromJson(x))))),
        segmentInfos: json["segmentInfos"] == null
            ? []
            : List<SegmentInfo>.from(
                json["segmentInfos"]!.map((x) => SegmentInfo.fromJson(x))),
        isRefundable: json["isRefundable"],
        isGstMandatory: json["isGstMandatory"],
        // commission: json["commission"]?.toDouble() ?? 0,
        // plb: json["plb"]?.toDouble() ?? 0,
        markup: json["markup"],
        adultNetFare: json["adultNetFare"]?.toDouble(),
        childNetFare: json["childNetFare"],
        infantNetFare: json["infantNetFare"],
        totalNetFare: json["totalNetFare"]?.toDouble(),
        adultPublishFare: json["adultPublishFare"]?.toDouble(),
        totalPublishFare: json["totalPublishFare"]?.toDouble(),
        otherCharges: json["otherCharges"],
        totalBaseFare: json["totalBaseFare"]?.toDouble(),
        adultFare: json["adultFare"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        // "fareId": fareId,
        // "purchaseType": purchaseType,
        // "fareType": fareType,
        // "coupanType": coupanType,
        // "currency": currency,
        // "supplierParameter": supplierParameter,
        "flightFares": flightFares == null
            ? []
            : List<dynamic>.from(flightFares!.map((x) => x.toJson())),
        "fareRules": fareRules == null
            ? []
            : List<dynamic>.from(fareRules!.map((x) => x.toJson())),
        "baggage": baggage == null
            ? []
            : List<dynamic>.from(baggage!.map((x) => x.toJson())),
        // "miniRules": miniRules == null
        //     ? []
        //     : List<dynamic>.from(miniRules!
        //         .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "segmentInfos": segmentInfos == null
            ? []
            : List<dynamic>.from(segmentInfos!.map((x) => x.toJson())),
        "isRefundable": isRefundable,
        "isGstMandatory": isGstMandatory,
        // "commission": commission,
        // "plb": plb,
        "markup": markup,
        "adultNetFare": adultNetFare,
        "childNetFare": childNetFare,
        "infantNetFare": infantNetFare,
        "totalNetFare": totalNetFare,
        "adultPublishFare": adultPublishFare,
        "totalPublishFare": totalPublishFare,
        "otherCharges": otherCharges,
        "totalBaseFare": totalBaseFare,
        "adultFare": adultFare,
      };
}

class Baggage {
  final String? airline;
  final String? paxType;
  final String? baggageInfo;
  final String? cityPair;
  final String? cabinBaggageInfo;

  Baggage({
    this.airline,
    this.paxType,
    this.baggageInfo,
    this.cityPair,
    this.cabinBaggageInfo,
  });

  factory Baggage.fromJson(Map<String, dynamic> json) => Baggage(
        airline: json["airline"] ?? "",
        paxType: json["paxType"] ?? "",
        baggageInfo: json["baggageInfo"] ?? "",
        cityPair: json["cityPair"] ?? "",
        cabinBaggageInfo: json["cabinBaggageInfo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "airline": airline,
        "paxType": paxType,
        "baggageInfo": baggageInfo,
        "cityPair": cityPair,
        "cabinBaggageInfo": cabinBaggageInfo,
      };
}

class FareRule {
  final String? origin;
  final String? destination;
  final String? airline;
  final String? fareBasisCode;
  final String? fareRuleDetail;
  final String? fareRestriction;
  final String? fareFamilyCode;
  final String? fareRuleIndex;

  FareRule({
    this.origin,
    this.destination,
    this.airline,
    this.fareBasisCode,
    this.fareRuleDetail,
    this.fareRestriction,
    this.fareFamilyCode,
    this.fareRuleIndex,
  });

  factory FareRule.fromJson(Map<String, dynamic> json) => FareRule(
        origin: json["Origin"].toString(),
        destination: json["Destination"].toString(),
        airline: json["Airline"].toString(),
        fareBasisCode: json["FareBasisCode"].toString(),
        fareRuleDetail: json["FareRuleDetail"].toString(),
        fareRestriction: json["FareRestriction"].toString(),
        fareFamilyCode: json["FareFamilyCode"].toString(),
        fareRuleIndex: json["FareRuleIndex"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "Origin": origin,
        "Destination": destination,
        "Airline": airline,
        "FareBasisCode": fareBasisCode,
        "FareRuleDetail": fareRuleDetail,
        "FareRestriction": fareRestriction,
        "FareFamilyCode": fareFamilyCode,
        "FareRuleIndex": fareRuleIndex,
      };
}

class FlightFare {
  final String? paxType;
  final String? fareDescription;
  final double? amount;
  final String? fareTag;
  final String? fareCode;

  FlightFare({
    this.paxType,
    this.fareDescription,
    this.amount,
    this.fareTag,
    this.fareCode,
  });

  factory FlightFare.fromJson(Map<String, dynamic> json) => FlightFare(
        paxType: json["paxType"].toString(),
        fareDescription: json["fareDescription"].toString(),
        amount: json["amount"]?.toDouble(),
        fareTag: json["fareTag"].toString(),
        fareCode: json["fareCode"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "paxType": paxType,
        "fareDescription": fareDescription,
        "amount": amount,
        "fareTag": fareTag,
        "fareCode": fareCode,
      };
}

// class MiniRule {
//   final CityPair? journeyPoints;
//   final Type? type;
//   final String? from;
//   final String? to;
//   final Unit? unit;
//   final String? details;

//   MiniRule({
//     this.journeyPoints,
//     this.type,
//     this.from,
//     this.to,
//     this.unit,
//     this.details,
//   });

//   factory MiniRule.fromJson(Map<String, dynamic> json) => MiniRule(
//         journeyPoints: cityPairValues.map[json["JourneyPoints"]]!,
//         type: typeValues.map[json["Type"]]!,
//         from: json["From"],
//         to: json["To"],
//         unit: unitValues.map[json["Unit"]]!,
//         details: json["Details"],
//       );

//   Map<String, dynamic> toJson() => {
//         "JourneyPoints": cityPairValues.reverse[journeyPoints],
//         "Type": typeValues.reverse[type],
//         "From": from,
//         "To": to,
//         "Unit": unitValues.reverse[unit],
//         "Details": details,
//       };
// }

class SegmentInfo {
  final String? cityPair;
  final String? cabinSubClass;
  // final int? seatRemaining;
  final String? cabinClass;
  final String? bookingClass;
  // final int? supplierParameter;

  SegmentInfo({
    this.cityPair,
    this.cabinSubClass,
    // this.seatRemaining,
    this.cabinClass,
    this.bookingClass,
    // this.supplierParameter,
  });

  factory SegmentInfo.fromJson(Map<String, dynamic> json) => SegmentInfo(
        cityPair: json["cityPair"].toString(),
        cabinSubClass: json["cabinSubClass"].toString(),
        // seatRemaining: json["seatRemaining"],
        cabinClass: json["cabinClass"].toString(),
        bookingClass: json["bookingClass"].toString(),
        // supplierParameter: json["supplierParameter"],
      );

  Map<String, dynamic> toJson() => {
        "cityPair": cityPair,
        "cabinSubClass": cabinSubClass,
        // "seatRemaining": seatRemaining,
        "cabinClass": cabinClass,
        "bookingClass": bookingClass,
        // "supplierParameter": supplierParameter,
      };
}

class FlightDetailFlightDetail {
  final String? flightId;
  final String? airLine;
  final String? airLineName;
  final String? airLineLogo;
  final String? duration;
  final String? origin;
  final String? originName;
  final String? originCity;
  final String? originCountry;
  final String? destination;
  final String? destiantionName;
  final String? destinationCity;
  final String? destinationCountry;
  // final String? supplierParameter;
  // final int? supplierId;
  final List<FlightSegment>? flightSegments;
  final FareFamilies? fareFamilies;
  // final bool? isLcc;
  // final bool? isBookOffline;
  final bool? isRefundable;
  // final bool? isPanRequiredAtBook;
  // final bool? isPanRequiredAtTicket;
  // final bool? isPassportRequiredAtBook;
  // final bool? isPassportRequiredAtTicket;
  // final bool? isGstMandatory;
  // final String? resultFareType;
  // final String? supplierKey;

  FlightDetailFlightDetail({
    this.flightId,
    this.airLine,
    this.airLineName,
    this.airLineLogo,
    this.duration,
    this.origin,
    this.originName,
    this.originCity,
    this.originCountry,
    this.destination,
    this.destiantionName,
    this.destinationCity,
    this.destinationCountry,
    // this.supplierParameter,
    // this.supplierId,
    this.flightSegments,
    this.fareFamilies,
    // this.isLcc,
    // this.isBookOffline,
    this.isRefundable,
    // this.isPanRequiredAtBook,
    // this.isPanRequiredAtTicket,
    // this.isPassportRequiredAtBook,
    // this.isPassportRequiredAtTicket,
    // this.isGstMandatory,
    // this.resultFareType,
    // this.supplierKey,
  });

  factory FlightDetailFlightDetail.fromJson(Map<String, dynamic> json) =>
      FlightDetailFlightDetail(
        flightId: json["flightId"].toString(),
        airLine: json["airLine"].toString(),
        airLineName: json["airLineName"].toString(),
        airLineLogo: json["airLineLogo"].toString(),
        duration: json["duration"].toString(),
        origin: json["origin"].toString(),
        originName: json["originName"].toString(),
        originCity: json["originCity"].toString(),
        originCountry: json["originCountry"].toString(),
        destination: json["destination"].toString(),
        destiantionName: json["destiantionName"].toString(),
        destinationCity: json["destinationCity"].toString(),
        destinationCountry: json["destinationCountry"].toString(),
        // supplierParameter: json["supplierParameter"],
        // supplierId: json["supplierId"],
        flightSegments: json["flightSegments"] == null
            ? []
            : List<FlightSegment>.from(
                json["flightSegments"]!.map((x) => FlightSegment.fromJson(x))),
        fareFamilies: json["fareFamilies"] == null
            ? null
            : FareFamilies.fromJson(json["fareFamilies"]),
        // isLcc: json["isLCC"],
        // isBookOffline: json["isBookOffline"],
        isRefundable: json["isRefundable"],
        // isPanRequiredAtBook: json["isPanRequiredAtBook"],
        // isPanRequiredAtTicket: json["isPanRequiredAtTicket"],
        // isPassportRequiredAtBook: json["isPassportRequiredAtBook"],
        // isPassportRequiredAtTicket: json["isPassportRequiredAtTicket"],
        // isGstMandatory: json["isGSTMandatory"],
        // resultFareType: resultFareTypeValues.map[json["resultFareType"]]!,
        // supplierKey: supplierKeyValues.map[json["supplierKey"]]!,
      );

  Map<String, dynamic> toJson() => {
        "flightId": flightId,
        "airLine": airLine,
        "airLineName": airLineName,
        "airLineLogo": airLineLogo,
        "duration": duration,
        "origin": origin,
        "originName": originName,
        "originCity": originCity,
        "originCountry": originCountry,
        "destination": destination,
        "destiantionName": destiantionName,
        "destinationCity": destinationCity,
        "destinationCountry": destinationCountry,
        // "supplierParameter": supplierParameter,
        // "supplierId": supplierId,
        "flightSegments": flightSegments == null
            ? []
            : List<dynamic>.from(flightSegments!.map((x) => x.toJson())),
        "fareFamilies": fareFamilies?.toJson(),
        // "isLCC": isLcc,
        // "isBookOffline": isBookOffline,
        "isRefundable": isRefundable,
        // "isPanRequiredAtBook": isPanRequiredAtBook,
        // "isPanRequiredAtTicket": isPanRequiredAtTicket,
        // "isPassportRequiredAtBook": isPassportRequiredAtBook,
        // "isPassportRequiredAtTicket": isPassportRequiredAtTicket,
        // "isGSTMandatory": isGstMandatory,
        // "resultFareType": resultFareTypeValues.reverse[resultFareType],
        // "supplierKey": supplierKeyValues.reverse[supplierKey],
      };
}

class FlightSegment {
  // final String? segId;
  // final bool? isReturn;
  final String? origin;
  final String? originName;
  final String? originCity;
  final String? originCountry;
  final String? originCountryCode;
  final String? destination;
  final String? destinationName;
  final String? destinationCity;
  final String? destinationCountry;
  final String? destinationCountryCode;
  final DateTime? departureDateTime;
  final DateTime? arrivalDateTime;
  final String? journeyDuration;
  final String? duration;
  // final String? layOverTime;
  final String? flightNumber;
  // final String? operatingAirline;
  // final String? equipmentType;
  // final String? departureTerminal;
  // final String? arrivalTerminal;
  // final String? marketingAirline;
  // final String? operatingFlightNumber;
  // final String? departureTimeZone;
  // final String? arrivalTimeZone;
  // final String? airLineLogo;
  // final String? airLineName;
  final String? checkInBaggage;
  final String? cabinBaggage;

  FlightSegment({
    // this.segId,
    // this.isReturn,
    this.origin,
    this.originName,
    this.originCity,
    this.originCountry,
    this.originCountryCode,
    this.destination,
    this.destinationName,
    this.destinationCity,
    this.destinationCountry,
    this.destinationCountryCode,
    this.departureDateTime,
    this.arrivalDateTime,
    this.journeyDuration,
    this.duration,
    // this.layOverTime,
    this.flightNumber,
    // this.operatingAirline,
    // this.equipmentType,
    // this.departureTerminal,
    // this.arrivalTerminal,
    // this.marketingAirline,
    // this.operatingFlightNumber,
    // this.departureTimeZone,
    // this.arrivalTimeZone,
    // this.airLineLogo,
    // this.airLineName,
    this.checkInBaggage,
    this.cabinBaggage,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) => FlightSegment(
        // segId: json["segId"] ?? "",
        // isReturn: json["isReturn"] ?? false,
        origin: json["origin"].toString(),
        originName: json["originName"].toString(),
        originCity: json["originCity"].toString(),
        originCountry: json["originCountry"].toString(),
        originCountryCode: json["originCountryCode"].toString(),
        destination: json["destination"].toString(),
        destinationName: json["destinationName"].toString(),
        destinationCity: json["destinationCity"].toString(),
        destinationCountry: json["destinationCountry"].toString(),
        destinationCountryCode: json["destinationCountryCode"].toString(),
        departureDateTime: json["departureDateTime"] == null
            ? null
            : DateTime.parse(json["departureDateTime"]),
        arrivalDateTime: json["arrivalDateTime"] == null
            ? null
            : DateTime.parse(json["arrivalDateTime"]),
        journeyDuration: json["journeyDuration"].toString(),
        duration: json["duration"].toString(),
        // layOverTime: json["layOverTime"],
        flightNumber: json["flightNumber"].toString(),
        // operatingAirline: json["operatingAirline"] ?? "",
        // equipmentType: json["equipmentType"] ?? "",
        // departureTerminal: json["departureTerminal"] ?? "",
        // arrivalTerminal: json["arrivalTerminal"] ?? "",
        // marketingAirline: json["marketingAirline"] ?? "",
        // operatingFlightNumber: json["operatingFlightNumber"] ?? "",
        // departureTimeZone: json["departureTimeZone"] ?? "",
        // arrivalTimeZone: json["arrivalTimeZone"] ?? "",
        // airLineLogo: json["airLineLogo"] ?? "",
        // airLineName: json["airLineName"] ?? "",
        checkInBaggage: json["checkInBaggage"] ?? "",
        cabinBaggage: json["cabinBaggage"] ?? "7 kgs",
      );

  Map<String, dynamic> toJson() => {
        // "segId": segId,
        // "isReturn": isReturn,
        "origin": origin,
        "originName": originName,
        "originCity": originCity,
        "originCountry": originCountry,
        "originCountryCode": originCountryCode,
        "destination": destination,
        "destinationName": destinationName,
        "destinationCity": destinationCity,
        "destinationCountry": destinationCountry,
        "destinationCountryCode": destinationCountryCode,
        "departureDateTime": departureDateTime?.toIso8601String(),
        "arrivalDateTime": arrivalDateTime?.toIso8601String(),
        "journeyDuration": journeyDuration,
        "duration": duration,
        // "layOverTime": layOverTime,
        "flightNumber": flightNumber,
        // "operatingAirline": lineValues.reverse[operatingAirline],
        // "equipmentType": equipmentType,
        // "departureTerminal": departureTerminal,
        // "arrivalTerminal": arrivalTerminal,
        // "marketingAirline": lineValues.reverse[marketingAirline],
        // "operatingFlightNumber": operatingFlightNumber,
        // "departureTimeZone": departureTimeZone,
        // "arrivalTimeZone": arrivalTimeZone,
        // "airLineLogo": airLineLogo,
        // "airLineName": airLineNameValues.reverse[airLineName],
        "checkInBaggage": checkInBaggage,
        "cabinBaggage": cabinBaggage,
        // "noOfSeatAvailable": noOfSeatAvailable,
        // "ssrInfo":
        //     ssrInfo == null ? [] : List<dynamic>.from(ssrInfo!.map((x) => x)),
      };
}
