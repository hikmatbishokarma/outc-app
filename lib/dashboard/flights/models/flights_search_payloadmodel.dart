import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ListModel {
  List originDestinations;
  int adultCount;
  String airTravelType;
  String cabinClass;
  int childCount;
  String excludeCarrier;
  int flightDateFlex;
  String includeCarrier;
  int infantCount;
  String itineraryViewType;
  int membership;
  String priceForTrip;
  int roleType;
  String stopOver;

  // int flightType;
  int userId;

  ListModel({
    this.adultCount = 0,
    this.childCount = 0,
    this.infantCount = 0,
    this.cabinClass = "",
    this.includeCarrier = "",
    this.excludeCarrier = "",
    this.stopOver = "",
    this.airTravelType = "",
    this.flightDateFlex = 0,
    this.itineraryViewType = "",
    this.originDestinations = const [],
    // this.flightType = 0,
    this.priceForTrip = "",
    this.userId = 0,
    this.roleType = 0,
    this.membership = 0,
  });
  factory ListModel.fromJson(Map<String, dynamic> json) =>
      _$ListModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListModelToJson(this);
}

ListModel _$ListModelFromJson(Map<String, dynamic> json) {
  return ListModel(
    adultCount: (json['data'] as int),
    childCount: (json['data'] as int),
    infantCount: (json['data'] as int),
    cabinClass: (json['data'] as String),
    includeCarrier: (json['data'] as String),
    excludeCarrier: (json['data'] as String),
    stopOver: (json['data'] as String),
    airTravelType: (json['data'] as String),
    priceForTrip: (json['data'] as String),
    flightDateFlex: (json['data'] as int),
    itineraryViewType: (json['data'] as String),
    originDestinations: (json['data'] as List),
    // flightType: (json['data'] as int),
    userId: (json['data'] as int),
    roleType: (json['data'] as int),
    membership: (json['data'] as int),
  );
}

Map<String, dynamic> _$ListModelToJson(ListModel instance) => <String, dynamic>{
      'originDestinations': instance.originDestinations,
      'adultCount': instance.adultCount,
      'childCount': instance.childCount,
      'infantCount': instance.infantCount,
      'cabinClass': instance.cabinClass,
      'includeCarrier': instance.includeCarrier,
      'excludeCarrier': instance.excludeCarrier,
      'stopOver': instance.stopOver,
      'flightDateFlex': instance.flightDateFlex,
      'itineraryViewType': instance.itineraryViewType,
      'airTravelType': instance.airTravelType,
      'priceForTrip': instance.priceForTrip,
      // 'flightType': instance.flightType,
      'userId': instance.userId,
      'roleType': instance.roleType,
      'membership': instance.membership,
    };
