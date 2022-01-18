import 'dart:io' show Platform;
import 'package:drink/blocs/forgot_password/forgot_password_bloc.dart' as fpb;
import 'package:drink/blocs/signIn/signin_bloc.dart';
import 'package:drink/blocs/signUp/signup_bloc.dart' as signup;
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/blocs/verification/verification_bloc.dart';
import 'package:drink/models/user.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/screens/forget_password/forget_password_screen.dart'
    as fp;
import 'package:drink/screens/sign_up/sign_up_screen.dart';
import 'package:drink/screens/verification/verification_screen.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/custom_snacks_bar.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/utility/validators.dart';
import 'package:drink/widgets/constant_widgets.dart';
import 'package:drink/widgets/raised_gradient_button.dart';
import 'package:drink/widgets/text_field_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailSigninScreen extends StatefulWidget {
  const EmailSigninScreen({Key key}) : super(key: key);

  @override
  _EmailSigninScreenState createState() => _EmailSigninScreenState();
}

class _EmailSigninScreenState extends State<EmailSigninScreen>
    with EmailAndPasswordValidators {
  bool visible = false;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  String _email;
  String _password;

  SigninBloc _signinBloc;

  bool get isPopulated =>
      (_email?.isNotEmpty ?? false) && (_password?.isNotEmpty ?? false);

  bool isSigninButtonEnabled(SigninState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  TapGestureRecognizer _tapGestureRecognizer;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () => AppNavigation.navigateTo(
            context,
            BlocProvider<signup.SignupBloc>(
              create: (_) => signup.SignupBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>()),
              child: SignUpScreen(),
            ),
          );

    // if (_emailController.text?.isEmpty ?? true) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     FocusScope.of(context).requestFocus(_emailFocus);
    //   });
    // }
  }

  Widget _emailInput(
    SigninState state,
    ThemeType themeType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.EMAIL_ADDRESS,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeType == ThemeType.light ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 8),
        TextFieldInput(
            themeType: themeType,
            validator: (value) {
              if (value.isEmpty) {
                return AppStrings.EMAIL_EMPTY_ERROR;
              } else if (!state.isEmailValid) {
                return AppStrings.EMAIL_ERROR;
              }
            },
            onChanged: (value) {
              _email = value;
              _signinBloc.add(
                EmailChanged(email: value),
              );
            },
            hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: themeType == ThemeType.light
                  ? AppColors.TEXT_GREY
                  : Colors.white,
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: themeType == ThemeType.light ? Colors.black : Colors.white,
            ),
            hintText: AppStrings.EMAIL_HINT,
            inputType: TextInputType.emailAddress,
            inputAction: TextInputAction.next,
            focusNode: _emailFocus,
            formFieldSubmitted: (value) {
              // _email = value;
              _emailFocus.unfocus();
              FocusScope.of(context).requestFocus(_passwordFocus);
            }),
      ],
    );
  }

  Widget _passwordField(
    SigninState state,
    ThemeType themeType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.PASSWORD,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeType == ThemeType.light ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 8),
        TextFieldInput(
          validator: (value) {
            if (value.isEmpty) {
              return AppStrings.PASSWORD_EMPTY_ERROR;
            } else if (!state.isPasswordValid) {
              return AppStrings.PASSWORD_INVALID_ERROR;
            }
          },
          hintText: AppStrings.PASSWORD_HINT,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: themeType == ThemeType.light
                ? AppColors.TEXT_GREY
                : Colors.white,
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: themeType == ThemeType.light ? Colors.black : Colors.white,
          ),
          onChanged: (value) {
            _password = value;
            _signinBloc.add(
              PasswordChanged(password: value),
            );
          },
          inputType: TextInputType.visiblePassword,
          inputAction: TextInputAction.done,
          focusNode: _passwordFocus,
          isPassword: true,
          formFieldSubmitted: (value) {
            _passwordFocus.unfocus();
            FocusScope.of(context).unfocus();
          },
          themeType: themeType,
        ),
      ],
    );
  }

  Widget _signInButton(SigninState state) {
    return RaisedGradientButton(
      child: Text(
        AppStrings.SIGN_IN,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: isSigninButtonEnabled(state) ? _onFormSubmitted : null,
    );
  }

  Widget _forgotPasswordText(ThemeType themeType) {
    return GestureDetector(
      onTap: () => AppNavigation.navigateTo(
        context,
        BlocProvider<fpb.ForgotPasswordBloc>(
            create: (_) => fpb.ForgotPasswordBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>(),
                ),
            child: fp.ForgetPasswordScreen()),
      ),
      child: Text(
        AppStrings.FORGET_PASSWORD,
        style: TextStyle(
          shadows: [
            Shadow(
                color:
                    themeType == ThemeType.light ? Colors.black : Colors.white,
                offset: Offset(0, -5))
          ],
          color: Colors.transparent,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.GOLDEN,
          decorationThickness: 4,
        ),
      ),
    );
  }

  Widget _signUpText(ThemeType themeType) {
    return RichText(
      text: TextSpan(
        text: AppStrings.DONT_HAVE_ACCOUNT,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: themeType == ThemeType.light ? Colors.black : Colors.white,
        ),
        children: [
          TextSpan(
            recognizer: _tapGestureRecognizer,
            text: AppStrings.SPACE + AppStrings.SIGNUP,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.DARK_AMBER,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _signinBloc = context.watch<SigninBloc>();
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          decoration: themeState.type == ThemeType.light
              ? backGroundImgDecorationLight
              : backGroundImgDecoration,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Platform.isAndroid
                    ? Icon(
                        Icons.arrow_back,
                        color: themeState.type == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                      )
                    : Icon(
                        Icons.arrow_back_ios,
                        color: themeState.type == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                      ),
                onPressed: () {
                  AppNavigation.navigatorPop(context);
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(AppStrings.SIGNIN,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: themeState.type == ThemeType.light
                        ? Colors.black
                        : Colors.white,
                  )),
            ),
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: getHeight(context) - kToolbarHeight,
                child: BlocConsumer<SigninBloc, SigninState>(
                  listener: (context, state) {
                    if (state.isSuccess) {
                      LoadingDialog.hide(context);
                      AppNavigation.navigatorPop(context);
                      //}
                    } else if (state.isSubmitting) {
                      LoadingDialog.show(context);
                    } else if (state.isFailure) {
                      LoadingDialog.hide(context);
                      FocusManager.instance.primaryFocus.unfocus();

                      if (state.message == 'We have sent OTP verification code at your email address') {
                        AppNavigation.navigateReplacement(
                          context,
                          BlocProvider<VerificationBloc>(
                            create: (_) => VerificationBloc(
                                email: _email,
                                authenticationRepository:
                                    context.read<AuthenticationRepository>()),
                            child: VerificationScreen(
                              verificationType: VerificationType.email,
                              onResendCodePressed: onVerificationSubmit,
                            ),
                          ),
                        );
                      } else {
                        CustomSnacksBar.showSnackBar(
                          context,
                          state.message,
                          duration: 2,
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                            _emailInput(state, themeState.type),
                            SizedBox(
                              height: 24,
                            ),
                            _passwordField(
                              state,
                              themeState.type,
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            _signInButton(state),
                            Spacer(
                              flex: 2,
                            ),
                            _forgotPasswordText(themeState.type),
                            Spacer(
                              flex: 4,
                            ),
                            _signUpText(themeState.type),
                            Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onVerificationSubmit() {
    _signinBloc.add(
      VerificationSubmit(
        email: _email,
        password: _password,
      ),
    );
  }

  void _onFormSubmitted() {
    if (_signinBloc != null) {
      _signinBloc.add(
        SigninWithCredentialsPressed(
          email: _email,
          password: _password,
        ),
      );
    }
  }
}
