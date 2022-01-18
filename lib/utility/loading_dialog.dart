import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'colors.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key key}) : super(key: key);

  static void show(BuildContext context, {Key key}) {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(key: key),
      barrierDismissible: false,
      useRootNavigator: true,
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (
        context,
        themeState,
      ) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              color: themeState.type == ThemeType.light
                  ? Colors.white54
                  : AppColors.DARK_GREY,
              child: Container(
                width: 80,
                height: 80,
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
