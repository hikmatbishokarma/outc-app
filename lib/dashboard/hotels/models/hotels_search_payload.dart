import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ListModelHotels {
  List roomGuests;
  String checkOutDate;
  String checkInDate;
  String hotelCityCode;
  String hotelCityName;
  String nationality;
  String countryCode;
  bool isHotelDescriptionRequried;
  String currency;
  int userId;
  int roleType;
  int membership;

  ListModelHotels({
    this.checkOutDate = "",
    this.checkInDate = "",
    this.hotelCityCode = "",
    this.hotelCityName = "",
    this.nationality = "",
    this.countryCode = "",
    this.isHotelDescriptionRequried = false,
    this.roomGuests = const [],
    this.currency = "",
    this.userId = 0,
    this.roleType = 0,
    this.membership = 0,
  });
  factory ListModelHotels.fromJson(Map<String, dynamic> json) =>
      _$ListModelHotelsFromJson(json);
  Map<String, dynamic> toJson() => _$ListModelHotelsToJson(this);
}

ListModelHotels _$ListModelHotelsFromJson(Map<String, dynamic> json) {
  return ListModelHotels(
    checkOutDate: (json['data'] as String),
    checkInDate: (json['data'] as String),
    hotelCityCode: (json['data'] as String),
    hotelCityName: (json['data'] as String),
    nationality: (json['data'] as String),
    countryCode: (json['data'] as String),
    currency: (json['data'] as String),
    roomGuests: (json['data'] as List),
    isHotelDescriptionRequried: (json['data'] as bool),
    userId: (json['data'] as int),
    roleType: (json['data'] as int),
    membership: (json['data'] as int),
  );
}

Map<String, dynamic> _$ListModelHotelsToJson(ListModelHotels instance) =>
    <String, dynamic>{
      'checkOutDate': instance.checkOutDate,
      'checkInDate': instance.checkInDate,
      'hotelCityCode': instance.hotelCityCode,
      'hotelCityName': instance.hotelCityName,
      'nationality': instance.nationality,
      'countryCode': instance.countryCode,
      'roomGuests': instance.roomGuests,
      'currency': instance.currency,
      'isHotelDescriptionRequried': instance.isHotelDescriptionRequried,
      'userId': instance.userId,
      'roleType': instance.roleType,
      'membership': instance.membership,
    };
