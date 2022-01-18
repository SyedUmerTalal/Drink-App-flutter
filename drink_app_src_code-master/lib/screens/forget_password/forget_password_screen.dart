import 'dart:io' show Platform;
import 'package:drink/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/blocs/verification/verification_bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/screens/verification/verification_screen.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/custom_snacks_bar.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/constant_widgets.dart';
import 'package:drink/widgets/raised_gradient_button.dart';
import 'package:drink/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final FocusNode _emailFocus = FocusNode();
  TextEditingController _emailController;
  ForgotPasswordBloc _forgotPasswordBloc;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailController.addListener(_onEmailChanged);
  }

  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isResetButtonEnabled(ForgotPasswordState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  final _formKey = GlobalKey<FormState>();

  Widget _emailTextField(
    ForgotPasswordState state,
    ThemeType themeType,
  ) {
    return TextFieldInput(
      textEditingController: _emailController,
      
      validator: (value) {
        if (value.isEmpty) {
          return AppStrings.EMAIL_EMPTY_ERROR;
        } else if (!state.isEmailValid) {
          return AppStrings.EMAIL_ERROR;
        }
      },
      themeType: themeType,
      inputAction: TextInputAction.done,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? AppColors.TEXT_GREY : Colors.white,
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      hintText: AppStrings.EMAIL_ADDRESS_GET,
      inputType: TextInputType.emailAddress,
      focusNode: _emailFocus,
      formFieldSubmitted: (value) {
        FocusScope.of(context).unfocus();
        _onFormSubmitted();
      },
    );
  }

  Widget _resetButton(ForgotPasswordState state) {
    return RaisedGradientButton(
        child: Text(
          AppStrings.RESET,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed:
            isResetButtonEnabled(state) ? () => _onFormSubmitted() : null);
  }

  @override
  Widget build(BuildContext context) {
    _forgotPasswordBloc = context.watch<ForgotPasswordBloc>();
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
              title: Text(
                AppStrings.FORGET_PASSWORD_TITLE,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: themeState.type == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: getHeight(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
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
                            verificationType: VerificationType.forgotpassword,
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
                    return Column(
                      children: [
                        Spacer(
                          flex: 3,
                        ),
                        themeState.type == ThemeType.light
                            ? logoDarkImage
                            : logoImage,
                        Spacer(flex: 3),
                        Form(
                            key: _formKey,
                            child: _emailTextField(state, themeState.type)),
                        Spacer(flex: 1),
                        _resetButton(state),
                        Spacer(
                          flex: 8,
                        ),
                      ],
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

  void _onEmailChanged() {
    if (_forgotPasswordBloc != null) {
      _forgotPasswordBloc.add(
        EmailChanged(email: _emailController.text),
      );
    }
  }

  void _onFormSubmitted() {
    if (_forgotPasswordBloc != null) {
      _forgotPasswordBloc.add(
        Submitted(
          email: _emailController.text,
        ),
      );
    }
  }
}
