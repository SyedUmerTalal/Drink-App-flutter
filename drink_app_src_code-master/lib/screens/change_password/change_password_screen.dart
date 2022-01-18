import 'dart:io' show Platform;
import 'package:drink/blocs/authentication/authentication_bloc.dart';
import 'package:drink/blocs/change_password/change_password_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/user.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    Key key,
    this.isResetForgotPassword = false,
    this.email,
  }) : super(key: key);
  final bool isResetForgotPassword;
  final String email;
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with EmailAndPasswordValidators {
  bool passwordVisible = false;

  bool confirmPasswordVisible = false;
  String password;

  final FocusNode _oldPasswordFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();

  TextEditingController _eamilController;

  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  ChangePasswordBloc _changePasswordBloc;

  Widget appBatTitle = AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        AppStrings.CHANGE_PASSWORD,
        style: TextStyle(color: Colors.white),
      ));
  UserModel _currentUser;

  bool get isPopulated => widget.isResetForgotPassword;

  bool isChangePasswordButtonEnabled(ChangePasswordState state) {
    return state.isFormValid && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _currentUser = context.read<AuthenticationBloc>().currentUser;
    _eamilController = TextEditingController();
    _eamilController.text = widget.email ?? _currentUser.email;
    _oldPasswordController.addListener(_onOldPasswordChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  final _formKey = GlobalKey<FormState>();

  Widget _showOldPasswordInput({
    BuildContext context,
    ChangePasswordState state,
    ThemeType themeType,
  }) {
    return TextFieldInput(
      textEditingController: _oldPasswordController,
      themeType: themeType,
      isPassword: true,
      hintText: AppStrings.OLD_PASSWORD,
      inputAction: TextInputAction.next,
      validator: (value) =>
          state.isOldPasswordValid ? null : AppStrings.PASSWORD_EMPTY_ERROR,
      inputType: TextInputType.visiblePassword,
      formFieldSubmitted: (value) {
        _passwordFocus.unfocus();
        FocusScope.of(context).requestFocus(_confirmPasswordFocus);
      },
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      onChanged: (value) {
        password = value;
      },
      focusNode: _oldPasswordFocus,
    );
  }

  Widget _showPasswordInput({
    BuildContext context,
    ChangePasswordState state,
    ThemeType themeType,
  }) {
    return TextFieldInput(
      textEditingController: _passwordController,
      themeType: themeType,
      isPassword: true,
      hintText: AppStrings.NEW_PASSWORD,
      inputAction: TextInputAction.next,
      validator: (value) {
        if (value.isEmpty) {
          return AppStrings.PASSWORD_EMPTY_ERROR;
        } else if (!state.isNewPasswordValid) {
          return AppStrings.PASSWORD_INVALID_ERROR;
        }
      },
      inputType: TextInputType.visiblePassword,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? AppColors.TEXT_GREY : Colors.white,
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      formFieldSubmitted: (value) {
        _passwordFocus.unfocus();
        FocusScope.of(context).requestFocus(_confirmPasswordFocus);
      },
      onChanged: (value) {
        password = value;
      },
      focusNode: _passwordFocus,
    );
  }

  Widget _showConfirmPasswordInput({
    BuildContext context,
    ChangePasswordState state,
    ThemeType themeType,
  }) {
    return TextFieldInput(
      themeType: themeType,
      textEditingController: _confirmPasswordController,
      isPassword: true,
      hintText: AppStrings.CONFIRM_NEW_PASSWORD,
      formFieldSubmitted: (value) {
        _confirmPasswordFocus.unfocus();
        FocusScope.of(context).unfocus();
      },
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
      inputType: TextInputType.visiblePassword,
      focusNode: _confirmPasswordFocus,
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? Colors.black : Colors.white,
      ),
      hintStyle: TextStyle(
        fontWeight: FontWeight.w500,
        color: themeType == ThemeType.light ? AppColors.TEXT_GREY : Colors.white,
      ),
    );
  }

  Widget _updateButton(ChangePasswordState state) {
    return RaisedGradientButton(
      child: Text(
        AppStrings.UPDATE,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: isChangePasswordButtonEnabled(state)
          ? () {
              _onFormSubmitted();
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    _changePasswordBloc = context.watch<ChangePasswordBloc>();

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
                AppStrings.CHANGE_PASSWORD,
                style: TextStyle(
                  color: themeState.type == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: getHeight(context) - kToolbarHeight,
                child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                  listener: (_, state) {
                    if (state.isSubmitting) {
                      LoadingDialog.show(context);
                    } else if (state.isSuccess) {
                      LoadingDialog.hide(context);
                      if (!widget.isResetForgotPassword) {
                        AppNavigation.navigatorPop(context);
                      } else {
                        AppNavigation.navigatorPop(context);
                        AppNavigation.navigatorPop(context);
                      }
                    } else if (state.isFailure) {
                      LoadingDialog.hide(context);
                      WidgetsBinding.instance.focusManager.primaryFocus
                          .unfocus();
                      CustomSnacksBar.showSnackBar(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(
                          flex: 1,
                        ),
                        themeState.type == ThemeType.light
                            ? logoDarkImage
                            : logoImage,
                        Spacer(
                          flex: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // _showEmailInput(context: context),
                                  SizedBox(height: 24),
                                  !widget.isResetForgotPassword
                                      ? _showOldPasswordInput(
                                          context: context,
                                          state: state,
                                          themeType: themeState.type)
                                      : SizedBox.shrink(),
                                  !widget.isResetForgotPassword
                                      ? SizedBox(height: 24)
                                      : SizedBox.shrink(),
                                  _showPasswordInput(
                                    context: context,
                                    state: state,
                                    themeType: themeState.type,
                                  ),
                                  SizedBox(height: 24),
                                  _showConfirmPasswordInput(
                                    context: context,
                                    state: state,
                                    themeType: themeState.type,
                                  )
                                ],
                              )),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        _updateButton(state),
                        Spacer(
                          flex: 5,
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

  void _onOldPasswordChanged() {
    if (_changePasswordBloc != null) {
      _changePasswordBloc.add(
        OldPasswordChanged(oldPassword: _oldPasswordController.text),
      );
    }
  }

  void _onPasswordChanged() {
    if (_changePasswordBloc != null) {
      _changePasswordBloc.add(
        NewPasswordChanged(password: _passwordController.text),
      );
    }
  }

  void _onConfirmPasswordChanged() {
    if (_changePasswordBloc != null) {
      _changePasswordBloc.add(
        ConfirmNewPasswordChanged(
          confirmPassword: _confirmPasswordController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onFormSubmitted() {
    if (_changePasswordBloc != null) {
      if (!widget.isResetForgotPassword) {
        _changePasswordBloc.add(
          Submitted(
            oldPasswrod: _oldPasswordController.text,
            newPassword: _passwordController.text,
            token: context.read<AuthenticationBloc>().currentUser?.token,
          ),
        );
      } else {
        _changePasswordBloc.add(
          Submitted(
            email: widget.email,
            newPassword: _passwordController.text,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _eamilController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _oldPasswordFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
  }
}
