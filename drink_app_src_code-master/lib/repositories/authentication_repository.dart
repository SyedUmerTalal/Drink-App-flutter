import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drink/blocs/signIn/signin_bloc.dart';
import 'package:drink/models/user.dart';
import 'package:drink/screens/signin/signin_screen.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/device_info.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/network_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

// enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({
    FacebookLogin facebookLogin,
  }) : _facebookLogin = facebookLogin ?? FacebookLogin();
  final _controller = StreamController<UserModel>();
  final Uuid uuid = Uuid();

  Stream<UserModel> get currentUser async* {
    await DeviceInfo.instance.getDeviceToken();
    final data = SharedPref.instance.sharedPreferences.getString('currentUser');
    if (data?.isNotEmpty ?? false) {
      final mappedData = jsonDecode(data);
      final UserModel user = UserModel.fromJson(mappedData);
      _controller.sink.add(user);
    } else {
      _controller.add(null);
    }
    yield* _controller.stream;
  }

  void unVerifiedScreen(UserModel user) {
    _controller.add(user);
  }

// If FirebaseAuth and/or GoogleSignIn are not injected into the AuthenticationRepository, then we instantiate them internally.
// This allows us to be able to inject mock instances so that we can easily test the AuthenticationRepository

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FacebookLogin _facebookLogin;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> signInWithFacebook() async {
    // https://github.com/roughike/flutter_facebook_login/issues/210
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final FacebookLoginResult result =
        await _facebookLogin.logIn(<String>['public_profile']);
    if (result.accessToken != null) {
      // UserCredential authResult = await _firebaseAuth.signInWithCredential(
      //   FacebookAuthProvider.credential(result.accessToken.token),
      // );

      final Response response = await _socialLogin(
        provider: API.FACEBOOK_SIGN_IN,
        accessToken: result.accessToken.token,
      );
      _updateAuthState(response);
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by authResult.user');
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        // final user = await _firebaseAuth
        //     .signInWithCredential(GoogleAuthProvider.credential(
        //   idToken: googleAuth.idToken,
        //   accessToken: googleAuth.accessToken,
        // ));
        final Response response = await _socialLogin(
            provider: API.GOOGLE_SIGN_IN, accessToken: googleAuth.accessToken);
        _updateAuthState(response);
      } else {
        // _controller.add(AuthenticationStatus.unauthenticated);
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      // _controller.add(AuthenticationStatus.unauthenticated);
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by authResult.user');
    }
  }

  ////////////////////////// Login //////////////////////////////////////
  Future<void> login({String email, String password}) async {
    final FormData _formData = FormData.fromMap({
      'email': email,
      'password': password,
      'device_type': Platform.isIOS ? API.IOS : API.ANDROID,
      'device_token': DeviceInfo.instance.token,
    });

    final Response _response =
        await _postRequest(endPoint: API.LOGIN, formData: _formData);
    // debugger();
    _updateAuthState(_response);
  }

  Future<void> signInWithPhone(
      String smsCode, String verificationCode, String phoneNumber) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationCode,
        smsCode: smsCode,
      );
      final user = await _firebaseAuth.signInWithCredential(credential);
      // String idToken = await user.user.getIdToken();
      // print(idToken.toString() + ' Token');

      final Response response = await _socialLogin(
        provider: API.PHONE_SIGN_IN,
        accessToken: user.user.uid,
      );
      _updateAuthState(response);
    } catch (e) {
      throw PlatformException(
        code: 'ERROR_AUTHORIZATION_DENIED',
        message: e.message,
      );
    }
  }

  ////////////////////////// Complete Profile //////////////////////////////////

  Future<void> completeProfile(
      {String name,
      String gender,
      String dateOfBirth,
      String imagePath,
      String token}) async {
    try {
      // debugger();
      final FormData _formData = FormData.fromMap({
        'name': name,
        // 'gender': gender,
        // 'date_of_birth': dateOfBirth,
        'profile_picture': imagePath != null
            ? await MultipartFile.fromFile(imagePath,
                filename: '${uuid.v4()}.png')
            : ''
      });
      // debugger();
      final Response _response = await _authpostRequest(
        endPoint: API.COMPLETE_PROFILE,
        formData: _formData,
        token: token ??
            SharedPref.instance.sharedPreferences.getString('bearer_token'),
      );
      // debugger();
      _updateAuthState(
        _response,
      );
    } catch (e) {
      print(e.toString());
      throw PlatformException(
        code: 'ERROR_AUTHORIZATION_DENIED',
        message: e.toString(),
      );
    }
  }

  ////////////////////////// Sign Up //////////////////////////////////
  Future<void> signUp({String email, String password}) async {
    final FormData _formData = FormData.fromMap({
      'email': email,
      'password': password,
      'device_type': Platform.isIOS ? API.IOS : API.ANDROID,
      'device_token': DeviceInfo.instance.token,
    });

    final Response _response =
        await _postRequest(endPoint: API.SIGN_UP, formData: _formData);
    final dynamic _jsonResponse = _response.data;
    if (_jsonResponse['status'] == 0) {
      throw PlatformException(code: '0', message: _jsonResponse['message']);
    }
    // _controller.add(UserModel.fromJson(_response.data));

    // SharedPref.instance.sharedPreferences.setString('currentUser',
    //     UserModel.fromJson(_response.data['data']).toJson().toString());
  }

  Future<void> signInWithApple(
      {List<AppleIDAuthorizationScopes> scopes = const []}) async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: result.identityToken,
        accessToken: result.authorizationCode,
      );

      final authResult = await _firebaseAuth.signInWithCredential(credential);
      // final firebaseUser = authResult.user;

      // await firebaseUser.updateProfile(
      //     displayName: '${result.givenName} ${result.familyName}');
      final Response response = await _socialLogin(
        provider: API.APPLE_SIGN_IN,
        accessToken: authResult.user.uid,
      );
      _updateAuthState(response);
    } catch (e) {
      // _controller.add(AuthenticationStatus.unauthenticated);

      throw PlatformException(
        code: 'ERROR_AUTHORIZATION_DENIED',
        message: e.toString(),
      );
    }
  }

  void verifyPhone(String phone, SigninBloc signinBloc) {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          _firebaseAuth
              .signInWithCredential(authCredential)
              .then((UserCredential authResult) {
            if (authResult != null) {}
          }).catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          signinBloc.add(VerificationFailedWithPhone(authException.message));
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          signinBloc.add(CodeSentWithPhone(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print('Timeout');
        });
  }

  Future<void> signOut() async {
    _controller.add(null);
    SharedPref.instance.clear();
  }

  Future<void> deleteAccount() async {
    final FormData _formData = FormData.fromMap({});
    final Response _response = await _authpostRequest(
      endPoint: API.DELETE_ACCOUNT,
      formData: _formData,
      token: SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    _controller.add(null);
    _validateResponse(_response);

    await Future.delayed(Duration(seconds: 1), () {
      SharedPref.instance.clear();
    });
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<void> logOut() async {
    final FormData _formData = FormData.fromMap({});
    final Response _response = await _authpostRequest(
      endPoint: API.LOGOUT,
      formData: _formData,
      token: SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    _controller.add(null);
    _validateResponse(_response);

    await Future.delayed(Duration.zero, () {
      SharedPref.instance.clear();
    });
    // _controller.add(AuthenticationStatus.unauthenticated);
  }

  // void dispose() => _controller.close();

  ////////////////////////// Social Login //////////////////////////////////////
  Future<Response> _socialLogin({
    String provider,
    String accessToken,
  }) async {
    final FormData _formData = FormData.fromMap({
      'provider': provider,
      'access_token': accessToken,
      'device_type': Platform.isIOS ? API.IOS : API.ANDROID,
      'device_token': DeviceInfo.instance.token,
    });

    final Response _response =
        await _postRequest(endPoint: API.SOCIAL_LOGIN, formData: _formData);

    _updateAuthState(
      _response,
    );
    return _response;
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<Response> _postRequest({String endPoint, FormData formData}) async {
    final Response _response = await Network.instance.postRequest(
      endPoint: endPoint,
      formData: formData,
    );
    return _response;
  }

  ////////////////// Auth Post Request /////////////////////////////////////////
  Future<Response> _authpostRequest(
      {String endPoint, FormData formData, String token}) async {
    final Response _response = await Network.instance.authPostRequest(
      endPoint: endPoint,
      formData: formData,
      bearerToken: token,
    );
    return _response;
  }

  ////////////////// Update Auth State ////////////////////////////////////
  void _updateAuthState(
    Response response,
  ) {
    // debugger();
    final dynamic _jsonResponse = response.data;
    if (_jsonResponse['status'] == 1 &&
        _jsonResponse['message'] !=
            'We have sent OTP verification code at your email address') {
      final UserModel _userModel = UserModel.fromJson(response.data['data'],
          token: _jsonResponse['bearer_token']);
      if (_jsonResponse['bearer_token'] != null) {
        print(_jsonResponse['bearer_token']);
        SharedPref.instance.sharedPreferences
            .setString('bearer_token', _jsonResponse['bearer_token']);
      }
      SharedPref.instance.sharedPreferences
          .setString('currentUser', jsonEncode(_userModel));
      SharedPref.instance.sharedPreferences
          .setString('currentUserId', response.data['data']['id'].toString());
      _controller.add(_userModel);

      SharedPref.instance.sharedPreferences.setBool('ShowDealAlert', true);
    } else {
      throw PlatformException(
        code: '0',
        message: _jsonResponse['message'],
      );
    }
  }

  void _validateResponse(
    Response response,
  ) {
    final dynamic _jsonResponse = response.data;
    if (_jsonResponse['status'] == 1) {
      // AppNavigation.showToast(message: _jsonResponse['message']);
    } else {
      throw PlatformException(
        code: '0',
        message: _jsonResponse['message'],
      );
    }
  }

  ////////////////////////// Verify OTP Email //////////////////////////////////
  Future<void> verifyOTP({String email, String otp}) async {
    final FormData _formData = FormData.fromMap({
      'email': email,
      'otp': otp,
      'device_type': Platform.isIOS ? API.IOS : API.ANDROID,
      'device_token': DeviceInfo.instance.token,
    });

    final Response _response =
        await _postRequest(endPoint: API.VERIFY_OTP, formData: _formData);
    _updateAuthState(_response);
  }

  Future<void> changePassword(
      {String oldPassword, String newPassword, String token}) async {
    print(token.toString() + ' This is the token');
    final FormData _formData = FormData.fromMap({
      'old_password': oldPassword,
      'new_password': newPassword,
    });

    final Response _response = await _authpostRequest(
      endPoint: API.CHANGE_PASSWORD,
      formData: _formData,
      token: token,
    );
    _validateResponse(_response);
  }

  /////////////////  RESET PASSWORD /////////////////////////
  Future<void> forgotPassword(String email) async {
    final FormData _formData = FormData.fromMap({
      'email': email,
    });
    final Response _response = await _postRequest(
      endPoint: API.FORGOT_PASSWORD,
      formData: _formData,
    );
    _validateResponse(_response);
  }

  ////////////////////////// Verify OTP Email //////////////////////////////////
  Future<void> forgotPasswordReset(
      {String email, String newpassword, String otp}) async {
    final FormData _formData = FormData.fromMap({
      'email': email,
      'otp': otp,
      'new_password': newpassword,
    });

    final Response _response =
        await _postRequest(endPoint: API.RESET_PASSWORD, formData: _formData);
    _validateResponse(_response);
  }
}
