import 'dart:developer';
import 'dart:io' show Platform;
import 'package:drink/blocs/authentication/authentication_bloc.dart';
import 'package:drink/blocs/change_password/change_password_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/blocs/tips/tips_cubit.dart';
import 'package:drink/blocs/tips/tips_state.dart';
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

class TipScreen extends StatefulWidget {
  const TipScreen({Key key, @required this.orderId}) : super(key: key);
  final int orderId;

  @override
  _TipScreenState createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  final TextEditingController _tip_text_controller = TextEditingController();

  Widget appBatTitle = AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        AppStrings.ADD_TIP,
        style: TextStyle(color: Colors.white),
      ));
  UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = context.read<AuthenticationBloc>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TipsCubit, TipsState>(
      listener: (context, state) {
        if (state is TipsLoadingState) {
          LoadingDialog.show(context);
        } else if (state is TipsLoadedState) {
          // debugger();
          LoadingDialog.hide(context);
          // CustomSnacksBar.showSnackBar(context, state.message);
          // AppNavigation.showToast(message: state.message);
          Navigator.of(context).pop({'message': state.message});
        } else if (state is TipsFailedState) {
          LoadingDialog.hide(context);
          // CustomSnacksBar.showSnackBar(context, state.message);
          // AppNavigation.showToast(message: state.message);
          Navigator.of(context).pop({'message': state.message});
        }
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
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
                  AppStrings.ADD_TIP,
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
                  child: Column(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppStrings.ENTER_TIP,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: themeState.type == ThemeType.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFieldInput(
                              themeType: themeState.type,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return AppStrings.TIP_EMPTY_ERROR;
                                }
                              },
                              onChanged: (value) {
                                // value;
                              },
                              textEditingController: _tip_text_controller,
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: themeState.type == ThemeType.light
                                    ? AppColors.TEXT_GREY
                                    : Colors.white,
                              ),
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: themeState.type == ThemeType.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              hintText: AppStrings.ENTER_TIP_HINT,
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                              // focusNode: _emailFocus,
                              // formFieldSubmitted: (value) {
                              //   // _email = value;
                              //   _emailFocus.unfocus();
                              //   FocusScope.of(context).requestFocus(_passwordFocus);
                              // }
                            ),
                          ],
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      // RaisedGradientButton(
                      //   child: Text(
                      //     AppStrings.GIVE_TIPS,
                      //     style: TextStyle(
                      //         color: Colors.white, fontWeight: FontWeight.bold),
                      //   ),
                      //   onPressed: () {
                      //
                      //   },
                      // ),
                      payTipButton(),
                      Spacer(
                        flex: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget payTipButton() {
    return BlocBuilder<TipsCubit, TipsState>(
      builder: (context, state) => RaisedGradientButton(
        child: Text(
          AppStrings.GIVE_TIPS,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: state is TipsInitialState
            ? () {
                if (validIntOrNot(_tip_text_controller.text)) {
                  context.read<TipsCubit>().postTips(
                      widget.orderId, int.parse(_tip_text_controller.text));
                }
              }
            : null,
      ),
    );
  }

  bool validIntOrNot(String value) {
    if (value != null) {
      if (value.isNotEmpty || value != '0') {
        try {
          int newValue = int.tryParse(value);
          return true;
        } catch (e) {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
