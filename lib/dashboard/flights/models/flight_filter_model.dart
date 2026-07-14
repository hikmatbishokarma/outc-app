class FlightFilterlist {
  final String? flightId;
  final String? airLine;
  final String? airLineName;
  final String? supplierParameter;
  final int? supplierId;
  final String? origin;
  final String? originName;
  final String? originCity;
  final String? originCountry;
  final String? destination;
  final String? destinationName;
  final String? destinationCity;
  final String? destinationCountry;
  final String? duration;
  final String? airLineLogo;
  final List<FlightSegment>? flightSegments;
  final FareFamilies? fareFamilies;
  final bool? isBookOffline;
  final String? supplierKey;

  FlightFilterlist({
    this.flightId,
    this.airLine,
    this.airLineName,
    this.supplierParameter,
    this.supplierId,
    this.origin,
    this.originName,
    this.originCity,
    this.originCountry,
    this.destination,
    this.destinationName,
    this.destinationCity,
    this.destinationCountry,
    this.duration,
    this.airLineLogo,
    this.flightSegments,
    this.fareFamilies,
    this.isBookOffline,
    this.supplierKey,
  });

  factory FlightFilterlist.fromJson(Map<String, dynamic> json) =>
      FlightFilterlist(
        flightId: json["flightId"],
        airLine: json["airLine"],
        airLineName: json["airLineName"],
        supplierParameter: json["supplierParameter"],
        supplierId: json["supplierId"],
        origin: json["origin"],
        originName: json["originName"],
        originCity: json["originCity"],
        originCountry: json["originCountry"],
        destination: json["destination"],
        destinationName: json["destinationName"],
        destinationCity: json["destinationCity"],
        destinationCountry: json["destinationCountry"],
        duration: json["duration"],
        airLineLogo: json["airLineLogo"],
        flightSegments: json["flightSegments"] == null
            ? []
            : List<FlightSegment>.from(
                json["flightSegments"]!.map((x) => FlightSegment.fromJson(x))),
        fareFamilies: json["fareFamilies"] == null
            ? null
            : FareFamilies.fromJson(json["fareFamilies"]),
        isBookOffline: json["isBookOffline"],
        supplierKey: json["supplierKey"],
      );

  Map<String, dynamic> toJson() => {
        "flightId": flightId,
        "airLine": airLine,
        "airLineName": airLineName,
        "supplierParameter": supplierParameter,
        "supplierId": supplierId,
        "origin": origin,
        "originName": originName,
        "originCity": originCity,
        "originCountry": originCountry,
        "destination": destination,
        "destinationName": destinationName,
        "destinationCity": destinationCity,
        "destinationCountry": destinationCountry,
        "duration": duration,
        "airLineLogo": airLineLogo,
        "flightSegments": flightSegments == null
            ? []
            : List<dynamic>.from(flightSegments!.map((x) => x.toJson())),
        "fareFamilies": fareFamilies?.toJson(),
        "isBookOffline": isBookOffline,
        "supplierKey": supplierKey,
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
        fareId: json["fareId"],
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
  final String? purchaseType;
  final String? fareType;
  final String? coupanType;
  final String? currency;
  final String? supplierParameter;
  final List<FlightFare>? flightFares;
  final List<FareRule>? fareRules;
  final List<Baggage>? baggage;
  final List<dynamic>? miniRules;
  final List<SegmentInfo>? segmentInfos;
  final bool? isRefundable;
  final bool? isGstMandatory;
  final int? commission;
  final int? plb;
  final int? markup;
  final int? publishedFare;
  final double? adultNetFare;
  final int? childNetFare;
  final int? infantNetFare;
  final int? totalNetFare;
  final double? adultPublishFare;
  final double? adultFare;

  FareFamily({
    this.purchaseType,
    this.fareType,
    this.coupanType,
    this.currency,
    this.supplierParameter,
    this.flightFares,
    this.fareRules,
    this.baggage,
    this.miniRules,
    this.segmentInfos,
    this.isRefundable,
    this.isGstMandatory,
    this.commission,
    this.plb,
    this.markup,
    this.publishedFare,
    this.adultNetFare,
    this.childNetFare,
    this.infantNetFare,
    this.totalNetFare,
    this.adultPublishFare,
    this.adultFare,
  });

  factory FareFamily.fromJson(Map<String, dynamic> json) => FareFamily(
        purchaseType: json["purchaseType"],
        fareType: json["fareType"],
        coupanType: json["coupanType"],
        currency: json["currency"],
        supplierParameter: json["supplierParameter"],
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
        miniRules: json["miniRules"] == null
            ? []
            : List<dynamic>.from(json["miniRules"]!.map((x) => x)),
        segmentInfos: json["segmentInfos"] == null
            ? []
            : List<SegmentInfo>.from(
                json["segmentInfos"]!.map((x) => SegmentInfo.fromJson(x))),
        isRefundable: json["isRefundable"],
        isGstMandatory: json["isGstMandatory"],
        commission: json["commission"],
        plb: json["plb"],
        markup: json["markup"],
        publishedFare: json["publishedFare"],
        adultNetFare: json["adultNetFare"]?.toDouble(),
        childNetFare: json["childNetFare"],
        infantNetFare: json["infantNetFare"],
        totalNetFare: json["totalNetFare"],
        adultPublishFare: json["adultPublishFare"]?.toDouble(),
        adultFare: json["adultFare"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "purchaseType": purchaseType,
        "fareType": fareType,
        "coupanType": coupanType,
        "currency": currency,
        "supplierParameter": supplierParameter,
        "flightFares": flightFares == null
            ? []
            : List<dynamic>.from(flightFares!.map((x) => x.toJson())),
        "fareRules": fareRules == null
            ? []
            : List<dynamic>.from(fareRules!.map((x) => x.toJson())),
        "baggage": baggage == null
            ? []
            : List<dynamic>.from(baggage!.map((x) => x.toJson())),
        "miniRules": miniRules == null
            ? []
            : List<dynamic>.from(miniRules!.map((x) => x)),
        "segmentInfos": segmentInfos == null
            ? []
            : List<dynamic>.from(segmentInfos!.map((x) => x.toJson())),
        "isRefundable": isRefundable,
        "isGstMandatory": isGstMandatory,
        "commission": commission,
        "plb": plb,
        "markup": markup,
        "publishedFare": publishedFare,
        "adultNetFare": adultNetFare,
        "childNetFare": childNetFare,
        "infantNetFare": infantNetFare,
        "totalNetFare": totalNetFare,
        "adultPublishFare": adultPublishFare,
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
        airline: json["airline"],
        paxType: json["paxType"],
        baggageInfo: json["baggageInfo"],
        cityPair: json["cityPair"],
        cabinBaggageInfo: json["cabinBaggageInfo"],
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
  final String? paxType;
  final String? cityPair;
  final String? fareBasis;
  final String? supplierParameter;
  final String? ruleDetails;

  FareRule({
    this.paxType,
    this.cityPair,
    this.fareBasis,
    this.supplierParameter,
    this.ruleDetails,
  });

  factory FareRule.fromJson(Map<String, dynamic> json) => FareRule(
        paxType: json["paxType"],
        cityPair: json["cityPair"],
        fareBasis: json["fareBasis"],
        supplierParameter: json["supplierParameter"],
        ruleDetails: json["ruleDetails"],
      );

  Map<String, dynamic> toJson() => {
        "paxType": paxType,
        "cityPair": cityPair,
        "fareBasis": fareBasis,
        "supplierParameter": supplierParameter,
        "ruleDetails": ruleDetails,
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
        paxType: json["paxType"],
        fareDescription: json["fareDescription"],
        amount: json["amount"]?.toDouble(),
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

class SegmentInfo {
  final String? cityPair;
  final String? bookingClass;
  final int? seatRemaining;
  final String? cabinClass;

  SegmentInfo({
    this.cityPair,
    this.bookingClass,
    this.seatRemaining,
    this.cabinClass,
  });

  factory SegmentInfo.fromJson(Map<String, dynamic> json) => SegmentInfo(
        cityPair: json["cityPair"],
        bookingClass: json["bookingClass"],
        seatRemaining: json["seatRemaining"],
        cabinClass: json["cabinClass"],
      );

  Map<String, dynamic> toJson() => {
        "cityPair": cityPair,
        "bookingClass": bookingClass,
        "seatRemaining": seatRemaining,
        "cabinClass": cabinClass,
      };
}

class FlightSegment {
  final String? segId;
  final String? departureCountryName;
  final String? arrivalCountryName;
  final bool? isReturn;
  final String? origin;
  final String? destination;
  final DateTime? departureDateTime;
  final DateTime? arrivalDateTime;
  final String? journeyDuration;
  final String? flightNumber;
  final String? operatingAirline;
  final String? equipmentType;
  final String? marketingAirline;
  final String? departureTerminal;
  final String? arrivalTerminal;
  final List<dynamic>? stopOverSegments;
  final String? airLineName;
  final String? originName;
  final String? destiantionName;

  FlightSegment({
    this.segId,
    this.departureCountryName,
    this.arrivalCountryName,
    this.isReturn,
    this.origin,
    this.destination,
    this.departureDateTime,
    this.arrivalDateTime,
    this.journeyDuration,
    this.flightNumber,
    this.operatingAirline,
    this.equipmentType,
    this.marketingAirline,
    this.departureTerminal,
    this.arrivalTerminal,
    this.stopOverSegments,
    this.airLineName,
    this.originName,
    this.destiantionName,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) => FlightSegment(
        segId: json["segId"],
        departureCountryName: json["departureCountryName"],
        arrivalCountryName: json["arrivalCountryName"],
        isReturn: json["isReturn"],
        origin: json["origin"],
        destination: json["destination"],
        departureDateTime: json["departureDateTime"] == null
            ? null
            : DateTime.parse(json["departureDateTime"]),
        arrivalDateTime: json["arrivalDateTime"] == null
            ? null
            : DateTime.parse(json["arrivalDateTime"]),
        journeyDuration: json["journeyDuration"],
        flightNumber: json["flightNumber"],
        operatingAirline: json["operatingAirline"],
        equipmentType: json["equipmentType"],
        marketingAirline: json["marketingAirline"],
        departureTerminal: json["departureTerminal"],
        arrivalTerminal: json["arrivalTerminal"],
        stopOverSegments: json["stopOverSegments"] == null
            ? []
            : List<dynamic>.from(json["stopOverSegments"]!.map((x) => x)),
        airLineName: json["airLineName"],
        originName: json["originName"],
        destiantionName: json["destiantionName"],
      );

  Map<String, dynamic> toJson() => {
        "segId": segId,
        "departureCountryName": departureCountryName,
        "arrivalCountryName": arrivalCountryName,
        "isReturn": isReturn,
        "origin": origin,
        "destination": destination,
        "departureDateTime": departureDateTime?.toIso8601String(),
        "arrivalDateTime": arrivalDateTime?.toIso8601String(),
        "journeyDuration": journeyDuration,
        "flightNumber": flightNumber,
        "operatingAirline": operatingAirline,
        "equipmentType": equipmentType,
        "marketingAirline": marketingAirline,
        "departureTerminal": departureTerminal,
        "arrivalTerminal": arrivalTerminal,
        "stopOverSegments": stopOverSegments == null
            ? []
            : List<dynamic>.from(stopOverSegments!.map((x) => x)),
        "airLineName": airLineName,
        "originName": originName,
        "destiantionName": destiantionName,
      };
}
