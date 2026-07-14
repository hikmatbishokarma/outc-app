// To parse this JSON data, do
//
//     final selectedHotelView = selectedHotelViewFromJson(jsonString);

import 'dart:convert';

SelectedHotelView selectedHotelViewFromJson(String str) =>
    SelectedHotelView.fromJson(json.decode(str));

String selectedHotelViewToJson(SelectedHotelView data) =>
    json.encode(data.toJson());

class SelectedHotelView {
  final int? status;
  final String? message;
  final Data? data;

  SelectedHotelView({
    this.status,
    this.message,
    this.data,
  });

  factory SelectedHotelView.fromJson(Map<String, dynamic> json) =>
      SelectedHotelView(
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
  final List<dynamic>? errors;
  final String? traceId;
  final String? roomsId;
  final String? currencyIsoCode;
  final String? hotelCode;
  final String? hotelName;
  final String? starRating;
  final String? city;
  final String? country;
  final String? currency;
  final bool? isAmendmentAllowed;
  final String? supplier;
  // final dynamic reservationPolicy;
  final String? description;
  final String? latitude;
  final String? longitude;
  final List<String>? images;
  // final List<dynamic>? warningsMessage;
  final String? fixedFormat;
  final String? categoryId;
  final bool? isFlightDetailsMandatory;
  // final List<GuestRequiredField>? guestRequiredFields;
  final List<DataCombineRoom>? combineRoom;
  final List<Address>? addresses;
  final HotelContact? hotelContact;
  final List<Attraction>? attractions;
  final List<String>? hotelFacility;
  final dynamic hotelPolicy;
  final dynamic specialInstructions;
  final dynamic policy;
  final String? countryCode;
  final Request? request;

  Data({
    this.errors,
    this.traceId,
    this.roomsId,
    this.currencyIsoCode,
    this.hotelCode,
    this.hotelName,
    this.starRating,
    this.city,
    this.country,
    this.currency,
    this.isAmendmentAllowed,
    this.supplier,
    // this.reservationPolicy,
    this.description,
    this.latitude,
    this.longitude,
    this.images,
    // this.warningsMessage,
    this.fixedFormat,
    this.categoryId,
    this.isFlightDetailsMandatory,
    // this.guestRequiredFields,
    this.combineRoom,
    this.addresses,
    this.hotelContact,
    this.attractions,
    this.hotelFacility,
    this.hotelPolicy,
    this.specialInstructions,
    this.policy,
    this.countryCode,
    this.request,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        errors: json["errors"] == null
            ? []
            : List<dynamic>.from(json["errors"]!.map((x) => x)),
        traceId: json["traceId"] ?? "",
        roomsId: json["roomsId"] ?? "",
        currencyIsoCode: json["currencyISOCode"] ?? "",
        hotelCode: json["hotelCode"] ?? "",
        hotelName: json["hotelName"] ?? "",
        starRating: json["starRating"] ?? "",
        city: json["city"] ?? "",
        country: json["country"] ?? "",
        currency: json["currency"] ?? "",
        isAmendmentAllowed: json["isAmendmentAllowed"] ?? false,
        supplier: json["supplier"],
        // reservationPolicy: json["reservationPolicy"],
        description: json["description"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        // warningsMessage: json["warningsMessage"] == null ? [] : List<dynamic>.from(json["warningsMessage"]!.map((x) => x)),
        fixedFormat: json["fixedFormat"],
        categoryId: json["categoryId"],
        isFlightDetailsMandatory: json["isFlightDetailsMandatory"],
        // guestRequiredFields: json["guestRequiredFields"] == null ? [] : List<GuestRequiredField>.from(json["guestRequiredFields"]!.map((x) => GuestRequiredField.fromJson(x))),
        combineRoom: json["combineRoom"] == null
            ? []
            : List<DataCombineRoom>.from(
                json["combineRoom"]!.map((x) => DataCombineRoom.fromJson(x))),
        addresses: json["addresses"] == null
            ? []
            : List<Address>.from(
                json["addresses"]!.map((x) => Address.fromJson(x))),
        hotelContact: json["hotelContact"] == null
            ? null
            : HotelContact.fromJson(json["hotelContact"]),
        attractions: json["attractions"] == null
            ? []
            : List<Attraction>.from(
                json["attractions"]!.map((x) => Attraction.fromJson(x))),
        hotelFacility: json["hotelFacility"] == null
            ? []
            : List<String>.from(json["hotelFacility"]!.map((x) => x)),
        hotelPolicy: json["hotelPolicy"],
        specialInstructions: json["specialInstructions"],
        policy: json["policy"],
        countryCode: json["countryCode"],
        request:
            json["request"] == null ? null : Request.fromJson(json["request"]),
      );

  Map<String, dynamic> toJson() => {
        "errors":
            errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
        "traceId": traceId,
        "roomsId": roomsId,
        "currencyISOCode": currencyValues.reverse[currencyIsoCode],
        "hotelCode": hotelCode,
        "hotelName": hotelName,
        "starRating": starRating,
        "city": city,
        "country": country,
        "currency": currencyValues.reverse[currency],
        "isAmendmentAllowed": isAmendmentAllowed,
        "supplier": supplier,
        // "reservationPolicy": reservationPolicy,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        // "warningsMessage": warningsMessage == null ? [] : List<dynamic>.from(warningsMessage!.map((x) => x)),
        "fixedFormat": fixedFormat,
        "categoryId": categoryId,
        "isFlightDetailsMandatory": isFlightDetailsMandatory,
        // "guestRequiredFields": guestRequiredFields == null ? [] : List<dynamic>.from(guestRequiredFields!.map((x) => x.toJson())),
        "combineRoom": combineRoom == null
            ? []
            : List<dynamic>.from(combineRoom!.map((x) => x.toJson())),
        "addresses": addresses == null
            ? []
            : List<dynamic>.from(addresses!.map((x) => x.toJson())),
        "hotelContact": hotelContact?.toJson(),
        "attractions": attractions == null
            ? []
            : List<dynamic>.from(attractions!.map((x) => x.toJson())),
        "hotelFacility": hotelFacility == null
            ? []
            : List<dynamic>.from(hotelFacility!.map((x) => x)),
        "hotelPolicy": hotelPolicy,
        "specialInstructions": specialInstructions,
        "policy": policy,
        "countryCode": countryCode,
        "request": request?.toJson(),
      };
}

class Address {
  final String? address;
  final String? cityName;
  final String? postalCode;
  final String? countryCode;

  Address({
    this.address,
    this.cityName,
    this.postalCode,
    this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"],
        cityName: json["cityName"],
        postalCode: json["postalCode"],
        countryCode: json["countryCode"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "cityName": cityName,
        "postalCode": postalCode,
        "countryCode": countryCode,
      };
}

class Attraction {
  final String? key;
  final String? value;

  Attraction({
    this.key,
    this.value,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) => Attraction(
        key: json["Key"],
        value: json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "Key": key,
        "Value": value,
      };
}

class DataCombineRoom {
  final String? categoryId;
  final int? combineRoomId;
  final double? price;
  final int? roomsId;
  final String? isBookable;
  final String? rateKey;
  final String? groupCode;
  final String? rateComments;
  final bool? refundable;
  final PriceDetails? priceDetails;
  final List<CombineRoomCombineRoom>? combineRooms;
  // final List<Inclusion>? inclusions;
  // final List<dynamic>? boardBasis;
  // final dynamic boardingDetails;
  // final int? markup;
  // final int? commission;
  // final int? agentMarkup;
  // final dynamic hotelMinPrice;
  // final dynamic hotelNetPrice;
  // final dynamic hotelPublishPrice;

  DataCombineRoom({
    this.categoryId,
    this.combineRoomId,
    this.price,
    this.roomsId,
    this.isBookable,
    this.rateKey,
    this.groupCode,
    this.rateComments,
    this.refundable,
    this.priceDetails,
    this.combineRooms,
    // this.inclusions,
    // this.boardBasis,
    // this.boardingDetails,
    // this.markup,
    // this.commission,
    // this.agentMarkup,
    // this.hotelMinPrice,
    // this.hotelNetPrice,
    // this.hotelPublishPrice,
  });

  factory DataCombineRoom.fromJson(Map<String, dynamic> json) =>
      DataCombineRoom(
        categoryId: json["categoryId"],
        combineRoomId: json["combineRoomId"],
        price: json["price"]?.toDouble(),
        roomsId: json["roomsId"],
        isBookable: json["isBookable"],
        rateKey: json["rateKey"],
        groupCode: json["groupCode"],
        rateComments: json["rateComments"],
        refundable: json["refundable"],
        priceDetails: json["priceDetails"] == null
            ? null
            : PriceDetails.fromJson(json["priceDetails"]),
        combineRooms: json["combineRooms"] == null
            ? []
            : List<CombineRoomCombineRoom>.from(json["combineRooms"]!
                .map((x) => CombineRoomCombineRoom.fromJson(x))),
        // inclusions: json["inclusions"] == null
        //     ? []
        //     : List<Inclusion>.from(
        //         json["inclusions"]!.map((x) => inclusionValues.map[x]!)),
        // boardBasis: json["boardBasis"] == null
        //     ? []
        //     : List<dynamic>.from(json["boardBasis"]!.map((x) => x)),
        // boardingDetails: json["boardingDetails"],
        // markup: json["markup"],
        // commission: json["commission"],
        // agentMarkup: json["agentMarkup"],
        // hotelMinPrice: json["hotelMinPrice"],
        // hotelNetPrice: json["hotelNetPrice"],
        // hotelPublishPrice: json["hotelPublishPrice"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "combineRoomId": combineRoomId,
        "price": price,
        "roomsId": roomsId,
        "isBookable": isBookable,
        "rateKey": rateKey,
        "groupCode": groupCode,
        "rateComments": rateComments,
        "refundable": refundable,
        "priceDetails": priceDetails?.toJson(),
        "combineRooms": combineRooms == null
            ? []
            : List<dynamic>.from(combineRooms!.map((x) => x.toJson())),
        // "inclusions": inclusions == null
        //     ? []
        //     : List<dynamic>.from(
        //         inclusions!.map((x) => inclusionValues.reverse[x])),
        // "boardBasis": boardBasis == null
        //     ? []
        //     : List<dynamic>.from(boardBasis!.map((x) => x)),
        // "boardingDetails": boardingDetails,
        // "markup": markup,
        // "commission": commission,
        // "agentMarkup": agentMarkup,
        // "hotelMinPrice": hotelMinPrice,
        // "hotelNetPrice": hotelNetPrice,
        // "hotelPublishPrice": hotelPublishPrice,
      };
}

// enum CategoryId { THE_361132466, THE_391132466 }

// final categoryIdValues = EnumValues({
//   "36###1132466": CategoryId.THE_361132466,
//   "39###1132466": CategoryId.THE_391132466
// });

class CombineRoomCombineRoom {
  // final Offer? offer;
  // final List<dynamic>? ratePlans;
  // final String? categoryId;
  // final String? ratePlanId;
  // final List<dynamic>? roomImageList;
  // final int? childCount;
  // final String? roomDesc;
  final int? roomId;
  final String? roomName;
  // final String? roomTypeId;
  // final List<dynamic>? roomSupplement;
  // final bool? isPassportMandatory;
  // final bool? isPanMandatory;
  // final bool? requireAllPaxDetails;
  // final List<dynamic>? breakup;
  final List<CancellationPolicy>? cancellationPolicy;
  // final String? cancellationPolicyDescription;
  // final DateTime? lastCancellationDate;
  // final bool? underCancellation;
  // final DateTime? lastVoucherDate;
  // final Inclusion? ratePlanName;
  // final String? rateType;
  // final bool? refundable;
  // final bool? soldOut;
  // final List<dynamic>? tax;
  // final bool? isInstantAllowed;
  // final SmokingPreference? smokingPreference;
  // final List<Inclusion>? amenities;
  // final List<dynamic>? bedTypes;
  // final List<dynamic>? boardBasis;

  CombineRoomCombineRoom({
    // this.offer,
    // this.ratePlans,
    // this.categoryId,
    // this.ratePlanId,
    // this.roomImageList,
    // this.childCount,
    // this.roomDesc,
    this.roomId,
    this.roomName,
    // this.roomTypeId,
    // this.roomSupplement,
    // this.isPassportMandatory,
    // this.isPanMandatory,
    // this.requireAllPaxDetails,
    // this.breakup,
    this.cancellationPolicy,
    // this.cancellationPolicyDescription,
    // this.lastCancellationDate,
    // this.underCancellation,
    // this.lastVoucherDate,
    // this.ratePlanName,
    // this.rateType,
    // this.refundable,
    // this.soldOut,
    // this.tax,
    // this.isInstantAllowed,
    // this.smokingPreference,
    // this.amenities,
    // this.bedTypes,
    // this.boardBasis,
  });

  factory CombineRoomCombineRoom.fromJson(Map<String, dynamic> json) =>
      CombineRoomCombineRoom(
        // offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),
        // ratePlans: json["ratePlans"] == null
        //     ? []
        //     : List<dynamic>.from(json["ratePlans"]!.map((x) => x)),
        // categoryId: json["categoryId"],
        // ratePlanId: json["ratePlanId"],
        // roomImageList: json["roomImageList"] == null
        //     ? []
        //     : List<dynamic>.from(json["roomImageList"]!.map((x) => x)),
        // childCount: json["childCount"],
        // roomDesc: json["roomDesc"],
        roomId: json["roomId"],
        roomName: json["roomName"],
        // roomTypeId: json["roomTypeId"],
        // roomSupplement: json["roomSupplement"] == null
        //     ? []
        //     : List<dynamic>.from(json["roomSupplement"]!.map((x) => x)),
        // isPassportMandatory: json["isPassportMandatory"],
        // isPanMandatory: json["isPANMandatory"],
        // requireAllPaxDetails: json["requireAllPaxDetails"],
        // breakup: json["breakup"] == null
        //     ? []
        //     : List<dynamic>.from(json["breakup"]!.map((x) => x)),
        cancellationPolicy: json["cancellationPolicy"] == null
            ? []
            : List<CancellationPolicy>.from(json["cancellationPolicy"]!
                .map((x) => CancellationPolicy.fromJson(x))),
        // cancellationPolicyDescription: json["cancellationPolicyDescription"],
        // lastCancellationDate: json["lastCancellationDate"] == null
        //     ? null
        //     : DateTime.parse(json["lastCancellationDate"]),
        // underCancellation: json["underCancellation"],
        // lastVoucherDate: json["lastVoucherDate"] == null
        //     ? null
        //     : DateTime.parse(json["lastVoucherDate"]),
        // ratePlanName: inclusionValues.map[json["ratePlanName"]]!,
        // rateType: json["rateType"],
        // refundable: json["refundable"],
        // soldOut: json["soldOut"],
        // tax: json["tax"] == null
        //     ? []
        //     : List<dynamic>.from(json["tax"]!.map((x) => x)),
        // isInstantAllowed: json["isInstantAllowed"],
        // smokingPreference:
        //     smokingPreferenceValues.map[json["smokingPreference"]]!,
        // amenities: json["amenities"] == null
        //     ? []
        //     : List<Inclusion>.from(
        //         json["amenities"]!.map((x) => inclusionValues.map[x]!)),
        // bedTypes: json["bedTypes"] == null
        //     ? []
        //     : List<dynamic>.from(json["bedTypes"]!.map((x) => x)),
        // boardBasis: json["boardBasis"] == null
        //     ? []
        //     : List<dynamic>.from(json["boardBasis"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        // "offer": offer?.toJson(),
        // "ratePlans": ratePlans == null
        //     ? []
        //     : List<dynamic>.from(ratePlans!.map((x) => x)),
        // "categoryId": categoryId,
        // "ratePlanId": ratePlanId,
        // "roomImageList": roomImageList == null
        //     ? []
        //     : List<dynamic>.from(roomImageList!.map((x) => x)),
        // "childCount": childCount,
        // "roomDesc": roomValues.reverse[roomDesc],
        "roomId": roomId,
        "roomName": roomName,
        // "roomTypeId": roomTypeId,
        // "roomSupplement": roomSupplement == null
        //     ? []
        //     : List<dynamic>.from(roomSupplement!.map((x) => x)),
        // "isPassportMandatory": isPassportMandatory,
        // "isPANMandatory": isPanMandatory,
        // "requireAllPaxDetails": requireAllPaxDetails,
        // "breakup":
        //     breakup == null ? [] : List<dynamic>.from(breakup!.map((x) => x)),
        "cancellationPolicy": cancellationPolicy == null
            ? []
            : List<dynamic>.from(cancellationPolicy!.map((x) => x.toJson())),
        // "cancellationPolicyDescription": cancellationPolicyDescription,
        // "lastCancellationDate": lastCancellationDate?.toIso8601String(),
        // "underCancellation": underCancellation,
        // "lastVoucherDate": lastVoucherDate?.toIso8601String(),
        // "ratePlanName": inclusionValues.reverse[ratePlanName],
        // "rateType": rateType,
        // "refundable": refundable,
        // "soldOut": soldOut,
        // "tax": tax == null ? [] : List<dynamic>.from(tax!.map((x) => x)),
        // "isInstantAllowed": isInstantAllowed,
        // "smokingPreference": smokingPreferenceValues.reverse[smokingPreference],
        // "amenities": amenities == null
        //     ? []
        //     : List<dynamic>.from(
        //         amenities!.map((x) => inclusionValues.reverse[x])),
        // "bedTypes":
        //     bedTypes == null ? [] : List<dynamic>.from(bedTypes!.map((x) => x)),
        // "boardBasis": boardBasis == null
        //     ? []
        //     : List<dynamic>.from(boardBasis!.map((x) => x)),
      };
}

enum Inclusion { FREE_ROOM_UPGRADE_FREE_SELF_PARKING }

final inclusionValues = EnumValues({
  "Free room upgrade,Free self parking ":
      Inclusion.FREE_ROOM_UPGRADE_FREE_SELF_PARKING
});

class CancellationPolicy {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? currency;
  final int? penaltyAmount;
  final String? chargeType;
  final List<String>? policies;
  final String? policyName;

  CancellationPolicy({
    this.fromDate,
    this.toDate,
    this.currency,
    this.penaltyAmount,
    this.chargeType,
    this.policies,
    this.policyName,
  });

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) =>
      CancellationPolicy(
        fromDate:
            json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
        toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
        currency: json["currency"],
        penaltyAmount: json["penaltyAmount"],
        chargeType: json["chargeType"],
        policies: json["policies"] == null
            ? []
            : List<String>.from(json["policies"]!.map((x) => x)),
        policyName: json["policyName"],
      );

  Map<String, dynamic> toJson() => {
        "fromDate": fromDate?.toIso8601String(),
        "toDate": toDate?.toIso8601String(),
        "currency": currency,
        "penaltyAmount": penaltyAmount,
        "chargeType": chargeType,
        "policies":
            policies == null ? [] : List<dynamic>.from(policies!.map((x) => x)),
        "policyName": policyName,
      };
}

enum ChargeType { PERCENTAGE }

final chargeTypeValues = EnumValues({"Percentage": ChargeType.PERCENTAGE});

enum Currency { INR }

final currencyValues = EnumValues({"INR": Currency.INR});

enum PolicyName { CANCELLATION_POLICY }

final policyNameValues =
    EnumValues({"Cancellation Policy": PolicyName.CANCELLATION_POLICY});

class Offer {
  final bool? valid;
  final int? value;

  Offer({
    this.valid,
    this.value,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        valid: json["valid"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "valid": valid,
        "value": value,
      };
}

enum Room { DELUXE_ROOM_NO_AC_1_DOUBLE_BED, DELUXE_ROOM_NO_AC_2_TWIN_BEDS }

final roomValues = EnumValues({
  "Deluxe Room (No Ac),1 Double Bed": Room.DELUXE_ROOM_NO_AC_1_DOUBLE_BED,
  "Deluxe Room (No Ac),2 Twin Beds": Room.DELUXE_ROOM_NO_AC_2_TWIN_BEDS
});

enum SmokingPreference { NO_PREFERENCE }

final smokingPreferenceValues =
    EnumValues({"NoPreference": SmokingPreference.NO_PREFERENCE});

class PriceDetails {
  final String? currency;
  final double? roomPrice;
  final double? totalBasePrice;
  final double? otherCharges;
  final double? serviceTax;
  final double? totalPrice;
  final double? totalTax;
  final double? agentCommission;
  final int? extraGuestCharges;
  final int? totalRoundedOff;
  // final dynamic hotelCharges;
  // final int? markup;
  // final int? commission;
  // final int? agentMarkup;

  PriceDetails({
    this.currency,
    this.roomPrice,
    this.totalBasePrice,
    this.otherCharges,
    this.serviceTax,
    this.totalPrice,
    this.totalTax,
    this.agentCommission,
    this.extraGuestCharges,
    this.totalRoundedOff,
    // this.hotelCharges,
    // this.markup,
    // this.commission,
    // this.agentMarkup,
  });

  factory PriceDetails.fromJson(Map<String, dynamic> json) => PriceDetails(
        currency: json["currency"],
        roomPrice: json["roomPrice"]?.toDouble(),
        totalBasePrice: json["totalBasePrice"]?.toDouble(),
        otherCharges: json["otherCharges"]?.toDouble(),
        serviceTax: json["serviceTax"]?.toDouble(),
        totalPrice: json["totalPrice"]?.toDouble(),
        totalTax: json["totalTax"]?.toDouble(),
        agentCommission: json["agentCommission"]?.toDouble(),
        extraGuestCharges: json["extraGuestCharges"],
        totalRoundedOff: json["totalRoundedOff"],
        // hotelCharges: json["hotelCharges"],
        // markup: json["markup"],
        // commission: json["commission"],
        // agentMarkup: json["agentMarkup"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "roomPrice": roomPrice,
        "totalBasePrice": totalBasePrice,
        "otherCharges": otherCharges,
        "serviceTax": serviceTax,
        "totalPrice": totalPrice,
        "totalTax": totalTax,
        "agentCommission": agentCommission,
        "extraGuestCharges": extraGuestCharges,
        "totalRoundedOff": totalRoundedOff,
        // "hotelCharges": hotelCharges,
        // "markup": markup,
        // "commission": commission,
        // "agentMarkup": agentMarkup,
      };
}

class GuestRequiredField {
  final int? roomId;
  final String? ratePlanId;
  final GuestMode? guestMode;
  final bool? passportNo;
  final bool? passportDoi;
  final bool? passportDoe;
  final bool? pan;

  GuestRequiredField({
    this.roomId,
    this.ratePlanId,
    this.guestMode,
    this.passportNo,
    this.passportDoi,
    this.passportDoe,
    this.pan,
  });

  factory GuestRequiredField.fromJson(Map<String, dynamic> json) =>
      GuestRequiredField(
        roomId: json["roomId"],
        ratePlanId: json["ratePlanId"],
        guestMode: guestModeValues.map[json["guestMode"]]!,
        passportNo: json["passportNo"],
        passportDoi: json["passportDOI"],
        passportDoe: json["passportDOE"],
        pan: json["pan"],
      );

  Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "ratePlanId": ratePlanId,
        "guestMode": guestModeValues.reverse[guestMode],
        "passportNo": passportNo,
        "passportDOI": passportDoi,
        "passportDOE": passportDoe,
        "pan": pan,
      };
}

enum GuestMode { ALL }

final guestModeValues = EnumValues({"All": GuestMode.ALL});

class HotelContact {
  final String? phone;
  final String? fax;

  HotelContact({
    this.phone,
    this.fax,
  });

  factory HotelContact.fromJson(Map<String, dynamic> json) => HotelContact(
        phone: json["phone"],
        fax: json["fax"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "fax": fax,
      };
}

class Request {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String? hotelCityCode;
  final List<RoomGuest>? roomGuests;
  final String? nationality;
  final String? countryCode;
  final bool? isHotelDescriptionRequried;
  final Currency? currency;
  final String? traceId;
  final int? userId;
  final int? roleType;
  final int? membership;

  Request({
    this.checkInDate,
    this.checkOutDate,
    this.hotelCityCode,
    this.roomGuests,
    this.nationality,
    this.countryCode,
    this.isHotelDescriptionRequried,
    this.currency,
    this.traceId,
    this.userId,
    this.roleType,
    this.membership,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        checkInDate: json["checkInDate"] == null
            ? null
            : DateTime.parse(json["checkInDate"]),
        checkOutDate: json["checkOutDate"] == null
            ? null
            : DateTime.parse(json["checkOutDate"]),
        hotelCityCode: json["hotelCityCode"],
        roomGuests: json["roomGuests"] == null
            ? []
            : List<RoomGuest>.from(
                json["roomGuests"]!.map((x) => RoomGuest.fromJson(x))),
        nationality: json["nationality"],
        countryCode: json["countryCode"],
        isHotelDescriptionRequried: json["isHotelDescriptionRequried"],
        currency: currencyValues.map[json["currency"]]!,
        traceId: json["traceId"],
        userId: json["userId"],
        roleType: json["roleType"],
        membership: json["membership"],
      );

  Map<String, dynamic> toJson() => {
        "checkInDate":
            "${checkInDate!.year.toString().padLeft(4, '0')}-${checkInDate!.month.toString().padLeft(2, '0')}-${checkInDate!.day.toString().padLeft(2, '0')}",
        "checkOutDate":
            "${checkOutDate!.year.toString().padLeft(4, '0')}-${checkOutDate!.month.toString().padLeft(2, '0')}-${checkOutDate!.day.toString().padLeft(2, '0')}",
        "hotelCityCode": hotelCityCode,
        "roomGuests": roomGuests == null
            ? []
            : List<dynamic>.from(roomGuests!.map((x) => x.toJson())),
        "nationality": nationality,
        "countryCode": countryCode,
        "isHotelDescriptionRequried": isHotelDescriptionRequried,
        "currency": currencyValues.reverse[currency],
        "traceId": traceId,
        "userId": userId,
        "roleType": roleType,
        "membership": membership,
      };
}

class RoomGuest {
  final int? noOfAdults;
  final int? noOfChilds;
  final List<dynamic>? childAge;

  RoomGuest({
    this.noOfAdults,
    this.noOfChilds,
    this.childAge,
  });

  factory RoomGuest.fromJson(Map<String, dynamic> json) => RoomGuest(
        noOfAdults: json["noOfAdults"],
        noOfChilds: json["noOfChilds"],
        childAge: json["childAge"] == null
            ? []
            : List<dynamic>.from(json["childAge"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "noOfAdults": noOfAdults,
        "noOfChilds": noOfChilds,
        "childAge":
            childAge == null ? [] : List<dynamic>.from(childAge!.map((x) => x)),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
