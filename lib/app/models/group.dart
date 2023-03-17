// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'dart:convert';

GroupModel groupModelFromJson(String str) =>
    GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

class GroupModel {
  GroupModel({
    this.groupId,
    this.groupName,
    this.members,
    this.bills,
  });

  String? groupId;
  String? groupName;
  List<String>? members;
  List<String>? bills;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        groupId: json["group_id"],
        groupName: json["group_name"],
        members: json["members"] == null
            ? []
            : List<String>.from(json["members"]!.map((x) => x)),
        bills: json["bills"] == null
            ? []
            : List<String>.from(json["bills"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "group_name": groupName,
        "members":
            members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
        "bills": bills == null ? [] : List<dynamic>.from(bills!.map((x) => x)),
      };
}
