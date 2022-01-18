import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:drink/utility/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState>
    with EmailAndPasswordValidators {
  ForgotPasswordBloc(
      {@required AuthenticationRepository authenticationRepository})
      : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(ForgotPasswordState.empty());
  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event.email);
    }
  }

  Stream<ForgotPasswordState> _mapEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: emailSignUpValidator.isValid(email));
  }

  Stream<ForgotPasswordState> _mapSubmittedToState(String email) async* {
    yield ForgotPasswordState.loading();

    try {
      await _authenticationRepository.forgotPassword(email);
      yield ForgotPasswordState.success();
    } on AuthException {
      yield state.copyWith(
        isUnAuthenticated: true,
      );
    } catch (e) {
      if (e is PlatformException) {
        yield ForgotPasswordState.failure(e.message);
      } else {
        yield ForgotPasswordState.failure(e.toString());
      }
    }
  }
}
