import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:drink/utility/strings.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppNavigation {
  static Future<dynamic> showDialogGeneral(
      BuildContext context, Widget dialogWidget) async {
    try {
      return await showGeneralDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black38.withOpacity(0.90),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildcontext, Animation animamtion,
            Animation secondaryAnimation) {
          return Center(
            child: dialogWidget,
          );
        },
      );
    } catch (e) {
      log(e.toString());
      throw Exception(AppStrings.EXCEPTION_MAPS);
    }
  }

  static Future<void> navigateToRemoveingAll(context, Widget widget) async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => widget),
        (Route<dynamic> route) => false);
  }

  static Future navigateTo(BuildContext context, Widget widget) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  static Future<void> navigateReplacement(
      BuildContext context, Widget widget) async {
    return await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  static void navigatorPop(BuildContext context) {
    return Navigator.of(context).pop();
  }

  static void navigatorPopTrue(BuildContext context) {
    return Navigator.of(context).pop(true);
  }

  static void navigatorPopData(BuildContext context, List data) {
    return Navigator.of(context).pop(data);
  }

  static void navigatorPopFalse(BuildContext context) {
    return Navigator.of(context).pop(false);
  }

  static void animatedNavigation(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionDuration: Duration(seconds: 2),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.linearToEaseOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static void showToast({String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }
  static Future<void> showAsyncToast({String message}) async{
   await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }
}
