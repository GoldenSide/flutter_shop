import 'package:flutter/material.dart';

class ToastUtils {
  static void showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      width: 120,
    ));
  }
}
