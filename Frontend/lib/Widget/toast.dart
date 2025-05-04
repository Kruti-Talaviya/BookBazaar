import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  // Reusable method to show a toast message
  static void showToast(String message, Color bgColor, Color textColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}
