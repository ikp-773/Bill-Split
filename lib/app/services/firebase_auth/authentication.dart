import 'package:bill_split/app/constants/commom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../models/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    String result = 'Some error occurred';
    try {
      if (email.isNotEmpty || name.isNotEmpty || password.isNotEmpty) {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (kDebugMode) {
          print(user.user!.uid);
        }
        CommonInstances.storage.write(CommonInstances.uid, user.user!.uid);

        UserModel userModel = UserModel(
          uid: user.user!.uid,
          email: email,
          name: name,
          lent: 0.0,
          owed: 0.0,
          groups: [],
          bills: [],
          friends: [],
        );

        await _firestore.collection('users').doc(user.user!.uid).set(
              userModel.toJson(),
            );
        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    print(result);

    return result;
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String result = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (kDebugMode) {
          print(user.user!.uid);
        }
        CommonInstances.storage.write(CommonInstances.uid, user.user!.uid);

        result = 'success';
      }
    } catch (err) {
      result = err.toString();
    }
    print(result);
    return result;
  }
}
