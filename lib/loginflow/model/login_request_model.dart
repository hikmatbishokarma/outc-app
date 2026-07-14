import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Loginrequestauth {
  String Role;
  String UserName;
  String Password;
  String DeviceToken;
  String DeviceType;
  String FirBaseToken;

  Loginrequestauth(
      {required this.Role,
      required this.UserName,
      required this.Password,
      required this.DeviceToken,
      required this.DeviceType,
      required this.FirBaseToken});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "Role": Role.toString().trim(),
      'UserName': UserName.toString().trim(),
      'Password': Password.toString().trim(),
      'DeviceToken': DeviceToken.toString().trim(),
      'DeviceType': DeviceType.toString().trim(),
      'FirBaseToken': FirBaseToken.toString().trim(),
    };
    return map;
  }
}
/////////
///
