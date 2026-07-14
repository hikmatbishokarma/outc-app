// To parse this JSON data, do
//
//     final visaList = visaListFromJson(jsonString);

import 'dart:convert';

VisaList visaListFromJson(String str) => VisaList.fromJson(json.decode(str));

String visaListToJson(VisaList data) => json.encode(data.toJson());

class VisaList {
    final int? status;
    final List<Datum>? data;
    final String? message;

    VisaList({
        this.status,
        this.data,
        this.message,
    });

    factory VisaList.fromJson(Map<String, dynamic> json) => VisaList(
        status: json["status"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class Datum {
    final int? id;
    final String? country;
    final String? continent;
    final String? typeofVisa;
    final String? visaName;
    final int? processingTime;
    final int? stayperiod;
    final int? validity;
    final String? entry;
    final int? fees;
    final String? currency;
    final String? visaPriceIncludes;
    final int? status;
    final String? visaDescription;
    final String? overView;
    final int? visaCode;
    final String? whychooseUs;
    final String? howWeCanHelp;
    final DateTime? createdAt;
    final DateTime? modifiedAt;
    final List<DocsReqForVisa>? docsReqForVisa;
    final EmbassyDetails? embassyDetails;
    final List<VisaFaq>? visaFaq;
    final List<Image>? images;

    Datum({
        this.id,
        this.country,
        this.continent,
        this.typeofVisa,
        this.visaName,
        this.processingTime,
        this.stayperiod,
        this.validity,
        this.entry,
        this.fees,
        this.currency,
        this.visaPriceIncludes,
        this.status,
        this.visaDescription,
        this.overView,
        this.visaCode,
        this.whychooseUs,
        this.howWeCanHelp,
        this.createdAt,
        this.modifiedAt,
        this.docsReqForVisa,
        this.embassyDetails,
        this.visaFaq,
        this.images,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["Id"],
        country: json["Country"],
        continent: json["Continent"],
        typeofVisa: json["TypeofVisa"],
        visaName: json["VisaName"],
        processingTime: json["ProcessingTime"],
        stayperiod: json["Stayperiod"],
        validity: json["Validity"],
        entry: json["Entry"],
        fees: json["Fees"],
        currency: json["Currency"],
        visaPriceIncludes: json["VisaPriceIncludes"],
        status: json["Status"],
        visaDescription: json["VisaDescription"],
        overView: json["OverView"],
        visaCode: json["visaCode"],
        whychooseUs: json["whychooseUs"],
        howWeCanHelp: json["howWeCanHelp"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        modifiedAt: json["modifiedAt"] == null ? null : DateTime.parse(json["modifiedAt"]),
        docsReqForVisa: json["docsReqForVisa"] == null ? [] : List<DocsReqForVisa>.from(json["docsReqForVisa"]!.map((x) => DocsReqForVisa.fromJson(x))),
        embassyDetails: json["embassyDetails"] == null ? null : EmbassyDetails.fromJson(json["embassyDetails"]),
        visaFaq: json["visaFaq"] == null ? [] : List<VisaFaq>.from(json["visaFaq"]!.map((x) => VisaFaq.fromJson(x))),
        images: json["Images"] == null ? [] : List<Image>.from(json["Images"]!.map((x) => Image.fromJson(x))),
    );

  get length => null;

    Map<String, dynamic> toJson() => {
        "Id": id,
        "Country": country,
        "Continent": continent,
        "TypeofVisa": typeofVisa,
        "VisaName": visaName,
        "ProcessingTime": processingTime,
        "Stayperiod": stayperiod,
        "Validity": validity,
        "Entry": entry,
        "Fees": fees,
        "Currency": currency,
        "VisaPriceIncludes": visaPriceIncludes,
        "Status": status,
        "VisaDescription": visaDescription,
        "OverView": overView,
        "visaCode": visaCode,
        "whychooseUs": whychooseUs,
        "howWeCanHelp": howWeCanHelp,
        "createdAt": createdAt?.toIso8601String(),
        "modifiedAt": modifiedAt?.toIso8601String(),
        "docsReqForVisa": docsReqForVisa == null ? [] : List<dynamic>.from(docsReqForVisa!.map((x) => x.toJson())),
        "embassyDetails": embassyDetails?.toJson(),
        "visaFaq": visaFaq == null ? [] : List<dynamic>.from(visaFaq!.map((x) => x.toJson())),
        "Images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    };
}

class DocsReqForVisa {
    final int? id;
    final String? visaName;
    final int? visaId;
    final String? essentialsDocs;
    final String? otherDocs;
    final dynamic supportingDocuments;
    final DateTime? createdAt;
    final DateTime? modifiedAt;

    DocsReqForVisa({
        this.id,
        this.visaName,
        this.visaId,
        this.essentialsDocs,
        this.otherDocs,
        this.supportingDocuments,
        this.createdAt,
        this.modifiedAt,
    });

    factory DocsReqForVisa.fromJson(Map<String, dynamic> json) => DocsReqForVisa(
        id: json["Id"],
        visaName: json["visaName"],
        visaId: json["visaId"],
        essentialsDocs: json["essentialsDocs"],
        otherDocs: json["otherDocs"],
        supportingDocuments: json["supportingDocuments"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        modifiedAt: json["modifiedAt"] == null ? null : DateTime.parse(json["modifiedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "visaName": visaName,
        "visaId": visaId,
        "essentialsDocs": essentialsDocs,
        "otherDocs": otherDocs,
        "supportingDocuments": supportingDocuments,
        "createdAt": createdAt?.toIso8601String(),
        "modifiedAt": modifiedAt?.toIso8601String(),
    };
}

class EmbassyDetails {
    final int? id;
    final String? visaName;
    final int? visaId;
    final String? basicReq;
    final String? travelCheckList;
    final String? embassyAddress;
    final dynamic embassyAddress2;
    final dynamic embassyAddress3;
    final dynamic embassyAddress4;
    final dynamic embassyAddress5;
    final String? embassyContact;
    final dynamic embassyContact2;
    final dynamic embassyContact3;
    final dynamic embassyContact4;
    final dynamic embassyContact5;
    final String? embassyEmail;
    final dynamic embassyEmail2;
    final dynamic embassyEmail3;
    final dynamic embassyEmail4;
    final String? embassyUrl;
    final String? region;
    final String? capital;
    final String? majorCity;
    final String? language;
    final String? area;
    final String? currency;
    final String? mainAirline;
    final DateTime? independenceDay;
    final String? internationalAirport;
    final String? bestTimeToVisit;
    final DateTime? createdAt;
    final DateTime? modifiedAt;

    EmbassyDetails({
        this.id,
        this.visaName,
        this.visaId,
        this.basicReq,
        this.travelCheckList,
        this.embassyAddress,
        this.embassyAddress2,
        this.embassyAddress3,
        this.embassyAddress4,
        this.embassyAddress5,
        this.embassyContact,
        this.embassyContact2,
        this.embassyContact3,
        this.embassyContact4,
        this.embassyContact5,
        this.embassyEmail,
        this.embassyEmail2,
        this.embassyEmail3,
        this.embassyEmail4,
        this.embassyUrl,
        this.region,
        this.capital,
        this.majorCity,
        this.language,
        this.area,
        this.currency,
        this.mainAirline,
        this.independenceDay,
        this.internationalAirport,
        this.bestTimeToVisit,
        this.createdAt,
        this.modifiedAt,
    });

    factory EmbassyDetails.fromJson(Map<String, dynamic> json) => EmbassyDetails(
        id: json["Id"],
        visaName: json["visaName"],
        visaId: json["visaId"],
        basicReq: json["basicReq"],
        travelCheckList: json["travelCheckList"],
        embassyAddress: json["embassyAddress"],
        embassyAddress2: json["embassyAddress2"],
        embassyAddress3: json["embassyAddress3"],
        embassyAddress4: json["embassyAddress4"],
        embassyAddress5: json["embassyAddress5"],
        embassyContact: json["embassyContact"],
        embassyContact2: json["embassyContact2"],
        embassyContact3: json["embassyContact3"],
        embassyContact4: json["embassyContact4"],
        embassyContact5: json["embassyContact5"],
        embassyEmail: json["embassyEmail"],
        embassyEmail2: json["embassyEmail2"],
        embassyEmail3: json["embassyEmail3"],
        embassyEmail4: json["embassyEmail4"],
        embassyUrl: json["embassyUrl"],
        region: json["region"],
        capital: json["capital"],
        majorCity: json["majorCity"],
        language: json["language"],
        area: json["area"],
        currency: json["currency"],
        mainAirline: json["mainAirline"],
        independenceDay: json["independenceDay"] == null ? null : DateTime.parse(json["independenceDay"]),
        internationalAirport: json["internationalAirport"],
        bestTimeToVisit: json["bestTimeToVisit"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        modifiedAt: json["modifiedAt"] == null ? null : DateTime.parse(json["modifiedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "visaName": visaName,
        "visaId": visaId,
        "basicReq": basicReq,
        "travelCheckList": travelCheckList,
        "embassyAddress": embassyAddress,
        "embassyAddress2": embassyAddress2,
        "embassyAddress3": embassyAddress3,
        "embassyAddress4": embassyAddress4,
        "embassyAddress5": embassyAddress5,
        "embassyContact": embassyContact,
        "embassyContact2": embassyContact2,
        "embassyContact3": embassyContact3,
        "embassyContact4": embassyContact4,
        "embassyContact5": embassyContact5,
        "embassyEmail": embassyEmail,
        "embassyEmail2": embassyEmail2,
        "embassyEmail3": embassyEmail3,
        "embassyEmail4": embassyEmail4,
        "embassyUrl": embassyUrl,
        "region": region,
        "capital": capital,
        "majorCity": majorCity,
        "language": language,
        "area": area,
        "currency": currency,
        "mainAirline": mainAirline,
        "independenceDay": independenceDay?.toIso8601String(),
        "internationalAirport": internationalAirport,
        "bestTimeToVisit": bestTimeToVisit,
        "createdAt": createdAt?.toIso8601String(),
        "modifiedAt": modifiedAt?.toIso8601String(),
    };
}

class Image {
    final int? id;
    final int? visaId;
    final String? image;
    final DateTime? createdAt;
    final dynamic modifiedAt;

    Image({
        this.id,
        this.visaId,
        this.image,
        this.createdAt,
        this.modifiedAt,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["Id"],
        visaId: json["visaId"],
        image: json["Image"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        modifiedAt: json["modifiedAt"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "visaId": visaId,
        "Image": image,
        "createdAt": createdAt?.toIso8601String(),
        "modifiedAt": modifiedAt,
    };
}

class VisaFaq {
    final int? id;
    final String? visaName;
    final int? visaId;
    final String? title;
    final String? description;
    final DateTime? createdAt;
    final DateTime? modifiedAt;

    VisaFaq({
        this.id,
        this.visaName,
        this.visaId,
        this.title,
        this.description,
        this.createdAt,
        this.modifiedAt,
    });

    factory VisaFaq.fromJson(Map<String, dynamic> json) => VisaFaq(
        id: json["Id"],
        visaName: json["visaName"],
        visaId: json["visaId"],
        title: json["title"],
        description: json["description"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        modifiedAt: json["modifiedAt"] == null ? null : DateTime.parse(json["modifiedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "visaName": visaName,
        "visaId": visaId,
        "title": title,
        "description": description,
        "createdAt": createdAt?.toIso8601String(),
        "modifiedAt": modifiedAt?.toIso8601String(),
    };
}
