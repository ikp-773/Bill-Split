import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/models/bills.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GetBillsFirebase {
  final CollectionReference billsCollection =
      FirebaseFirestore.instance.collection("bills");
  final String uid = CommonInstances.storage.read(CommonInstances.uid);

  getBill(billId) async {
    try {
      var billData = await billsCollection.doc(billId).get();
      BillModel billModel =
          BillModel.fromJson(billData.data() as Map<String, dynamic>);
      if (kDebugMode) {
        print(billModel);
      }
      return billModel;
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }
}
