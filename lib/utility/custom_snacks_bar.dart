import 'package:another_flushbar/flushbar.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef StatusCallback = void Function(FlushbarStatus);

class CustomSnacksBar {
  CustomSnacksBar._();

  static void showSnackBar(BuildContext context, String message,
      {Widget icon,
      int duration,
      Key key,
      Widget mainButton,
      StatusCallback onStatusChange}) {
    // Fluttertoast.showToast(
    //   msg: message,
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    // );
    Flushbar(
      icon: icon ??
          Icon(
            FontAwesomeIcons.exclamationCircle,
            color: Colors.white,
          ),
      onStatusChanged: onStatusChange,
      mainButton: mainButton,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      messageText: Text(
        message ?? AppStrings.ERROR_TEXT,
        style: TextStyle(color: Colors.white),
      ),
      backgroundGradient: LinearGradient(
        colors: <Color>[AppColors.DARK_BROWN, AppColors.BORDER_YELLOW],
      ),
      duration: Duration(seconds: duration ?? 2),
    ).show(context);
  }
}
