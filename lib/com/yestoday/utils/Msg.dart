import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Msg {
  static void tip(String msg, BuildContext context) {
    Toast.show(msg, context,
        gravity: Toast.TOP, duration: Toast.LENGTH_LONG, backgroundRadius: 3);
  }

  static void alert(String msg, BuildContext context) {
    Toast.show(msg, context,
        gravity: Toast.TOP,
        duration: Toast.LENGTH_LONG,
        backgroundColor: Colors.red.withOpacity(0.8),
        backgroundRadius: 3);
  }
}
