import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:drink/blocs/signIn/signin_bloc.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/widgets/confirmation_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ContextCall = Future<void> Function(BuildContext context);

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key key,
    this.eventName,
    this.signInWith,
    this.iconPath,
    this.onPressed,
    @required this.themeType,
  }) : super(key: key);
  final SigninEvent eventName;
  final String signInWith;
  final String iconPath;
  final ContextCall onPressed;
  final ThemeType themeType;

  Future<void> signIn(BuildContext context, SigninEvent event) async {
    try {
      final bool result = await AppNavigation.showDialogGeneral(
        context,
        ConfirmationDialog(),
      );
      if (result ?? false) {
        context.read<SigninBloc>().add(event);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget authButton(
    BuildContext context,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () =>
          eventName == null ? onPressed(context) : signIn(context, eventName),
      child: Container(
        decoration: BoxDecoration(
          color:
              themeType == ThemeType.light ? Colors.white : Colors.transparent,
          boxShadow: themeType == ThemeType.light
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]
              : [],
          border: Border.all(color: AppColors.BORDER_YELLOW, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              color: themeType == ThemeType.light ? Colors.black : Colors.white,
              height: 16,
              width: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                signInWith,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: themeType == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return authButton(
      context,
    );
  }
}
