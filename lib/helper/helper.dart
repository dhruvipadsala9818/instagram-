import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

class Helper {
  static final Helper dialogCall = Helper._();

  Helper._();
  showToast(context, String messages, Color color, Color textColor) {
    Fluttertoast.showToast(
        msg: messages,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: textColor,
        fontSize: 16.0);
  }
}
