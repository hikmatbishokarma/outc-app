// To parse this JSON data, do
//
//     final loginauth = loginauthFromJson(jsonString);

import 'dart:convert';

Loginauth loginauthFromJson(String str) => Loginauth.fromJson(json.decode(str));

String loginauthToJson(Loginauth data) => json.encode(data.toJson());

class Loginauth {
  final String? accessToken;
  final Data? data;
  final int? status;
  final String? message;

  Loginauth({
    this.accessToken,
    this.data,
    this.status,
    this.message,
  });

  factory Loginauth.fromJson(Map<String, dynamic> json) => Loginauth(
        accessToken: json["accessToken"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "data": data?.toJson(),
        "status": status,
        "message": message,
      };
}

class Data {
  final UserDetails? userDetails;

  Data({
    this.userDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userDetails: json["userDetails"] == null
            ? null
            : UserDetails.fromJson(json["userDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "userDetails": userDetails?.toJson(),
      };
}

class UserDetails {
  final int? userId;
  // final List<dynamic>? services;
  // final int? membership;
  // final dynamic agencyName;
  final String? email;
  final String? mobile;
  final String? title;
  final int? gender;
  final String? firstName;
  final String? lastName;
  // final dynamic profilePic;
  // final int? status;
  // final DateTime? dob;
  // final dynamic city;
  // final dynamic countryId;
  // final dynamic pan;
  // final dynamic adhaarCard;
  // final dynamic passport;
  // final dynamic voterId;
  // final dynamic licenseNumber;
  // final String? panUpload;
  // final String? adhaarCardUpload;
  // final String? gstUpload;
  // final String? passportUpload;
  // final String? comments;
  // final String? otherDocumentsUpload;
  // final Role? role;
  // final List<dynamic>? screens;
  // final String? agentId;
  final Walletdetails? walletdetails;

  UserDetails({
    this.userId,
    // this.services,
    // this.membership,
    // this.agencyName,
    this.email,
    this.mobile,
    this.title,
    this.gender,
    this.firstName,
    this.lastName,
    // this.profilePic,
    // this.status,
    // this.dob,
    // this.city,
    // this.countryId,
    // this.pan,
    // this.adhaarCard,
    // this.passport,
    // this.voterId,
    // this.licenseNumber,
    // this.panUpload,
    // this.adhaarCardUpload,
    // this.gstUpload,
    // this.passportUpload,
    // this.comments,
    // this.otherDocumentsUpload,
    // this.role,
    // this.screens,
    // this.agentId,
    this.walletdetails,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        userId: json["UserID"],
        // services: json["Services"] == null
        //     ? []
        //     : List<dynamic>.from(json["Services"]!.map((x) => x)),
        // membership: json["Membership"],
        // agencyName: json["AgencyName"],
        email: json["Email"],
        mobile: json["Mobile"],
        title: json["Title"],
        gender: json["Gender"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        // profilePic: json["ProfilePic"],
        // status: json["Status"],
        // dob: json["DOB"] == null ? null : DateTime.parse(json["DOB"]),
        // city: json["City"],
        // countryId: json["CountryId"],
        // pan: json["PAN"],
        // adhaarCard: json["AdhaarCard"],
        // passport: json["Passport"],
        // voterId: json["VoterId"],
        // licenseNumber: json["LicenseNumber"],
        // panUpload: json["PANUpload"],
        // adhaarCardUpload: json["AdhaarCardUpload"],
        // gstUpload: json["GSTUpload"],
        // passportUpload: json["PassportUpload"],
        // comments: json["Comments"],
        // otherDocumentsUpload: json["OtherDocumentsUpload"],
        // role: json["Role"] == null ? null : Role.fromJson(json["Role"]),
        // screens: json["Screens"] == null
        //     ? []
        //     : List<dynamic>.from(json["Screens"]!.map((x) => x)),
        // agentId: json["AgentID"],
        walletdetails: json["Walletdetails"] == null
            ? null
            : Walletdetails.fromJson(json["Walletdetails"]),
      );

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        // "Services":
        //     services == null ? [] : List<dynamic>.from(services!.map((x) => x)),
        // "Membership": membership,
        // "AgencyName": agencyName,
        "Email": email,
        "Mobile": mobile,
        "Title": title,
        "Gender": gender,
        "FirstName": firstName,
        "LastName": lastName,
        // "ProfilePic": profilePic,
        // "Status": status,
        // "DOB": dob?.toIso8601String(),
        // "City": city,
        // "CountryId": countryId,
        // "PAN": pan,
        // "AdhaarCard": adhaarCard,
        // "Passport": passport,
        // "VoterId": voterId,
        // "LicenseNumber": licenseNumber,
        // "PANUpload": panUpload,
        // "AdhaarCardUpload": adhaarCardUpload,
        // "GSTUpload": gstUpload,
        // "PassportUpload": passportUpload,
        // "Comments": comments,
        // "OtherDocumentsUpload": otherDocumentsUpload,
        // "Role": role?.toJson(),
        // "Screens":
        //     screens == null ? [] : List<dynamic>.from(screens!.map((x) => x)),
        // "AgentID": agentId,
        "Walletdetails": walletdetails?.toJson(),
      };
}

// class Role {
//   final String? name;
//   final int? roleLevel;
//   final int? roleId;

//   Role({
//     this.name,
//     this.roleLevel,
//     this.roleId,
//   });

//   factory Role.fromJson(Map<String, dynamic> json) => Role(
//         name: json["Name"],
//         roleLevel: json["RoleLevel"],
//         roleId: json["RoleId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Name": name,
//         "RoleLevel": roleLevel,
//         "RoleId": roleId,
//       };
// }

class Walletdetails {
  final int? userWalletId;
  final int? amount;
  final int? userId;

  Walletdetails({
    this.userWalletId,
    this.amount,
    this.userId,
  });

  factory Walletdetails.fromJson(Map<String, dynamic> json) => Walletdetails(
        userWalletId: json["UserWalletId"],
        amount: json["Amount"],
        userId: json["UserID"],
      );

  Map<String, dynamic> toJson() => {
        "UserWalletId": userWalletId,
        "Amount": amount,
        "UserID": userId,
      };
}
