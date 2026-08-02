import 'package:json_annotation/json_annotation.dart';

/// POST /admin/user/register (client-shared "Authentication Technical
/// Workflow & API Specification"). JSON key is `Name`, not `FullName` — the
/// Dart property kept its existing name (already used elsewhere in this
/// file's callers) but `toJson()` emits the key the backend actually wants.
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
  int isloginType;

  Registerrequest(
      {required this.Role,
      required this.FullName,
      required this.Email,
      required this.DialingCode,
      required this.Mobile,
      required this.Password,
      required this.DeviceToken,
      required this.DeviceType,
      required this.FirBaseToken,
      required this.isloginType});

  /// Real JSON body — `Role` and `isloginType` go as actual numbers, not
  /// strings (only used by `register`, which is called via `json.encode`,
  /// unlike the legacy form-encoded login calls).
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "Role": int.tryParse(Role) ?? 0,
      'Name': FullName.trim(),
      'Email': Email.trim(),
      'DialingCode': DialingCode.trim(),
      'Mobile': Mobile.trim(),
      'Password': Password.trim(),
      'DeviceToken': DeviceToken.trim(),
      'DeviceType': DeviceType.trim(),
      'FirBaseToken': FirBaseToken.trim(),
      'isloginType': isloginType,
    };
    return map;
  }
}

/// POST /admin/verifyotp. `otp` is blank + `otpType: 2` for the Google
/// auto-verification path — the backend spec's own example, not a
/// workaround.
class VerifyOtpRequest {
  const VerifyOtpRequest({
    required this.userId,
    required this.otp,
    required this.otpType,
    required this.isloginType,
  });

  final String userId;
  final String otp;
  final int otpType;
  final int isloginType;

  Map<String, dynamic> toJson() => {
        'UserID': userId,
        'Otp': otp,
        'OtpType': otpType,
        'isloginType': isloginType,
      };
}

/// POST /admin/resendotp (marked optional in the spec).
class ResendOtpRequest {
  const ResendOtpRequest({required this.userId, required this.email, required this.mobile});

  final String userId;
  final String email;
  final String mobile;

  Map<String, dynamic> toJson() => {
        'UserID': userId,
        'Email': email,
        'Mobile': mobile,
      };
}

/// Response shape confirmed against a real call:
/// `{"status":200,"data":{"userDetails":{"UserId":119,"Email":"..."}}}` —
/// the id is nested under `data.userDetails.UserId`, not directly under
/// `data`. Still checking a couple of alternate spellings/locations
/// defensively in case it varies by response type (e.g. verifyotp).
class RegisterResponse {
  const RegisterResponse({this.status, this.message, this.userId});

  final int? status;
  final String? message;
  final String? userId;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;
    final userDetails = data['userDetails'] is Map<String, dynamic> ? data['userDetails'] as Map<String, dynamic> : null;
    final userId = userDetails?['UserId'] ??
        userDetails?['UserID'] ??
        userDetails?['userId'] ??
        data['UserID'] ??
        data['userId'] ??
        data['UserId'] ??
        json['UserID'] ??
        json['userId'];
    return RegisterResponse(
      status: json['status'] is int ? json['status'] as int : int.tryParse(json['status']?.toString() ?? ''),
      message: json['message']?.toString(),
      userId: userId?.toString(),
    );
  }

  bool get isSuccess => status == 200 || status == 201;
}

class VerifyOtpResponse {
  const VerifyOtpResponse({this.status, this.message});

  final int? status;
  final String? message;

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
        status: json['status'] is int ? json['status'] as int : int.tryParse(json['status']?.toString() ?? ''),
        message: json['message']?.toString(),
      );

  // Confirmed against a real call: verifyotp's own success status is 202,
  // not 200/201 like register/login use — don't assume the family matches.
  bool get isSuccess => status == 200 || status == 201 || status == 202;
}
