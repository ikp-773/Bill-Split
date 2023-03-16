import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/models/bills.dart';
import 'package:bill_split/app/models/user.dart';
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
        Get.snackbar("Error Adding Split", "");
      });
      for (var user in bill.usersSplit!) {
        if (user.id == bill.paidBy) {
          List frds = [];
          for (var u in bill.usersSplit!) {
            if (u.id != uid) {
              frds.add(u.id);
            }
          }
          await userCollection.doc(user.id).update({
            "lent": FieldValue.increment(bill.amount! - user.amt!),
            "friends": FieldValue.arrayUnion(frds),
            "bills": FieldValue.arrayUnion([bill.billId])
          });
        } else {
          await userCollection.doc(user.id).update({
            "owed": FieldValue.increment(user.amt!),
            "friends": FieldValue.arrayUnion([uid]),
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
