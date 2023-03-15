import 'package:bill_split/app/constants/commom.dart';
import 'package:bill_split/app/modules/auth/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDetFirebase {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final String uid = CommonInstances.storage.read(CommonInstances.uid);

  Future getUserModel() async {
    try {
      var userData = await userCollection.doc(uid).get();
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

  Future getUser(userId) async {
    try {
      var userData = await userCollection.doc(userId).get();
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

  List<UserModel> userModelList = [];

  Future getAllUsers() async {
    try {
      await userCollection.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          if (result.id != uid) {
            userModelList
                .add(UserModel.fromJson(result.data() as Map<String, dynamic>));
          }
        }
      });

      return userModelList;
    } catch (e) {
      debugPrint("Error - $e");
      return e;
    }
  }
}
