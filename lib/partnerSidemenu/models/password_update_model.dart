import 'package:outc/widgets/sharedprefservices.dart';

class Passwordupdaterequestmodel {
  String newPassword;
  String oldPassword;
  // String userID;

  Passwordupdaterequestmodel(
      {required this.newPassword, required this.oldPassword});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'NewPassword': newPassword.trim(),
      'OldPassword': oldPassword.trim(),
      'UserID': SharedPrefServices.getcustomerId().toString(),
    };
    return map;
  }
}
