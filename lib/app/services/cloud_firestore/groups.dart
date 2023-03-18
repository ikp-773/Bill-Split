import 'package:bill_split/app/models/bills_model.dart';
import 'package:bill_split/app/models/group_model.dart';
import 'package:bill_split/app/models/user.dart';
import 'package:bill_split/app/services/cloud_firestore/get_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../constants/commom.dart';
import 'bills.dart';

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

  removeGroupBill(billId, String groupId) async {
    try {
      BillModel bill = await FirebaseBills().getBill(billId);
      for (var u in bill.usersSplit!) {
        if (u.id == bill.paidBy) {
          await userCollection.doc(u.id).update({
            "take": FieldValue.increment(-u.amt!),
            "bills": FieldValue.arrayRemove([bill.billId])
          });
        } else {
          await userCollection.doc(u.id).update({
            "give": FieldValue.increment(-u.amt!),
            "bills": FieldValue.arrayRemove([bill.billId])
          });
        }
      }
      groupsCollection.doc(groupId).update({
        "bills": FieldValue.arrayRemove([bill.billId])
      });
      billsCollection.doc(billId).delete();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }

  settleGroupBill(billId, String groupId) async {
    try {
      var billData = await billsCollection.doc(billId).get();

      var data = billData.data() as Map<String, dynamic>;
      BillModel billModel =
          BillModel.fromJson(billData.data() as Map<String, dynamic>);
      await billsCollection.doc(billId).update({
        'users_split': [],
      });
      for (var u in billModel.usersSplit!) {
        await billsCollection.doc(billId).update({
          'users_split': FieldValue.arrayUnion([
            {
              'id': u.id,
              'amt': u.amt,
              'settled': u.id == uid || u.settled!,
            }
          ]),
        });
      }

      for (var u in billModel.usersSplit!) {
        if (u.id == billModel.paidBy) {
          await userCollection.doc(u.id).update({
            "take": FieldValue.increment(-u.amt!),
          });
        } else {
          await userCollection.doc(u.id).update({
            "give": FieldValue.increment(-u.amt!),
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
