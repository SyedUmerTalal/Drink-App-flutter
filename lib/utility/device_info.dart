import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInAvailable {
  AppleSignInAvailable._init();

  static AppleSignInAvailable _instance;

  static AppleSignInAvailable get instance {
    _instance ??= AppleSignInAvailable._init();
    return _instance;
  }

  bool isAvailable;

  Future<void> check() async {
    isAvailable = await SignInWithApple.isAvailable();
  }
}

class DeviceInfo {
  DeviceInfo._init();

  static DeviceInfo _instance;

  static DeviceInfo get instance {
    _instance ??= DeviceInfo._init();
    return _instance;
  }

  final FirebaseMessaging _firebasemessaging = FirebaseMessaging.instance;

  String token;

  Future<void> getDeviceToken() async {
    token = await _firebasemessaging.getToken();
  }
}
