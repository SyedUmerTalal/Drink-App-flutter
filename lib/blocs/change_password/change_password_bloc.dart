import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:drink/utility/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState>
    with EmailAndPasswordValidators {
  ChangePasswordBloc({
    @required AuthenticationRepository authenticationRepository,
    this.otp,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(ChangePasswordState.empty());
  final AuthenticationRepository _authenticationRepository;
  final String otp;

  @override
  Stream<Transition<ChangePasswordEvent, ChangePasswordState>> transformEvents(
    Stream<ChangePasswordEvent> events,
    TransitionFunction<ChangePasswordEvent, ChangePasswordState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return event is! OldPasswordChanged &&
          event is! NewPasswordChanged &&
          event is! ConfirmNewPasswordChanged;
    });
    final debounceStream = events.where((event) {
      return event is OldPasswordChanged ||
          event is NewPasswordChanged ||
          event is ConfirmNewPasswordChanged;
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is OldPasswordChanged) {
      yield* _mapOldPasswordChangedToState(event.oldPassword);
    } else if (event is NewPasswordChanged) {
      yield* _mapNewPasswordChangedToState(event.password);
    } else if (event is ConfirmNewPasswordChanged) {
      yield* _mapConfirmNewPasswordChangedToState(
          event.password, event.confirmPassword);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(
        oldPassword: event.oldPasswrod,
        newPassword: event.newPassword,
        token: event.token,
        email: event.email,
        otpmobil: otp,
      );
    }
  }

  Stream<ChangePasswordState> _mapOldPasswordChangedToState(
      String oldPassword) async* {
    yield state.update(isOldPasswordValid: oldPassword?.isNotEmpty);
  }

  Stream<ChangePasswordState> _mapNewPasswordChangedToState(
      String newPassword) async* {
    yield state.update(
        isNewPasswordValid: passwordValidValidator.isValid(newPassword));
  }

  Stream<ChangePasswordState> _mapConfirmNewPasswordChangedToState(
      String newPassword, String confirmNewPassword) async* {
    yield state.update(
        isConfirmPasswordValid: newPassword == confirmNewPassword);
  }

  Stream<ChangePasswordState> _mapSubmittedToState(
      {String oldPassword,
      String newPassword,
      String token,
      String email,
      String otpmobil}) async* {
    yield ChangePasswordState.submitting();
    try {
      if (otp?.isEmpty ?? true) {
        await _authenticationRepository.changePassword(
            oldPassword: oldPassword, newPassword: newPassword, token: token);
      } else {
        print('Ahsan $email $newPassword $otpmobil');
        await _authenticationRepository.forgotPasswordReset(
            email: email, newpassword: newPassword, otp: otpmobil);
      }

      yield ChangePasswordState.success();
    } on PlatformException catch (e) {
      yield ChangePasswordState.failure(e.message);
    } on SocketException catch (e) {
      yield ChangePasswordState.failure(e.message);
    } on AuthException {
      yield state.copyWith(isUnAuthenticated: true);
    } catch (e) {
      yield ChangePasswordState.failure(e.message);
    }
  }
}
