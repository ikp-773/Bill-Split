import 'package:bill_split/app/constants/commom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDetFirebase {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future getData() async {
    try {
      //to get data from a single/particular document alone.
      var userData = await userCollection
          .doc(CommonInstances.storage.read(CommonInstances.uid))
          .get();

      print(userData);
      // return userData;
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }
}
