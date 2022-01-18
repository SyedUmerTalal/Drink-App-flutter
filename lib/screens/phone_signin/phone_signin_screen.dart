import 'dart:io' show Platform;
import 'package:drink/blocs/signIn/signin_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/blocs/verification/verification_bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/screens/sign_up/sign_up_screen.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drink/screens/verification/verification_screen.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/utility/validators.dart';
import 'package:drink/widgets/constant_widgets.dart';
import 'package:drink/widgets/raised_gradient_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:drink/blocs/signUp/signup_bloc.dart';
import 'package:drink/utility/custom_snacks_bar.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneSigninScreen extends StatefulWidget {
  const PhoneSigninScreen({Key key}) : super(key: key);

  @override
  _PhoneSigninScreenState createState() => _PhoneSigninScreenState();
}

class _PhoneSigninScreenState extends State<PhoneSigninScreen>
    with EmailAndPasswordValidators {
  bool visible = false;
  SigninBloc _signinBloc;
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  TapGestureRecognizer _tapGestureRecognizer;
  final _formKey = GlobalKey<FormState>();
  String selectedCountryCode = '';
  String _number;
  final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
  String isoCountryCode;

  bool get isPopulated => _phoneController.text.isNotEmpty;

  bool isSigninButtonEnabled(SigninState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    isoCountryCode = systemLocales.first.countryCode;
    print(isoCountryCode.toString() + 'This is the country code');
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () => AppNavigation.navigateTo(
            context,
            BlocProvider(
              create: (_) => SignupBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
              ),
              child: SignUpScreen(),
            ),
          );

    _phoneController.addListener(onPhoneNumberChanged);
  }

  void onPhoneNumberChanged() {
    if (_signinBloc != null) {}
    _signinBloc.add(
      PhoneChanged(phone: _phoneController.text),
    );
  }

  void onFormSubmitted() {
    if (_signinBloc != null) {
      print('$_number${_phoneController.text}');
      _signinBloc.add(SendVerificationCodePressed(
          phone: '$_number${_phoneController.text}'));
    }
  }

  Widget _phoneInput(SigninState state, ThemeType themeType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.PHONE_NUMBER,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeType == ThemeType.light ? Colors.black : Colors.white,
          ),
        ),
        SizedBox(height: 8),
        IntlPhoneField(
          isLightTheme: themeType == ThemeType.light,
          controller: _phoneController,
          countryCodeTextColor:
              themeType == ThemeType.light ? Colors.black : Colors.white,
          showDropdownIcon: false,
          style: TextStyle(
            color: themeType == ThemeType.light ? Colors.black : Colors.white,
            fontSize: 14,
          ),

          onChanged: (phoneNumber) {
            print(phoneNumber.toString() + 'Ahsan');
            _number = phoneNumber.countryCode;
          },

          focusNode: _phoneFocus,
          // validator: (value)=>value.isEmpty?AppStrings:,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.GOLDEN,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            hintText: AppStrings.PHONE_NUMBER,
            hintStyle: TextStyle(
              color: themeType == ThemeType.light ? Colors.black : Colors.white,
              fontSize: 14,
            ),
          ),
          initialCountryCode: isoCountryCode,
          onSubmitted: (value) {
            _phoneFocus.unfocus();
          },
        )
      ],
    );
  }

  Widget _signInButton(SigninState state) {
    return RaisedGradientButton(
      child: Text(
        AppStrings.SIGN_IN,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: isSigninButtonEnabled(state) ? onFormSubmitted : null,
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
              title: Text(
                AppStrings.SIGNIN,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
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
                child: BlocConsumer<SigninBloc, SigninState>(
                  listener: (context, state) {
                    if (state.isFailure) {
                      LoadingDialog.hide(context);
                      CustomSnacksBar.showSnackBar(context, state.message);
                    } else if (state.isSuccess) {
                      LoadingDialog.hide(context);
                      AppNavigation.navigateTo(
                        context,
                        BlocProvider<VerificationBloc>(
                          create: (_) => VerificationBloc(
                              phoneNumber: '${_phoneController.text}',
                              verificationCode: state.verificationCode,
                              authenticationRepository:
                                  context.read<AuthenticationRepository>()),
                          child: VerificationScreen(
                            verificationType: VerificationType.phone,
                            onResendCodePressed: onFormSubmitted,
                          ),
                        ),
                      );
                    } else if (state.isSubmitting) {
                      LoadingDialog.show(context);
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
                              flex: 3,
                            ),
                            themeState.type == ThemeType.light
                                ? logoDarkImage
                                : logoImage,
                            Spacer(
                              flex: 2,
                            ),
                            _phoneInput(state, themeState.type),
                            SizedBox(
                              height: 24,
                            ),
                            _signInButton(state),
                            Spacer(
                              flex: 8,
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

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _tapGestureRecognizer.dispose();
    _phoneFocus.dispose();
  }
}
