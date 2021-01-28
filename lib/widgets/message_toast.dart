import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageToast {
  static void showToast(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Theme.of(context).accentColor,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.black);
  }
}
