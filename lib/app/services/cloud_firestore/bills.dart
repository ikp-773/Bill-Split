import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/models/bill_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FirebaseBills {
  final CollectionReference billsCollection =
      FirebaseFirestore.instance.collection("bills");

  final String uid = CommonInstances.storage.read(CommonInstances.uid);

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  addBill(BillModel bill) async {
    try {
      var billRef = billsCollection.doc();
      bill.billId = billRef.id;
      billRef.set(bill.toJson()).onError((e, _) {
        Get.snackbar("Error Adding Split", "$e");
      });
      for (var user in bill.usersSplit!) {
        if (user.id == bill.paidBy) {
          List frds = [];
          for (var u in bill.usersSplit!) {
            if (u.id != user.id) {
              frds.add(u.id);
            }
          }
          await userCollection.doc(user.id).update({
            "take": FieldValue.increment(bill.amount! - user.amt!),
            "friends": FieldValue.arrayUnion(frds),
            "bills": FieldValue.arrayUnion([bill.billId])
          });
        } else {
          List frds = [];
          for (var u in bill.usersSplit!) {
            if (u.id != user.id) {
              frds.add(u.id);
            }
          }
          await userCollection.doc(user.id).update({
            "give": FieldValue.increment(user.amt!),
            "friends": FieldValue.arrayUnion(frds),
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

  getBill(billId) async {
    try {
      var billData = await billsCollection.doc(billId).get();
      BillModel billModel =
          BillModel.fromJson(billData.data() as Map<String, dynamic>);
      return billModel;
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }

  removeBill(billId) async {
    try {
      BillModel bill = await getBill(billId);
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
      billsCollection.doc(billId).delete();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }

  settleBill(billId) async {
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
              'settled': true,
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
