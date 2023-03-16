// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.uid,
    this.email,
    this.name,
    this.owed,
    this.lent,
    this.groups,
    this.bills,
    this.friends,
  });

  String? email;
  String? name;
  num? owed;
  num? lent;
  String? uid;
  List<String>? groups;
  List<String>? bills;
  List<String>? friends;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        email: json["email"],
        name: json["name"],
        lent: json["lent"],
        owed: json["owed"],
        groups: List<String>.from(json["groups"].map((x) => x)),
        bills: List<String>.from(json["bills"].map((x) => x)),
        friends: List<String>.from(json["friends"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "lent": lent,
        "owed": owed,
        "groups": List<dynamic>.from(groups!.map((x) => x)),
        "bills": List<dynamic>.from(bills!.map((x) => x)),
        "friends": List<dynamic>.from(friends!.map((x) => x)),
      };
}
