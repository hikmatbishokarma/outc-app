// To parse this JSON data, do
//
//     final hotelsList = hotelsListFromJson(jsonString);

import 'dart:convert';

HotelsList hotelsListFromJson(String str) =>
    HotelsList.fromJson(json.decode(str));

String hotelsListToJson(HotelsList data) => json.encode(data.toJson());

class HotelsList {
  final int? status;
  final String? message;
  final Data? data;

  HotelsList({
    this.status,
    this.message,
    this.data,
  });

  factory HotelsList.fromJson(Map<String, dynamic> json) => HotelsList(
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
  final int? total;
  final List<Error>? errors;
  final String? traceId;
  final List<Hotel>? hotels;
  final Filters? filters;

  Data({
    this.total,
    this.errors,
    this.traceId,
    this.hotels,
    this.filters,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        errors: json["errors"] == null
            ? []
            : List<Error>.from(json["errors"]!.map((x) => Error.fromJson(x))),
        traceId: json["traceId"],
        hotels: json["hotels"] == null
            ? []
            : List<Hotel>.from(json["hotels"]!.map((x) => Hotel.fromJson(x))),
        filters:
            json["filters"] == null ? null : Filters.fromJson(json["filters"]),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "errors": errors == null
            ? []
            : List<dynamic>.from(errors!.map((x) => x.toJson())),
        "traceId": traceId,
        "hotels": hotels == null
            ? []
            : List<dynamic>.from(hotels!.map((x) => x.toJson())),
        "filters": filters?.toJson(),
      };
}

class Error {
  final int? errorCode;
  final String? errorMessage;

  Error({
    this.errorCode,
    this.errorMessage,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        errorCode: json["errorCode"],
        errorMessage: json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "errorCode": errorCode,
        "errorMessage": errorMessage,
      };
}

class Filters {
  // final List<dynamic>? amenities;
  final Price? price;
  // final List<HotelFacility>? property;
  // final List<dynamic>? roomAmenities;
  final List<Amendment>? rating;
  // final List<Amendment>? amendment;
  // final List<dynamic>? tdRating;
  // final List<HotelFacility>? hotelFacilities;
  // final List<dynamic>? addresses;
  // final List<dynamic>? categoryListess;

  Filters({
    // this.amenities,
    this.price,
    // this.property,
    // this.roomAmenities,
    this.rating,
    // this.amendment,
    // this.tdRating,
    // this.hotelFacilities,
    // this.addresses,
    // this.categoryListess,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        // amenities: json["amenities"] == null ? [] : List<dynamic>.from(json["amenities"]!.map((x) => x)),
        price: json["price"] == null ? null : Price.fromJson(json["price"]),
        // property: json["property"] == null ? [] : List<HotelFacility>.from(json["property"]!.map((x) => HotelFacility.fromJson(x))),
        // roomAmenities: json["roomAmenities"] == null ? [] : List<dynamic>.from(json["roomAmenities"]!.map((x) => x)),
        rating: json["rating"] == null
            ? []
            : List<Amendment>.from(
                json["rating"]!.map((x) => Amendment.fromJson(x))),
        // amendment: json["amendment"] == null ? [] : List<Amendment>.from(json["amendment"]!.map((x) => Amendment.fromJson(x))),
        // tdRating: json["tdRating"] == null ? [] : List<dynamic>.from(json["tdRating"]!.map((x) => x)),
        // hotelFacilities: json["hotelFacilities"] == null ? [] : List<HotelFacility>.from(json["hotelFacilities"]!.map((x) => HotelFacility.fromJson(x))),
        // addresses: json["addresses"] == null ? [] : List<dynamic>.from(json["addresses"]!.map((x) => x)),
        // categoryListess: json["categoryListess"] == null ? [] : List<dynamic>.from(json["categoryListess"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        // "amenities": amenities == null ? [] : List<dynamic>.from(amenities!.map((x) => x)),
        "price": price?.toJson(),
        // "property": property == null ? [] : List<dynamic>.from(property!.map((x) => x.toJson())),
        // "roomAmenities": roomAmenities == null ? [] : List<dynamic>.from(roomAmenities!.map((x) => x)),
        "rating": rating == null
            ? []
            : List<dynamic>.from(rating!.map((x) => x.toJson())),
        // "amendment": amendment == null ? [] : List<dynamic>.from(amendment!.map((x) => x.toJson())),
        // "tdRating": tdRating == null ? [] : List<dynamic>.from(tdRating!.map((x) => x)),
        // "hotelFacilities": hotelFacilities == null ? [] : List<dynamic>.from(hotelFacilities!.map((x) => x.toJson())),
        // "addresses": addresses == null ? [] : List<dynamic>.from(addresses!.map((x) => x)),
        // "categoryListess": categoryListess == null ? [] : List<dynamic>.from(categoryListess!.map((x) => x)),
      };
}

class Amendment {
  final int? id;
  final String? label;
  final bool? isChecked;

  Amendment({
    this.id,
    this.label,
    this.isChecked,
  });

  factory Amendment.fromJson(Map<String, dynamic> json) => Amendment(
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

class HotelFacility {
  final String? id;
  final String? label;
  final bool? isChecked;

  HotelFacility({
    this.id,
    this.label,
    this.isChecked,
  });

  factory HotelFacility.fromJson(Map<String, dynamic> json) => HotelFacility(
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

class Price {
  final double? minPrice;
  final double? maxPrice;
  final double? maxPriceRange;
  final double? minPriceRange;

  Price({
    this.minPrice,
    this.maxPrice,
    this.maxPriceRange,
    this.minPriceRange,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        minPrice: json["minPrice"]?.toDouble(),
        maxPrice: json["maxPrice"]?.toDouble(),
        maxPriceRange: json["maxPriceRange"]?.toDouble(),
        minPriceRange: json["minPriceRange"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "minPrice": minPrice,
        "maxPrice": maxPrice,
        "maxPriceRange": maxPriceRange,
        "minPriceRange": minPriceRange,
      };
}

class Hotel {
  final String? hotelCode;
  final String? hotelName;
  final List<String>? images;
  // final double? hotelMinPrice;
  // final double? roomPrice;
  // final double? serviceTax;
  // final int? otherCharges;
  // final int? extraGuestCharge;
  // final bool? isFlightDetailsMandatory;
  final String? supplier;
  final int? starRating;
  // final City? city;
  // final String? countryCode;
  // final String? countryName;
  // final double? latitude;
  // final double? longitude;
  // final String? description;
  // final List<HotelFacility>? hotelFacility;
  final List<Address>? addresses;
  // final List<dynamic>? hotelContact;
  // final String? policy;
  // final List<dynamic>? warningsMessage;
  // final bool? isAmendmentAllowed;
  // final Offer? offer;
  // final List<dynamic>? attractions;
  // final List<dynamic>? notification;
  // final List<dynamic>? pointOfInterest;
  final double? hotelNetPrice;
  // final double? hotelPublishPrice;
  // final int? markup;
  // final int? commission;
  // final double? roomBasePrice;

  Hotel({
    this.hotelCode,
    this.hotelName,
    this.images,
    // this.hotelMinPrice,
    // this.roomPrice,
    // this.serviceTax,
    // this.otherCharges,
    // this.extraGuestCharge,
    // this.isFlightDetailsMandatory,
    this.supplier,
    this.starRating,
    // this.city,
    // this.countryCode,
    // this.countryName,
    // this.latitude,
    // this.longitude,
    // this.description,
    // this.hotelFacility,
    this.addresses,
    // this.hotelContact,
    // this.policy,
    // this.warningsMessage,
    // this.isAmendmentAllowed,
    // this.offer,
    // this.attractions,
    // this.notification,
    // this.pointOfInterest,
    this.hotelNetPrice,
    // this.hotelPublishPrice,
    // this.markup,
    // this.commission,
    // this.roomBasePrice,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
        hotelCode: json["hotelCode"],
        hotelName: json["hotelName"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        // hotelMinPrice: json["hotelMinPrice"]?.toDouble(),
        // roomPrice: json["roomPrice"]?.toDouble(),
        // serviceTax: json["serviceTax"]?.toDouble(),
        // otherCharges: json["otherCharges"],
        // extraGuestCharge: json["extraGuestCharge"],
        // isFlightDetailsMandatory: json["isFlightDetailsMandatory"],
        supplier: json["supplier"],
        starRating: json["starRating"],
        // city: cityValues.map[json["city"]]!,
        // countryCode: json["countryCode"],
        // countryName: json["countryName"],
        // latitude: json["latitude"]?.toDouble(),
        // longitude: json["longitude"]?.toDouble(),
        // description: json["description"],
        // hotelFacility: json["hotelFacility"] == null ? [] : List<HotelFacility>.from(json["hotelFacility"]!.map((x) => hotelFacilityValues.map[x]!)),
        addresses: json["addresses"] == null
            ? []
            : List<Address>.from(
                json["addresses"]!.map((x) => Address.fromJson(x))),
        // hotelContact: json["hotelContact"] == null ? [] : List<dynamic>.from(json["hotelContact"]!.map((x) => x)),
        // policy: json["policy"],
        // warningsMessage: json["warningsMessage"] == null ? [] : List<dynamic>.from(json["warningsMessage"]!.map((x) => x)),
        // isAmendmentAllowed: json["isAmendmentAllowed"],
        // offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),
        // attractions: json["attractions"] == null ? [] : List<dynamic>.from(json["attractions"]!.map((x) => x)),
        // notification: json["notification"] == null ? [] : List<dynamic>.from(json["notification"]!.map((x) => x)),
        // pointOfInterest: json["pointOfInterest"] == null ? [] : List<dynamic>.from(json["pointOfInterest"]!.map((x) => x)),
        hotelNetPrice: json["hotelNetPrice"]?.toDouble(),
        // hotelPublishPrice: json["hotelPublishPrice"]?.toDouble(),
        // markup: json["markup"],
        // commission: json["commission"],
        // roomBasePrice: json["roomBasePrice"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "hotelCode": hotelCode,
        "hotelName": hotelName,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        // "hotelMinPrice": hotelMinPrice,
        // "roomPrice": roomPrice,
        // "serviceTax": serviceTax,
        // "otherCharges": otherCharges,
        // "extraGuestCharge": extraGuestCharge,
        // "isFlightDetailsMandatory": isFlightDetailsMandatory,
        "supplier": supplier,
        "starRating": starRating,
        // "city": city,
        // "countryCode": countryCode,
        // "countryName": countryName,
        // "latitude": latitude,
        // "longitude": longitude,
        // "description": description,
        // "hotelFacility": hotelFacility == null ? [] : List<dynamic>.from(hotelFacility!.map((x) => hotelFacilityValues.reverse[x])),
        "addresses": addresses == null
            ? []
            : List<dynamic>.from(addresses!.map((x) => x.toJson())),
        // "hotelContact": hotelContact == null ? [] : List<dynamic>.from(hotelContact!.map((x) => x)),
        // "policy": policy,
        // "warningsMessage": warningsMessage == null ? [] : List<dynamic>.from(warningsMessage!.map((x) => x)),
        // "isAmendmentAllowed": isAmendmentAllowed,
        // "offer": offer?.toJson(),
        // "attractions": attractions == null ? [] : List<dynamic>.from(attractions!.map((x) => x)),
        // "notification": notification == null ? [] : List<dynamic>.from(notification!.map((x) => x)),
        // "pointOfInterest": pointOfInterest == null ? [] : List<dynamic>.from(pointOfInterest!.map((x) => x)),
        "hotelNetPrice": hotelNetPrice,
        // "hotelPublishPrice": hotelPublishPrice,
        // "markup": markup,
        // "commission": commission,
        // "roomBasePrice": roomBasePrice,
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
        address: json["address"] ?? "",
        cityName: json["cityName"] ?? "",
        postalCode: json["postalCode"] ?? "",
        countryCode: json["countryCode"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "cityName": cityName,
        "postalCode": postalCode,
        "countryCode": countryCode,
      };
}

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
