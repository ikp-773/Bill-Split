import 'package:bill_split/app/modules/auth/bindings/auth_binding.dart';
import 'package:bill_split/app/modules/auth/views/sign_up_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constants/button_styles.dart';
import '../controllers/auth_controller.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({Key? key}) : super(key: key);
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
                    textcontroller: controller.emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  CTField(
                    textcontroller: controller.passController,
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 25, 40, 30),
                    child: ElevatedButton(
                      onPressed: controller.signIn,
                      style: CustomButtonStyles.elevButtonStyle,
                      child: const Text(
                        'Sign In',
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
              Get.offAll(() => const SignUpView(), binding: AuthBinding());
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }
}

class CTField extends StatefulWidget {
  const CTField({
    Key? key,
    required this.textcontroller,
    required this.hintText,
    required this.keyboardType,
    this.isPassword = false,
    this.isMoney = false,
    this.validator,
    this.readOnly = false,
    this.onChanged,
    this.isPercent = false,
  }) : super(key: key);

  final TextEditingController textcontroller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isMoney;
  final validator;
  final bool readOnly;
  final bool isPercent;
  final void Function(String)? onChanged;

  @override
  State<CTField> createState() => _CTFieldState();
}

class _CTFieldState extends State<CTField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        onChanged: widget.onChanged,
        readOnly: widget.readOnly,
        obscureText: widget.isPassword ? obscureText : false,
        controller: widget.textcontroller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon:
              widget.isMoney ? const Icon(Icons.currency_rupee_rounded) : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : widget.isPercent
                  ? Icon(Icons.percent_rounded)
                  : null,
        ),
        validator: widget.validator ??
            (String? value) {
              if (value!.isEmpty) {
                return 'Please enter your ${widget.hintText}';
              }
              return null;
            },
      ),
    );
  }
}
