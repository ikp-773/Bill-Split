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

  addBill(BillModel bill) async {
    try {
      var userData = billsCollection.doc("LA").set(bill).onError((e, _) {
        Get.snackbar("Error Adding Split", "");
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }
}
