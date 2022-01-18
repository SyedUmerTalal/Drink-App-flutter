import 'dart:developer';
import 'dart:io' show Platform;
import 'package:drink/blocs/signIn/signin_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/screens/email_signin/email_signin_screen.dart';
import 'package:drink/screens/phone_signin/phone_signin_screen.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/auth_button.dart';
import 'package:drink/widgets/confirmation_dialog.dart';
import 'package:drink/widgets/constant_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({Key key}) : super(key: key);

  Future<void> _signInWithEmail(BuildContext context) async {
    try {
      final bool result = await AppNavigation.showDialogGeneral(
        context,
        ConfirmationDialog(),
      );
      if (result ?? false) {
        AppNavigation.navigateTo(
            context,
            BlocProvider<SigninBloc>.value(
                value: context.read<SigninBloc>(), child: EmailSigninScreen()));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<void> _goToCompleteProfile(BuildContext context) async {
  //   try {
  //     final bool result = await AppNavigation.showDialogGeneral(
  //       context,
  //       ConfirmationDialog(),
  //     );
  //     if (result ?? false) {
  //       AppNavigation.navigateTo(
  //           context,
  //           ProfileScreen(
  //             title: AppStrings.COMPLETE_PROFILE,
  //             buttonText: AppStrings.DONE,
  //             onPressed: (cntx) {
  //               AppNavigation.navigateTo(cntx, HomeScreen());
  //             },
  //           ));
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // Future<void> _goToHomeScreen(BuildContext context, SigninEvent event) async {
  //   try {
  //     final bool result = await AppNavigation.showDialogGeneral(
  //       context,
  //       ConfirmationDialog(),
  //     );
  //     if (result ?? false) {
  //       context.watch<SigninBloc>().add(event);
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<void> _signInWithPhoneNumber(BuildContext context) async {
    try {
      final bool result = await AppNavigation.showDialogGeneral(
        context,
        ConfirmationDialog(),
      );
      if (result ?? false) {
        AppNavigation.navigateTo(
          context,
          BlocProvider<SigninBloc>.value(
            value: context.read<SigninBloc>(),
            child: PhoneSigninScreen(),
          ),
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          decoration: themeState.type == ThemeType.light
              ? backGroundImgDecorationLight
              : backGroundImgDecoration,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: getHeight(context) * 0.14,
                    ),
                    themeState.type == ThemeType.light
                        ? logoDarkImage
                        : logoImage,
                    SizedBox(
                      height: getHeight(context) * 0.22,
                    ),
                    AuthButton(
                      onPressed: _signInWithEmail,
                      signInWith: AppStrings.EMAIL_LOGIN,
                      iconPath: AssetPaths.AT_ICON,
                      themeType: themeState.type,
                    ),
                    SizedBox(
                      height: getHeight(context) * 0.024,
                    ),
                    AuthButton(
                      onPressed: _signInWithPhoneNumber,
                      signInWith: AppStrings.PHONE_LOGIN,
                      iconPath: AssetPaths.PHONE_ICON,
                      themeType: themeState.type,
                    ),
                    SizedBox(
                      height: getHeight(context) * 0.024,
                    ),
                    Platform.isIOS
                        ? AuthButton(
                            themeType: themeState.type,
                            eventName: SigninWithApplePressed(),
                            signInWith: AppStrings.APPLE_LOGIN,
                            iconPath: AssetPaths.APPLE_ICON,
                          )
                        : SizedBox.shrink(),
                    Platform.isIOS
                        ? SizedBox(
                            height: getHeight(context) * 0.024,
                          )
                        : SizedBox.shrink(),
                    /*AuthButton(
                      eventName: SigninWithFacebookPressed(),
                      signInWith: AppStrings.FACEBOOK_LOGIN,
                      iconPath: AssetPaths.FACEBOOK_ICON,
                      themeType: themeState.type,
                    ),
                    SizedBox(
                      height: getHeight(context) * 0.024,
                    ),*/
                    AuthButton(
                      eventName: SigninWithGooglePressed(),
                      signInWith: AppStrings.GOOGLE_LOGIN,
                      iconPath: AssetPaths.GOOGLE_ICON,
                      themeType: themeState.type,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
