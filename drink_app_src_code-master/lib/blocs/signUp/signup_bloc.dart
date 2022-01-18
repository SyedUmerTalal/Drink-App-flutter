import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:drink/utility/validators.dart';

import 'package:meta/meta.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState>
    with EmailAndPasswordValidators {
  SignupBloc({@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(SignupState.empty());
  final AuthenticationRepository _authenticationRepository;

  String _email;

  @override
  Stream<Transition<SignupEvent, SignupState>> transformEvents(
    Stream<SignupEvent> events,
    TransitionFunction<SignupEvent, SignupState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return event is! EmailChanged &&
          event is! PasswordChanged &&
          event is! ConfirmPasswordChanged;
    });
    final debounceStream = events.where((event) {
      return event is EmailChanged ||
          event is PasswordChanged ||
          event is ConfirmPasswordChanged;
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is ConfirmPasswordChanged) {
      yield* _mapConfirmPasswordChangedToState(
          event.password, event.confirmPassword);
    } else if (event is VerifyEmail) {
      yield* _mapVerifyEmailToState(event.verifyOTP);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        event.email,
        event.password,
      );
    }
  }

  Stream<SignupState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: emailSignUpValidator.isValid(email),
    );
  }

  Stream<SignupState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: passwordValidValidator.isValid(password),
    );
  }

  Stream<SignupState> _mapConfirmPasswordChangedToState(
      String password, String confirmPassword) async* {
    yield state.update(isConfirmPasswordValid: password == confirmPassword);
  }

  Stream<SignupState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield SignupState.loading();
    try {
      _email = email;
      await _authenticationRepository.signUp(
        email: email,
        password: password,
      );
      // await _authenticationRepository.updateAuth(
      //     name: name, birthday: birthday);
      yield SignupState.success();
    } catch (e) {
      if (e is PlatformException) {
        yield SignupState.failure(e.message);
      } else {
        yield SignupState.failure(e.toString());
      }
    }
  }

  Stream<SignupState> _mapVerifyEmailToState(String verifyOTP) async* {
    yield SignupState.loading();
    try {
      await _authenticationRepository.verifyOTP(email: _email, otp: verifyOTP);
      yield SignupState.success();
    } catch (e) {
      yield SignupState.failure(state.message);
    }
  }
}
