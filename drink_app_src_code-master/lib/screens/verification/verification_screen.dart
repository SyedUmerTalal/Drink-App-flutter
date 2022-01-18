import 'package:drink/blocs/change_password/change_password_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/blocs/verification/verification_bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/screens/change_password/change_password_screen.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/custom_snacks_bar.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/progress_controller.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/constant_widgets.dart';
import 'package:drink/widgets/pincode_textfield.dart';
import 'package:drink/widgets/raised_gradient_button.dart';
import 'package:drink/widgets/restartable_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({
    Key key,
    this.verificationType,
    this.onResendCodePressed,
  }) : super(key: key);

  final VerificationType verificationType;
  final VoidCallback onResendCodePressed;

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FocusNode _pincodeFocus = FocusNode();
  ProgressController progressController;
  Widget progressWidget;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(_pincodeFocus);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pincodeFocus.unfocus();
    _pincodeFocus.dispose();
    progressController.dispose();
  }

  Widget _circularProgress(ThemeType themeType) {
    return RestartableCircularProgressIndicator(
      themeType: themeType,
      controller: progressController,
      onTimeout: () => setState(
        () {
          progressWidget = _raisedButton(themeType);
        },
      ),
    );
  }

  Widget _raisedButton(ThemeType themeType) {
    return RaisedGradientButton(
        child: Text(
          AppStrings.RESEND_OTP,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          widget.onResendCodePressed();
          setState(() {
            progressWidget = _circularProgress(themeType);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      progressController = ProgressController(
        duration: Duration(seconds: 60),
      );
      progressWidget = _circularProgress(themeState.type);
      progressController.start();
      BoxDecoration getBoxDecoration(Color colorone, Color colortwo,
          {double borderWidth, double radius}) {
        if (themeState.type == ThemeType.light) {
          return BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: AppColors.BORDER_YELLOW,
              width: 1,
            ),
            color: themeState.type == ThemeType.light
                ? Colors.white
                : Colors.transparent,
            boxShadow: themeState.type == ThemeType.light
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
                : [],
          );
        } else {
          return null;
        }
      }

      return Container(
        decoration: themeState.type == ThemeType.light
            ? backGroundImgDecorationLight
            : backGroundImgDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: SizedBox.shrink(),
            centerTitle: true,
            title: Text(
              AppStrings.VERIFICATION,
              style: TextStyle(
                color: themeState.type == ThemeType.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: getHeight(context) - kToolbarHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Spacer(
                          flex: 1,
                        ),
                        themeState.type == ThemeType.light
                            ? logoDarkImage
                            : logoImage,
                        Spacer(
                          flex: 2,
                        ),
                        Text(
                          AppStrings.VERIFICATION_TEXT_ONE,
                          style: TextStyle(
                            fontSize: 12,
                            color: themeState.type == ThemeType.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          AppStrings.VERIFICATION_TEXT_TWO,
                          style: TextStyle(
                            fontSize: 12,
                            color: themeState.type == ThemeType.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        BlocListener<VerificationBloc, VerificationState>(
                          listener: (context, state) {
                            if (state is VerificationSuccessful) {
                              LoadingDialog.hide(context);
                              AppNavigation.navigatorPop(context);
                              AppNavigation.navigatorPop(context);

                              // AppNavigation.navigateReplacement(
                              //     context,
                              //     ProfileScreen(
                              //       title: AppStrings.COMPLETE_PROFILE,
                              //       buttonText: AppStrings.DONE,
                              //       onPressed: (context) {
                              //         AppNavigation.navigateToRemoveingAll(
                              //           context,
                              //           HomeScreen(),
                              //         );
                              //       },
                              //     ));
                            } else if (state is VerificationFailure) {
                              LoadingDialog.hide(context);
                              CustomSnacksBar.showSnackBar(
                                  context, state.message);
                            } else if (state is VerificationSubmitting) {
                              LoadingDialog.show(context);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 52,
                            child: PinCodeTextField(
                              isLightMode: themeState.type == ThemeType.light,
                              focusNode: _pincodeFocus,
                              maxLength: 6,
                              pinBoxHeight: 36,
                              pinBoxWidth: 36,
                              pinBoxBorderWidth: 2,
                              pinBoxRadius: 10,
                              highlightColor: Colors.white,
                              defaultBorderColor: AppColors.GOLDEN,
                              pinBoxOuterPadding:
                                  EdgeInsets.symmetric(horizontal: 6),
                              hasTextBorderColor: AppColors.BORDER_YELLOW,
                              pinTextStyle: TextStyle(
                                color: themeState.type == ThemeType.light
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              onDone: (value) {
                                setState(() {
                                  progressWidget =
                                      _circularProgress(themeState.type);
                                });

                                widget.verificationType ==
                                            VerificationType.phone ||
                                        widget.verificationType ==
                                            VerificationType.email
                                    ? context
                                        .read<VerificationBloc>()
                                        .add(SubmitVerification(
                                          code: value,
                                          type: widget.verificationType,
                                        ))
                                    : AppNavigation.navigateReplacement(
                                        context,
                                        BlocProvider<ChangePasswordBloc>(
                                          create: (_) => ChangePasswordBloc(
                                            authenticationRepository:
                                                context.read<
                                                    AuthenticationRepository>(),
                                            otp: value,
                                          ),
                                          child: ChangePasswordScreen(
                                            isResetForgotPassword: true,
                                            email: context
                                                .read<VerificationBloc>()
                                                .email,
                                          ),
                                        ));
                              },
                              wrapAlignment: WrapAlignment.center,
                              pinBoxDecoration:
                                  themeState.type == ThemeType.light
                                      ? getBoxDecoration
                                      : null,
                            ),
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 100),
                          child: progressWidget,
                        ),
                        Spacer(
                          flex: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
