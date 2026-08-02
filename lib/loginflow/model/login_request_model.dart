import 'package:json_annotation/json_annotation.dart';

/// `isloginType` on [Loginrequestauth] matches the backend's `login`
/// endpoint (`mobileLogin.txt`): 1 = password, 2 = Google (confirmed by
/// that file's own comment — Facebook's value isn't confirmed, not needed
/// yet). The older `mobileLogin` endpoint predates this field and ignores
/// it; only `login` branches on it.
class IsLoginType {
  static const password = 1;
  static const google = 2;
}

@JsonSerializable()
class Loginrequestauth {
  String Role;
  String UserName;
  String Password;
  String DeviceToken;
  String DeviceType;
  String FirBaseToken;
  int isloginType;

  Loginrequestauth(
      {required this.Role,
      required this.UserName,
      required this.Password,
      required this.DeviceToken,
      required this.DeviceType,
      required this.FirBaseToken,
      this.isloginType = IsLoginType.password});

  /// Form-encoded body for the legacy `mobileLogin`/`partnerLoginauth`
  /// calls — `http.post`'s Map body requires every value to be a String,
  /// so everything (including numeric-looking fields) is stringified here.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "Role": Role.toString().trim(),
      'UserName': UserName.toString().trim(),
      'Password': Password.toString().trim(),
      'DeviceToken': DeviceToken.toString().trim(),
      'DeviceType': DeviceType.toString().trim(),
      'FirBaseToken': FirBaseToken.toString().trim(),
      'isloginType': isloginType.toString(),
    };
    return map;
  }

  /// Real JSON body for `login` (`admin/login`) — `Role` and `isloginType`
  /// go as actual numbers, not strings, matching what the backend expects
  /// for this endpoint specifically (confirmed — unlike the form-encoded
  /// body above, sent for the older `mobileLogin`).
  Map<String, dynamic> toJsonBody() => {
        "Role": int.tryParse(Role) ?? 0,
        'UserName': UserName.trim(),
        'Password': Password.trim(),
        'DeviceToken': DeviceToken.trim(),
        'DeviceType': DeviceType.trim(),
        'FirBaseToken': FirBaseToken.trim(),
        'isloginType': isloginType,
      };
}
/////////
///
