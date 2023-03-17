import 'package:bill_split/app/models/bills.dart';
import 'package:bill_split/app/models/group.dart';
import 'package:bill_split/app/models/user.dart';
import 'package:bill_split/app/services/cloud_firestore/get_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../constants/commom.dart';

class FirebaseGroups {
  final CollectionReference billsCollection =
      FirebaseFirestore.instance.collection("bills");

  final CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection("groups");

  final String uid = CommonInstances.storage.read(CommonInstances.uid);

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  addGroup(GroupModel group) async {
    try {
      var groupRef = groupsCollection.doc();
      group.groupId = groupRef.id;
      groupRef.set(group.toJson()).onError((e, _) {
        Get.snackbar("Error Adding Split", "$e");
      });
      for (var user in group.members!) {
        List frds = [];
        // UserModel u = await UserDetFirebase().getUser(user);
        for (var us in group.members!) {
          if (us != user) {
            frds.add(us);
          }
        }
        await userCollection.doc(user).update({
          "friends": FieldValue.arrayUnion(frds),
          "groups": FieldValue.arrayUnion([group.groupId]),
        });
      }
      return group.groupId;
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }

  getGroup(groupId) async {
    try {
      var groupData = await groupsCollection.doc(groupId).get();
      GroupModel groupModel =
          GroupModel.fromJson(groupData.data() as Map<String, dynamic>);
      if (kDebugMode) {
        print(groupModel);
      }
      return groupModel;
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }

  addGroupBill(BillModel bill, String groupId) async {
    try {
      //Add new bill
      var billRef = billsCollection.doc();
      bill.billId = billRef.id;
      billRef.set(bill.toJson()).onError((e, _) {
        Get.snackbar("Error Adding Split", "$e");
      });
      // GroupModel groupModel = getGroup(groupId);

      //Add bill in group
      groupsCollection.doc(groupId).update({
        "bills": FieldValue.arrayUnion([bill.billId])
      });

      for (var user in bill.usersSplit!) {
        if (user.id == bill.paidBy) {
          await userCollection.doc(user.id).update({
            "take": FieldValue.increment(bill.amount! - user.amt!),
            "bills": FieldValue.arrayUnion([bill.billId])
          });
        } else {
          await userCollection.doc(user.id).update({
            "give": FieldValue.increment(user.amt!),
            "bills": FieldValue.arrayUnion([bill.billId])
          });
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }
}
