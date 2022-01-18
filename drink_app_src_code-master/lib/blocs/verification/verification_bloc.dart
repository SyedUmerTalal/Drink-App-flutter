import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc({
    @required AuthenticationRepository authenticationRepository,
    this.email,
    this.phoneNumber,
    this.verificationCode,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(VerificationInitial());
  final AuthenticationRepository _authenticationRepository;
  final String email;
  final String phoneNumber;
  final String verificationCode;

  @override
  Stream<VerificationState> mapEventToState(
    VerificationEvent event,
  ) async* {
    if (event is SubmitVerification) {
      yield* _mapSubmitVerificationToState(event.type, event.code);
    }
  }

  Stream<VerificationState> _mapSubmitVerificationToState(
      VerificationType type, String otp) async* {
    yield VerificationSubmitting();
    try {
      if (type == VerificationType.email) {
        print(email.toString());
        await _authenticationRepository.verifyOTP(email: email, otp: otp);
      } else {
        print(phoneNumber);
        await _authenticationRepository.signInWithPhone(
            otp, verificationCode, phoneNumber);
      }
      yield VerificationSuccessful();
    } catch (e) {
      if (e is PlatformException) {
        yield VerificationFailure(e.message);
      } else {
        yield VerificationFailure(e.toString());
      }
    }
  }
}
