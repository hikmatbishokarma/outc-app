// To parse this JSON data, do
//
//     final getDepositsResponse = getDepositsResponseFromJson(jsonString);

import 'dart:convert';

GetDepositsResponse getDepositsResponseFromJson(String str) =>
    GetDepositsResponse.fromJson(json.decode(str));

String getDepositsResponseToJson(GetDepositsResponse data) =>
    json.encode(data.toJson());

class GetDepositsResponse {
  final int? status;
  final String? message;
  final List<Datum>? data;

  GetDepositsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetDepositsResponse.fromJson(Map<String, dynamic> json) =>
      GetDepositsResponse(
        status: json["status"],
        message: json["Message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final int? depositeType;
  final int? amount;
  final DateTime? depositeDate;
  final dynamic accountNumber;
  final dynamic transactionId;
  final dynamic addrRevoke;
  final dynamic benificiaryBankId;
  final String? remarks;
  final int? paymentType;
  final int? requestStatus;
  final String? status;
  final int? creditAmount;
  final String? deviceOsVersion;
  final String? deviceToken;
  final int? applicationType;
  final String? firBaseToken;
  final String? referenceNumber;
  final DateTime? createdDate;
  final String? role;
  final String? expiryDate;
  final String? userName;
  final int? userId;
  final String? agentId;

  Datum({
    this.depositeType,
    this.amount,
    this.depositeDate,
    this.accountNumber,
    this.transactionId,
    this.addrRevoke,
    this.benificiaryBankId,
    this.remarks,
    this.paymentType,
    this.requestStatus,
    this.status,
    this.creditAmount,
    this.deviceOsVersion,
    this.deviceToken,
    this.applicationType,
    this.firBaseToken,
    this.referenceNumber,
    this.createdDate,
    this.role,
    this.expiryDate,
    this.userName,
    this.userId,
    this.agentId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        depositeType: json["DepositeType"],
        amount: json["Amount"],
        depositeDate: json["DepositeDate"] == null
            ? null
            : DateTime.parse(json["DepositeDate"]),
        accountNumber: json["AccountNumber"],
        transactionId: json["TransactionId"],
        addrRevoke: json["AddrRevoke"],
        benificiaryBankId: json["BenificiaryBankId"],
        remarks: json["Remarks"],
        paymentType: json["PaymentType"],
        requestStatus: json["RequestStatus"],
        status: json["Status"],
        creditAmount: json["CreditAmount"],
        deviceOsVersion: json["DeviceOSVersion"],
        deviceToken: json["DeviceToken"],
        applicationType: json["ApplicationType"],
        firBaseToken: json["FirBaseToken"],
        referenceNumber: json["ReferenceNumber"],
        createdDate: json["CreatedDate"] == null
            ? null
            : DateTime.parse(json["CreatedDate"]),
        role: json["Role"],
        expiryDate: json["ExpiryDate"],
        userName: json["UserName"],
        userId: json["UserID"],
        agentId: json["AgentID"],
      );

  Map<String, dynamic> toJson() => {
        "DepositeType": depositeType,
        "Amount": amount,
        "DepositeDate": depositeDate?.toIso8601String(),
        "AccountNumber": accountNumber,
        "TransactionId": transactionId,
        "AddrRevoke": addrRevoke,
        "BenificiaryBankId": benificiaryBankId,
        "Remarks": remarks,
        "PaymentType": paymentType,
        "RequestStatus": requestStatus,
        "Status": status,
        "CreditAmount": creditAmount,
        "DeviceOSVersion": deviceOsVersion,
        "DeviceToken": deviceToken,
        "ApplicationType": applicationType,
        "FirBaseToken": firBaseToken,
        "ReferenceNumber": referenceNumber,
        "CreatedDate": createdDate?.toIso8601String(),
        "Role": role,
        "ExpiryDate": expiryDate,
        "UserName": userName,
        "UserID": userId,
        "AgentID": agentId,
      };
}
