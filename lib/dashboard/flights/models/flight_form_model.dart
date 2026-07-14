// import 'package:json_annotation/json_annotation.dart';

// @JsonSerializable()
// class FlightFormModel {
//   int userId;
//   int roleType;
//   int membership;
//   String traceId;
//   List passengers;
//   List additional_services;
//   // var gstDetails;
//   String creditCardInfo;
//   int insuranceRequired;
//   String promoCode;
//   String currency;
//   int convienenceId;
//   int pgType;
//   double totalPrice;
//   bool isCouponReedem;

//   FlightFormModel({
//     this.userId = 0,
//     this.roleType = 0,
//     this.membership = 0,
//     this.traceId = "",
//     this.passengers = const [],
//     this.additional_services = const [],
//     // this.gstDetails = const [],
//     this.creditCardInfo = "",
//     this.insuranceRequired = 0,
//     this.promoCode = "",
//     this.currency = "",
//     this.convienenceId = 0,
//     this.pgType = 0,
//     this.totalPrice = 0,
//     this.isCouponReedem = false,
//   });
//   factory FlightFormModel.fromJson(Map<String, dynamic> json) =>
//       _$FlightFormModelFromJson(json);
//   Map<dynamic, dynamic> toJson() => _$FlightFormModelToJson(this);
// }

// FlightFormModel _$FlightFormModelFromJson(Map<dynamic, dynamic> json) {
//   return FlightFormModel(
//     userId: (json['data'] as int),
//     roleType: (json['data'] as int),
//     membership: (json['data'] as int),
//     traceId: (json['data'] as String),
//     passengers: (json['data'] as List),
//     additional_services: (json['data'] as List),
//     // gstDetails: (json['data'] as List),
//     creditCardInfo: (json['data'] as String),
//     insuranceRequired: (json['data'] as int),
//     promoCode: (json['data'] as String),
//     currency: (json['data'] as String),
//     convienenceId: (json['data'] as int),
//     pgType: (json['data'] as int),
//     totalPrice: (json['data'] as double),
//     isCouponReedem: (json['data'] as bool),
//   );
// }

// Map<String, dynamic> _$FlightFormModelToJson(FlightFormModel instance) =>
//     <String, dynamic>{
//       'userId': instance.userId,
//       'roleType': instance.roleType,
//       'membership': instance.membership,
//       'traceId': instance.traceId,
//       'passengers': instance.passengers,
//       'additional_services': instance.additional_services,
//       // 'gstDetails': instance.gstDetails,
//       'creditCardInfo': instance.creditCardInfo,
//       'insuranceRequired': instance.insuranceRequired,
//       'promoCode': instance.promoCode,
//       'currency': instance.currency,
//       'convienenceId': instance.convienenceId,
//       'pgType': instance.pgType,
//       'totalPrice': instance.totalPrice,
//       'isCouponReedem': instance.isCouponReedem,
//     };

// class FlightFormModel {
//   int userId;
//   int roleType;
//   int membership;
//   String traceId;
//   List passengers;
//   List additional_services;
//   // var gstDetails;
//   String creditCardInfo;
//   int insuranceRequired;
//   String promoCode;
//   String currency;
//   int convienenceId;
//   int pgType;
//   double totalPrice;
//   bool isCouponReedem;

//   FlightFormModel({
//     required this.userId,
//     required this.roleType,
//     required this.membership,
//     required this.traceId,
//     required this.passengers,
//     required this.additional_services,
//     required this.creditCardInfo,
//     required this.insuranceRequired,
//     required this.promoCode,
//     required this.currency,
//     required this.convienenceId,
//     required this.pgType,
//     required this.totalPrice,
//     required this.isCouponReedem,
//   });

//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> map = {
//       'userId': userId.toInt(),
//       'roleType': roleType.toInt(),
//       'membership': membership.toInt(),
//       'traceId': traceId.toString(),
//       'passengers': passengers.toList(),
//       'additional_services': additional_services.toList(),
//       // 'gstDetails': gstDetails,
//       'creditCardInfo': creditCardInfo.toString(),
//       'insuranceRequired': insuranceRequired.toInt(),
//       'promoCode': promoCode.toString(),
//       'currency': currency.toString(),
//       'convienenceId': convienenceId.toInt(),
//       'pgType': pgType.toInt(),
//       'totalPrice': totalPrice.toDouble(),
//       'isCouponReedem': isCouponReedem,
//     };
//     return map;
//   }
// }
//////
///
// class FlightFormModel {
//   final String traceId;
//   final int userId;
//   final int roleType;
//   final int membership;
//   final List<Map<String, dynamic>> passengers;
//   final List<String> additionalServices;
//   final String creditCardInfo;
//   final int insuranceRequired;
//   final String promoCode;
//   final String currency;
//   final int convienenceId;
//   final int pgType;
//   final double totalPrice;
//   final bool isCouponReedem;

//   FlightFormModel({
//     required this.traceId,
//     required this.userId,
//     required this.roleType,
//     required this.membership,
//     required this.passengers,
//     required this.additionalServices,
//     required this.creditCardInfo,
//     required this.insuranceRequired,
//     required this.promoCode,
//     required this.currency,
//     required this.convienenceId,
//     required this.pgType,
//     required this.totalPrice,
//     required this.isCouponReedem,
//   });

//   factory FlightFormModel.fromJson(Map<String, dynamic> json) {
//     return FlightFormModel(
//       traceId: json['traceId'],
//       userId: json['userId'],
//       roleType: json['roleType'],
//       membership: json['membership'],
//       passengers: List<Map<String, dynamic>>.from(json['passengers']),
//       additionalServices: List<String>.from(json['additional_services']),
//       creditCardInfo: json['creditCardInfo'],
//       insuranceRequired: json['insuranceRequired'],
//       promoCode: json['promoCode'],
//       currency: json['currency'],
//       convienenceId: json['convienenceId'],
//       pgType: json['pgType'],
//       totalPrice: json['totalPrice'].toDouble(),
//       isCouponReedem: json['isCouponReedem'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'traceId': traceId,
//       'userId': userId,
//       'roleType': roleType,
//       'membership': membership,
//       'passengers': passengers,
//       'additional_services': additionalServices,
//       'creditCardInfo': creditCardInfo,
//       'insuranceRequired': insuranceRequired,
//       'promoCode': promoCode,
//       'currency': currency,
//       'convienenceId': convienenceId,
//       'pgType': pgType,
//       'totalPrice': totalPrice,
//       'isCouponReedem': isCouponReedem,
//     };
//   }
// }

// @JsonSerializable()
// class FlightFormModel {
//   int userId;
//   int roleType;
//   int membership;
//   String traceId;
//   List passengers;
//   List additional_services;
//   // var gstDetails;
//   String creditCardInfo;
//   int insuranceRequired;
//   String promoCode;
//   String currency;
//   int convienenceId;
//   int pgType;
//   double totalPrice;
//   bool isCouponReedem;

//   ///

//   FlightFormModel({
//     this.userId = 0,
//     this.roleType = 0,
//     this.membership = 0,
//     this.traceId = "",
//     this.passengers = const [],
//     this.additional_services = const [],
//     // this.gstDetails = const [],
//     this.creditCardInfo = "",
//     this.insuranceRequired = 0,
//     this.promoCode = "",
//     this.currency = "",
//     this.convienenceId = 0,
//     this.pgType = 0,
//     this.totalPrice = 0,
//     this.isCouponReedem = false,
//   });
//   factory FlightFormModel.fromJson(Map<String, dynamic> json) =>
//       _$FlightFormModelFromJson(json);
//   Map<String, dynamic> toJson() => _$FlightFormModelToJson(this);
// }

// FlightFormModel _$FlightFormModelFromJson(Map<String, dynamic> json) {
//   return FlightFormModel(
//     userId: (json['data'] as int),
//     roleType: (json['data'] as int),
//     membership: (json['data'] as int),
//     traceId: (json['data'] as String),
//     passengers: (json['data'] as List),
//     additional_services: (json['data'] as List),
//     // gstDetails: (json['data'] as List),
//     creditCardInfo: (json['data'] as String),
//     insuranceRequired: (json['data'] as int),
//     promoCode: (json['data'] as String),
//     currency: (json['data'] as String),
//     convienenceId: (json['data'] as int),
//     pgType: (json['data'] as int),
//     totalPrice: (json['data'] as double),
//     isCouponReedem: (json['data'] as bool),

//     ///
//   );
// }

// Map<String, dynamic> _$FlightFormModelToJson(FlightFormModel instance) =>
//     <String, dynamic>{
//       'userId': instance.userId,
//       'roleType': instance.roleType,
//       'membership': instance.membership,
//       'traceId': instance.traceId,
//       'passengers': instance.passengers,
//       'additional_services': instance.additional_services,
//       // 'gstDetails': instance.gstDetails,
//       'creditCardInfo': instance.creditCardInfo,
//       'insuranceRequired': instance.insuranceRequired,
//       'promoCode': instance.promoCode,
//       'currency': instance.currency,
//       'convienenceId': instance.convienenceId,
//       'pgType': instance.pgType,
//       'totalPrice': instance.totalPrice,
//       'isCouponReedem': instance.isCouponReedem,
//     };

// class FlightFormModel {
//   String traceId;
//   int userId;
//   int roleType;
//   int membership;
//   List<Passenger> passengers; // Use a custom class for passengers
//   List<dynamic>
//       additionalServices; // Depending on the actual structure, you might want to create a custom class
//   String creditCardInfo;
//   int insuranceRequired;
//   String promoCode;
//   String currency;
//   int convenienceId; // Typo in the field name
//   int pgType;
//   double totalPrice;
//   bool isCouponRedeem; // Typo in the field name

//   FlightFormModel({
//     required this.traceId,
//     required this.userId,
//     required this.roleType,
//     required this.membership,
//     required this.passengers,
//     required this.additionalServices,
//     required this.creditCardInfo,
//     required this.insuranceRequired,
//     required this.promoCode,
//     required this.currency,
//     required this.convenienceId,
//     required this.pgType,
//     required this.totalPrice,
//     required this.isCouponRedeem,
//   });

//   // Factory method to parse JSON
//   factory FlightFormModel.fromJson(Map<String, dynamic> json) {
//     List<dynamic> passengersJson = json['passengers'];
//     List<Passenger> passengers = passengersJson.map((passengerJson) {
//       return Passenger.fromJson(passengerJson);
//     }).toList();

//     return FlightFormModel(
//       traceId: json['traceId'],
//       userId: json['userId'],
//       roleType: json['roleType'],
//       membership: json['membership'],
//       passengers: passengers,
//       additionalServices: json['additional_services'],
//       creditCardInfo: json['creditCardInfo'],
//       insuranceRequired: json['insuranceRequired'],
//       promoCode: json['promoCode'],
//       currency: json['currency'],
//       convenienceId: json['convienenceId'], // Fix the typo
//       pgType: json['pgType'],
//       totalPrice: json['totalPrice'].toDouble(), // Convert to double
//       isCouponRedeem: json['isCouponReedem'], // Fix the typo
//     );
//   }

//   Map<String, dynamic> _$FlightFormModelToJson(FlightFormModel instance) =>
//       <String, dynamic>{
//         'userId': instance.userId,
//         'roleType': instance.roleType,
//         'membership': instance.membership,
//         'traceId': instance.traceId,
//         'passengers': instance.passengers,
//         'additional_services': instance.additionalServices,
//         // 'gstDetails': instance.gstDetails,
//         'creditCardInfo': instance.creditCardInfo,
//         'insuranceRequired': instance.insuranceRequired,
//         'promoCode': instance.promoCode,
//         'currency': instance.currency,
//         'convienenceId': instance.convenienceId,
//         'pgType': instance.pgType,
//         'totalPrice': instance.totalPrice,
//         'isCouponReedem': instance.isCouponRedeem,
//       };
// }

// class Passenger {
//   String title;
//   String firstName;
//   String lastName;
//   String paxType;
//   int pax;
//   String email;
//   String dob;
//   String gender;
//   String mobile;
//   String passengerNationality;
//   String areaCode;
//   String addressCountryCode;
//   String address;
//   List<dynamic>
//       additionalServicesIds; // Depending on the actual structure, you might want to create a custom class

//   Passenger({
//     required this.title,
//     required this.firstName,
//     required this.lastName,
//     required this.paxType,
//     required this.pax,
//     required this.email,
//     required this.dob,
//     required this.gender,
//     required this.mobile,
//     required this.passengerNationality,
//     required this.areaCode,
//     required this.addressCountryCode,
//     required this.address,
//     required this.additionalServicesIds,
//   });

//   factory Passenger.fromJson(Map<String, dynamic> json) {
//     return Passenger(
//       title: json['title'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       paxType: json['paxType'],
//       pax: json['pax'],
//       email: json['email'],
//       dob: json['dob'],
//       gender: json['gender'],
//       mobile: json['mobile'],
//       passengerNationality: json['passengerNationality'],
//       areaCode: json['areaCode'],
//       addressCountryCode: json['address_CountryCode'],
//       address: json['address'],
//       additionalServicesIds: json['additionalServicesIds'],
//     );
//   }
// }

// class FlightFormModel {
//   String traceId;
//   int userId;
//   int roleType;
//   int membership;
//   List<Passenger> passengers;
//   List<dynamic> additionalServices;
//   String creditCardInfo;
//   int insuranceRequired;
//   String promoCode;
//   String currency;
//   int convenienceId;
//   int pgType;
//   double totalPrice;
//   bool isCouponRedeem;

//   FlightFormModel({
//     required this.traceId,
//     required this.userId,
//     required this.roleType,
//     required this.membership,
//     required this.passengers,
//     required this.additionalServices,
//     required this.creditCardInfo,
//     required this.insuranceRequired,
//     required this.promoCode,
//     required this.currency,
//     required this.convenienceId,
//     required this.pgType,
//     required this.totalPrice,
//     required this.isCouponRedeem,
//   });

//   Map<String, dynamic> toJson() {
//     List<Map<String, dynamic>> passengersJson = passengers.map((passenger) {
//       return passenger.toJson();
//     }).toList();

//     return {
//       'traceId': traceId,
//       'userId': userId,
//       'roleType': roleType,
//       'membership': membership,
//       'passengers': passengersJson,
//       'additional_services': additionalServices,
//       'creditCardInfo': creditCardInfo,
//       'insuranceRequired': insuranceRequired,
//       'promoCode': promoCode,
//       'currency': currency,
//       'convienenceId': convenienceId,
//       'pgType': pgType,
//       'totalPrice': totalPrice,
//       'isCouponReedem': isCouponRedeem,
//     };
//   }
// }

// class Passenger {
//   String title;
//   String firstName;
//   String lastName;
//   String paxType;
//   int pax;
//   String email;
//   String dob;
//   String gender;
//   String mobile;
//   String passengerNationality;
//   String areaCode;
//   String addressCountryCode;
//   String address;
//   List<dynamic> additionalServicesIds;

//   Passenger({
//     required this.title,
//     required this.firstName,
//     required this.lastName,
//     required this.paxType,
//     required this.pax,
//     required this.email,
//     required this.dob,
//     required this.gender,
//     required this.mobile,
//     required this.passengerNationality,
//     required this.areaCode,
//     required this.addressCountryCode,
//     required this.address,
//     required this.additionalServicesIds,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'firstName': firstName,
//       'lastName': lastName,
//       'paxType': paxType,
//       'pax': pax,
//       'email': email,
//       'dob': dob,
//       'gender': gender,
//       'mobile': mobile,
//       'passengerNationality': passengerNationality,
//       'areaCode': areaCode,
//       'address_CountryCode': addressCountryCode,
//       'address': address,
//       'additionalServicesIds': additionalServicesIds,
//     };
//   }
// }
