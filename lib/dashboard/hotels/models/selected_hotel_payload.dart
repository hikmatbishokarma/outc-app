import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SelectedHotelmodel {
  String traceId;
  String hotelCode;
  String supplier;

  int userId;
  int roleType;
  int membership;

  SelectedHotelmodel({
    this.traceId = "",
    this.hotelCode = "",
    this.supplier = "",
    this.userId = 0,
    this.roleType = 0,
    this.membership = 0,
  });
  factory SelectedHotelmodel.fromJson(Map<String, dynamic> json) =>
      _$SelectedHotelmodelFromJson(json);
  Map<String, dynamic> toJson() => _$SelectedHotelmodelToJson(this);
}

SelectedHotelmodel _$SelectedHotelmodelFromJson(Map<String, dynamic> json) {
  return SelectedHotelmodel(
    traceId: (json['data'] as String),
    hotelCode: (json['data'] as String),
    supplier: (json['data'] as String),
    userId: (json['data'] as int),
    roleType: (json['data'] as int),
    membership: (json['data'] as int),
  );
}

Map<String, dynamic> _$SelectedHotelmodelToJson(SelectedHotelmodel instance) =>
    <String, dynamic>{
      'traceId': instance.traceId,
      'hotelCode': instance.hotelCode,
      'supplier': instance.supplier,
      'userId': instance.userId,
      'roleType': instance.roleType,
      'membership': instance.membership,
    };
