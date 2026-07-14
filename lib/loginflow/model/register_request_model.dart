import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Registerrequest {
  String Role;
  String FullName;
  String Email;
  String DialingCode;
  String Mobile;
  String Password;
  String DeviceToken;
  String DeviceType;
  String FirBaseToken;

  Registerrequest(
      {required this.Role,
      required this.FullName,
      required this.Email,
      required this.DialingCode,
      required this.Mobile,
      required this.Password,
      required this.DeviceToken,
      required this.DeviceType,
      required this.FirBaseToken});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "Role": Role.toString().trim(),
      'FullName': FullName.toString().trim(),
      'Email': Email.toString().trim(),
      'DialingCode': DialingCode.toString().trim(),
      'Mobile': Mobile.toString().trim(),
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
