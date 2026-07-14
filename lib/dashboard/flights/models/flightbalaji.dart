import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class FlightFormRequestModel {
  int? pgType;
  int? userId;
  int? roleType;
  int? membership;
  String? traceId;
  int? currencyRatio;

  List<Passenger> passengers;
  List? additionalServices;
  GstDetails? gstDetails;
  String? creditCardInfo;
  String? promoData;

  String? currency;
  int? convienenceId;
  int? insuranceRequired;
  double? totalPrice;
  bool? isCouponReedem;

  FlightFormRequestModel({
    this.pgType,
    this.userId,
    this.traceId,
    required this.passengers,
    this.gstDetails,
    this.creditCardInfo,
    this.additionalServices,
    this.promoData,
    this.roleType,
    this.currency,
    this.membership,
    this.currencyRatio,
    this.convienenceId,
    this.insuranceRequired,
    this.totalPrice,
    this.isCouponReedem,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'pgType': pgType,
      'userId': userId,
      'traceId': traceId,
      "roleType": roleType,
      "membership": membership,
      "currency": currency,
      "currencyRatio": currencyRatio,
      'passengers': passengers.map((passenger) => passenger.toJson()).toList(),
      'gstDetails': gstDetails?.toJson(),
      'creditCardInfo': creditCardInfo,
      'promoData': promoData,
      'additional_services': additionalServices,
      'convienenceId': convienenceId,
      'insuranceRequired': insuranceRequired,
      'totalPrice': totalPrice,
      'isCouponReedem': isCouponReedem,
    };
  }
}

class Passenger {
  String title;
  String firstName;
  String lastName;

  // String ffNumber;
  String paxType;
  int pax;
  String email;
  String dob;
  String gender;
  String mobile;
  // String passportNumber;
  String passengerNationality;
  // String passportDOI;
  // String passportDOE;
  // String passportIssuedCountry;
  // String seatPref;
  List mealPref;
  List baggagePref;
  List additionalServicesIds;
  String address;
  String areaCode;
  // List<String> additionalServicesIds;
  String address_CountryCode;
  // String countryName;
  // String city;

  Passenger(
      {required this.title,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.dob,
      required this.gender,
      required this.areaCode,
      // required this.ffNumber,
      required this.paxType,
      required this.mobile,
      // required this.passportNumber,
      required this.passengerNationality,
      // required this.passportDOI,
      // required this.passportDOE,
      // required this.passportIssuedCountry,
      // required this.seatPref,
      required this.mealPref,
      required this.address,
      required this.additionalServicesIds,
      required this.address_CountryCode,
      // required this.countryName,
      // required this.city,
      required this.baggagePref,
      required this.pax});
  Map<dynamic, dynamic> toJson() {
    return {
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dob': dob,
      'gender': gender,
      'areaCode': areaCode,
      // 'ffNumber': ffNumber,
      'paxType': paxType,
      'mobile': mobile,
      // 'passportNumber': passportNumber,
      'passengerNationality': passengerNationality,
      // 'passportDOI': passportDOI,
      // 'passportDOE': passportDOE,
      // 'passportIssuedCountry': passportIssuedCountry,
      // 'seatPref': seatPref,
      'mealPref': mealPref,
      'address': address,
      'additionalServicesIds': additionalServicesIds,
      'address_CountryCode': address_CountryCode,
      // 'countryName': countryName,
      // 'city': city,
      'pax': pax,
      'baggagePref': baggagePref,
    };
  }
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

  Map<dynamic, dynamic> toJson() {
    return {
      'gstAddressLine1': gstAddressLine1,
      'gstAddressLine2': gstAddressLine2,
      'gstCity': gstCity,
      'gstState': gstState,
      'gstpinCode': gstpinCode,
      'gstEmailId': gstEmailId,
      'gstNumber': gstNumber,
      'gstPhoneNo': gstPhoneNo,
      'gstCompanyName': gstCompanyName,
    };
  }
}
