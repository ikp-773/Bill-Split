import 'package:bill_split/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/cloud_firestore/read_user.dart';
import '../../../services/firebase_auth/authentication.dart';

class AuthController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      String result = await AuthMethods().signUpUser(
          name: nameController.text,
          email: emailController.text,
          password: passController.text);
      if (result == 'success') {
        await UserDetFirebase().getUserModel().then(
              (value) => Get.toNamed(Routes.HOME, arguments: value),
            );
      } else {
        GetSnackBar(title: result);
      }
    }
  }

  void signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String result = await AuthMethods().signInUser(
        email: emailController.text,
        password: passController.text,
      );
      if (result == 'success') {
        await UserDetFirebase().getUserModel().then(
              (value) => Get.toNamed(Routes.HOME, arguments: value),
            );
      } else {
        GetSnackBar(title: result);
      }
    }

    @override
    void onInit() {
      super.onInit();
    }

    @override
    void onReady() {
      super.onReady();
    }

    @override
    void onClose() {
      super.onClose();
    }
  }
}
