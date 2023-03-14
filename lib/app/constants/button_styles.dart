import 'package:flutter/material.dart';

class CustomButtonStyles {
  static ButtonStyle elevButtonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all<double>(5),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.fromLTRB(50, 15, 50, 15)),
    // backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
