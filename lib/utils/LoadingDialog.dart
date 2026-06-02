// 加载弹窗
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoadingDialog {
  static void show(BuildContext context, {String message = '加载中...'}) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(message),
                    ],
                  ),
                ),
              ));
        });
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
