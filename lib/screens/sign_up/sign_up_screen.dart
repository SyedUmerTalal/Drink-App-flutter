import 'dart:io' show Platform;
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/blocs/verification/verification_bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/screens/verification/verification_screen.dart';
import 'package:drink/utility/custom_snacks_bar.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/utility/validators.dart';
import 'package:drink/widgets/constant_widgets.dart';
import 'package:drink/widgets/raised_gradient_button.dart';
import 'package:drink/widgets/text_field_input.dart';
import 'package:drink/blocs/signUp/signup_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with EmailAndPasswordValidators {
  bool passwordVisible = false;

  bool confirmPasswordVisible = false;

  final FocusNode _emailFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  SignupBloc _signupBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  bool isSignupButtonEnabled(SignupState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  TapGestureRecognizer _tapGestureRecognizer;
  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () => AppNavigation.navigatorPop(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  final _formKey = GlobalKey<FormState>();

  Widget _showEmailInput(
      {BuildContext context, SignupState state, ThemeType themeType}) {
    return TextFieldInput(
      textEditingController: _emailController,
      hintText: AppStrings.EMAIL_ADDRESS_GET,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value.isEmpty) {
          return AppStrings.EMAIL_EMPTY_ERROR;
        } else if (!state.isEmailValid) {
          return AppStrings.EMAIL_ERROR;
        }
      },
      themeType: themeType,
      inputType: TextInputType.emailAddress,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? AppColors.TEXT_GREY : Colors.white,
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      focusNode: _emailFocus,
      formFieldSubmitted: (value) {
        _emailFocus.unfocus();
        FocusScope.of(context).requestFocus(_passwordFocus);
      },
    );
  }

  Widget _showPasswordInput({
    BuildContext context,
    SignupState state,
    ThemeType themeType,
  }) {
    return TextFieldInput(
      themeType: themeType,
      textEditingController: _passwordController,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value.isEmpty) {
          return AppStrings.PASSWORD_EMPTY_ERROR;
        } else if (!state.isPasswordValid) {
          return AppStrings.PASSWORD_INVALID_ERROR;
        }
      },
      inputType: TextInputType.visiblePassword,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? AppColors.TEXT_GREY: Colors.white,
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      focusNode: _passwordFocus,
      formFieldSubmitted: (value) {
        _passwordFocus.unfocus();
        FocusScope.of(context).requestFocus(_confirmPasswordFocus);
      },
      isPassword: true,
      hintText: AppStrings.PASSWORD_HINT,
    );
  }

  Widget _showConfirmPasswordInput({
    BuildContext context,
    SignupState state,
    ThemeType themeType,
  }) {
    return TextFieldInput(
      themeType: themeType,
      textEditingController: _confirmPasswordController,
      formFieldSubmitted: (value) {
        _confirmPasswordFocus.unfocus();
      },
      isPassword: true,
      validator: (value) {
        if (value.isEmpty) {
          return AppStrings.PASSWORD_EMPTY_ERROR;
        } else if (!state.isConfirmPasswordValid) {
          return AppStrings.PASSWORD_MATCH_ERROR;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.done,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? AppColors.TEXT_GREY: Colors.white,
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      inputType: TextInputType.visiblePassword,
      focusNode: _confirmPasswordFocus,
      hintText: AppStrings.PASSWORD_HINT,
    );
  }

  Widget _signUpButton(SignupState state) {
    return RaisedGradientButton(
      child: Text(
        AppStrings.SIGNUP,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: isSignupButtonEnabled(state)
          ? () {
              _onFormSubmitted();
            }
          : null,
    );
  }

  Widget _signInText(ThemeType themeType) {
    return RichText(
      text: TextSpan(
          text: AppStrings.ALREADY_HAVE_ACCOUNT,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: themeType == ThemeType.light ? Colors.black : Colors.white,
          ),
          children: [
            TextSpan(
              recognizer: _tapGestureRecognizer,
              text: AppStrings.SIGNIN,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.DARK_AMBER,
                fontSize: 12,
              ),
            )
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    _signupBloc = context.watch<SignupBloc>();

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
              elevation: 0,
              backgroundColor: Colors.transparent,
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
              title: Text(
                AppStrings.SIGNUP,
                style: TextStyle(
                  color: themeState.type == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: getHeight(context) * 0.01,
                  ),
                  themeState.type == ThemeType.light
                      ? logoDarkImage
                      : logoImage,
                  SizedBox(
                    height: getHeight(context) * 0.12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: BlocConsumer<SignupBloc, SignupState>(
                      listener: (_, state) {
                        if (state.isSubmitting) {
                          LoadingDialog.show(context);
                        } else if (state.isSuccess) {
                          LoadingDialog.hide(context);
                          AppNavigation.navigateReplacement(
                            context,
                            BlocProvider<VerificationBloc>(
                              create: (_) => VerificationBloc(
                                  email: _emailController.text,
                                  authenticationRepository:
                                      context.read<AuthenticationRepository>()),
                              child: VerificationScreen(
                                verificationType: VerificationType.email,
                                onResendCodePressed: _onFormSubmitted,
                              ),
                            ),
                          );
                        } else if (state.isFailure) {
                          LoadingDialog.hide(context);
                          CustomSnacksBar.showSnackBar(context, state.message);
                        }
                      },
                      builder: (context, state) {
                        return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _showEmailInput(
                                    context: context,
                                    state: state,
                                    themeType: themeState.type),
                                SizedBox(height: 24),
                                _showPasswordInput(
                                    context: context,
                                    state: state,
                                    themeType: themeState.type),
                                SizedBox(height: 24),
                                _showConfirmPasswordInput(
                                    context: context,
                                    state: state,
                                    themeType: themeState.type),
                                SizedBox(
                                  height: getHeight(context) * 0.07,
                                ),
                                _signUpButton(state),
                                SizedBox(
                                  height: getHeight(context) * 0.22,
                                ),
                              ],
                            ));
                      },
                    ),
                  ),
                  _signInText(themeState.type),
                  SizedBox(
                    height: getHeight(context) * 0.04,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onEmailChanged() {
    if (_signupBloc != null) {
      _signupBloc.add(
        EmailChanged(email: _emailController.text),
      );
    }
  }

  void _onPasswordChanged() {
    if (_signupBloc != null) {
      _signupBloc.add(
        PasswordChanged(password: _passwordController.text),
      );
    }
  }

  void _onConfirmPasswordChanged() {
    if (_signupBloc != null) {
      _signupBloc.add(
        ConfirmPasswordChanged(
          confirmPassword: _confirmPasswordController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onFormSubmitted() {
    if (_signupBloc != null) {
      _signupBloc.add(
        Submitted(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }
}
