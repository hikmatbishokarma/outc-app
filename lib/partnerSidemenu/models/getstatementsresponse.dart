// To parse this JSON data, do
//
//     final getStatementsResponse = getStatementsResponseFromJson(jsonString);

import 'dart:convert';

GetStatementsResponse getStatementsResponseFromJson(String str) =>
    GetStatementsResponse.fromJson(json.decode(str));

String getStatementsResponseToJson(GetStatementsResponse data) =>
    json.encode(data.toJson());

class GetStatementsResponse {
  final int? status;
  final String? message;
  final List<Datum>? data;

  GetStatementsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetStatementsResponse.fromJson(Map<String, dynamic> json) =>
      GetStatementsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final int? userId;
  final String? name;
  final String? transactionType;
  final String? isDebit;
  final double? beforeBalance;
  final double? netBalance;
  final double? credit;
  final double? debit;
  final double? amount;
  final String? referenceNo;
  final String? remarks;
  final String? tds;
  final String? gst;
  final double? commission;
  final int? createdBy;
  final DateTime? createdOn;
  final int? modifiedBy;
  final DateTime? modifiedOn;
  final String? agentId;
  final double? collectedFare;
  final String? currency;
  final dynamic currencyRatio;

  Datum({
    this.userId,
    this.name,
    this.transactionType,
    this.isDebit,
    this.beforeBalance,
    this.netBalance,
    this.credit,
    this.debit,
    this.amount,
    this.referenceNo,
    this.remarks,
    this.tds,
    this.gst,
    this.commission,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.agentId,
    this.collectedFare,
    this.currency,
    this.currencyRatio,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["UserId"],
        name: json["Name"],
        transactionType: json["TransactionType"],
        isDebit: json["IsDebit"],
        beforeBalance: json["BeforeBalance"]?.toDouble(),
        netBalance: json["NetBalance"]?.toDouble(),
        credit: json["Credit"]?.toDouble(),
        debit: json["Debit"]?.toDouble(),
        amount: json["Amount"]?.toDouble(),
        referenceNo: json["ReferenceNo"],
        remarks: json["Remarks"],
        tds: json["TDS"],
        gst: json["GST"],
        commission: json["Commission"]?.toDouble(),
        createdBy: json["CreatedBy"],
        createdOn: json["CreatedOn"] == null
            ? null
            : DateTime.parse(json["CreatedOn"]),
        modifiedBy: json["ModifiedBy"],
        modifiedOn: json["ModifiedOn"] == null
            ? null
            : DateTime.parse(json["ModifiedOn"]),
        agentId: json["AgentID"],
        collectedFare: json["CollectedFare"]?.toDouble(),
        currency: json["Currency"],
        currencyRatio: json["CurrencyRatio"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "Name": name,
        "TransactionType": transactionType,
        "IsDebit": isDebit,
        "BeforeBalance": beforeBalance,
        "NetBalance": netBalance,
        "Credit": credit,
        "Debit": debit,
        "Amount": amount,
        "ReferenceNo": referenceNo,
        "Remarks": remarks,
        "TDS": tds,
        "GST": gst,
        "Commission": commission,
        "CreatedBy": createdBy,
        "CreatedOn": createdOn?.toIso8601String(),
        "ModifiedBy": modifiedBy,
        "ModifiedOn": modifiedOn?.toIso8601String(),
        "AgentID": agentId,
        "CollectedFare": collectedFare,
        "Currency": currency,
        "CurrencyRatio": currencyRatio,
      };
}
