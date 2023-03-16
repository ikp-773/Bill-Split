// To parse this JSON data, do
//
//     final billModel = billModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

BillModel billModelFromJson(String str) => BillModel.fromJson(json.decode(str));

String billModelToJson(BillModel data) => json.encode(data.toJson());

class BillModel {
  BillModel({
    required this.billId,
    required this.desc,
    required this.amount,
    required this.createdBy,
    required this.paidBy,
    required this.createdAt,
    required this.users,
  });

  final String billId;
  final String desc;
  final int amount;
  final String createdBy;
  final String paidBy;
  final DateTime createdAt;
  final List<List<String>> users;

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
        billId: json["billId"],
        desc: json["desc"],
        amount: json["amount"],
        createdBy: json["created_by"],
        paidBy: json["paid_by"],
        createdAt: DateTime.parse(json["created_at"]),
        users: List<List<String>>.from(
            json["users"].map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "billId": billId,
        "desc": desc,
        "amount": amount,
        "created_by": createdBy,
        "paid_by": paidBy,
        "created_at":
            "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
        "users": List<dynamic>.from(
            users.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
