import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/modules/auth/models/user.dart';
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
      UserModel userModel =
          UserModel.fromJson(userData.data() as Map<String, dynamic>);
      if (kDebugMode) {
        print(userModel);
      }
      return userModel;
    } catch (e) {
      if (kDebugMode) {
        print("Error - $e");
      }
      return e;
    }
  }
}
