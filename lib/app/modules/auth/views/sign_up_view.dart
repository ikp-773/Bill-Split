import 'package:bill_split/app/modules/auth/controllers/auth_controller.dart';
import 'package:bill_split/app/modules/auth/views/sign_in_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/button_styles.dart';
import '../bindings/auth_binding.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Bill Split',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CTField(
                    textcontroller: controller.nameController,
                    hintText: 'Name',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16.0),
                  CTField(
                    textcontroller: controller.emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  CTField(
                    textcontroller: controller.passController,
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    password: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 25, 40, 30),
                    child: ElevatedButton(
                      onPressed: controller.signUp,
                      style: CustomButtonStyles.elevButtonStyle,
                      child: const Text(
                        'Sign Up',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Center(
          child: InkWell(
            onTap: () {
              Get.off(() => const SignInView(), binding: AuthBinding());
            },
            child: const Text(
              'Sign In',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }
}
