import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState>
    with EmailAndPasswordValidators {
  SigninBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(SigninState.empty());
  final AuthenticationRepository _authenticationRepository;
  String _verificationId, _phoneNumber;
  @override
  Stream<Transition<SigninEvent, SigninState>> transformEvents(
    Stream<SigninEvent> events,
    TransitionFunction<SigninEvent, SigninState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return event is! EmailChanged && event is! PasswordChanged;
    });
    final debounceStream = events.where((event) {
      return event is EmailChanged || event is PasswordChanged;
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<SigninState> mapEventToState(SigninEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SigninWithGooglePressed) {
      yield* _mapSigninWithGooglePressedToState();
    } else if (event is SigninWithFacebookPressed) {
      yield* _mapSigninWithFacebookPressed();
    } else if (event is SigninWithApplePressed) {
      yield* _mapSigninWithApplePressedToState();
    } else if (event is SendVerificationCodePressed) {
      yield* _mapSendVerificationCodePressedToState(phone: event.phone);
    } else if (event is SigninWithCredentialsPressed) {
      yield* _mapSigninWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    } else if (event is PhoneChanged) {
      _phoneNumber = event.phone;
      yield* _mapPhoneChangedToState(event.phone);
    } else if (event is SigninWithPhonePressed) {
      yield* _mapSigninWithPhonePressedToState(
        smsCode: event.smsCode,
      );
    } else if (event is VerificationFailedWithPhone) {
      yield SigninState.failure(event.error);
    } else if (event is CodeSentWithPhone) {
      _verificationId = event.verificationId;
      yield SigninState.success(verificationCode: _verificationId);
    } else if (event is VerificationSubmit) {
      yield* _mapVerificationSubmitToState(event.email, event.password);
    }
  }

  Stream<SigninState> _mapVerificationSubmitToState(
      String email, String password) async* {
    yield SigninState.loading();
    try {
      await _authenticationRepository.signUp(
        email: email,
        password: password,
      );
      yield SigninState.success();
    } on PlatformException catch (e) {
      yield SigninState.failure(e.message);
    } catch (e) {
      yield SigninState.failure(e);
    }
  }

  Stream<SigninState> _mapPhoneChangedToState(String phone) async* {
    yield state.update(
      isPhoneValid: phone.length == 10,
    );
  }

  Stream<SigninState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: emailSignUpValidator.isValid(email),
    );
  }

  Stream<SigninState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: passwordValidValidator.isValid(password),
    );
  }

  Stream<SigninState> _mapSigninWithGooglePressedToState() async* {
    try {
      await _authenticationRepository.signInWithGoogle();
      yield SigninState.success();
    } on PlatformException catch (e) {
      yield SigninState.failure(e.message);
    }
  }

  Stream<SigninState> _mapSigninWithFacebookPressed() async* {
    try {
      yield SigninState.loading();
      print(SharedPref.instance.sharedPreferences.getString('currentUser'));
      await _authenticationRepository.signInWithFacebook();

      yield SigninState.success();
    } on PlatformException catch (e) {
      yield SigninState.failure(e.message);
    }
  }

  Stream<SigninState> _mapSigninWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SigninState.loading();
    try {
      await _authenticationRepository.login(email: email, password: password);
      yield SigninState.success();
    } on PlatformException catch (e) {
      yield SigninState.failure(e.message);
    } catch (e) {
      yield SigninState.failure(e.message);
    }
  }

  Stream<SigninState> _mapSendVerificationCodePressedToState({
    String phone,
  }) async* {
    yield SigninState.loading();
    try {
      _authenticationRepository.verifyPhone(phone, this);
    } catch (e) {
      yield SigninState.failure(e.message);
    }
  }

  Stream<SigninState> _mapSigninWithApplePressedToState() async* {
    try {
      yield SigninState.loading();
      await _authenticationRepository.signInWithApple();
      yield SigninState.success();
    } on PlatformException catch (e) {
      yield SigninState.failure(e.message);
    }
  }

  Stream<SigninState> _mapSigninWithPhonePressedToState(
      {String smsCode}) async* {
    yield SigninState.loading();
    try {
      await _authenticationRepository.signInWithPhone(
          smsCode, _verificationId, _phoneNumber);
      yield SigninState.success();
    } on PlatformException catch (e) {
      yield SigninState.failure(e.message);
    }
  }
}
