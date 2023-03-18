// To parse this JSON data, do
//
//     final billModel = billModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

BillModel billModelFromJson(String str) => BillModel.fromJson(json.decode(str));

String billModelToJson(BillModel data) => json.encode(data.toJson());

class BillModel {
  BillModel({
    this.billId,
    this.desc,
    this.amount,
    this.createdBy,
    this.paidBy,
    this.createdAt,
    this.usersSplit,
  });

  String? billId;
  String? desc;
  num? amount;
  String? createdBy;
  String? paidBy;
  DateTime? createdAt;
  List<UsersSplit>? usersSplit;

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
        billId: json["billId"],
        desc: json["desc"],
        amount: json["amount"],
        createdBy: json["created_by"],
        paidBy: json["paid_by"],
        createdAt: DateTime.parse(json["created_at"]),
        usersSplit: List<UsersSplit>.from(
            json["users_split"].map((x) => UsersSplit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "billId": billId,
        "desc": desc,
        "amount": amount,
        "created_by": createdBy,
        "paid_by": paidBy,
        "created_at": createdAt!.toIso8601String(),
        "users_split": List<dynamic>.from(usersSplit!.map((x) => x.toJson())),
      };
}

class UsersSplit {
  UsersSplit({
    this.id,
    this.amt,
    this.settled,
  });

  String? id;
  num? amt;
  bool? settled;

  factory UsersSplit.fromJson(Map<String, dynamic> json) => UsersSplit(
        id: json["id"],
        amt: json["amt"],
        settled: json["settled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amt": amt,
        "settled": settled,
      };
}
