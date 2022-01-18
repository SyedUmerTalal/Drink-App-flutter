part of 'verification_bloc.dart';

enum VerificationType { email, phone, forgotpassword }

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object> get props => [];
}

class SubmitVerification extends VerificationEvent {
  const SubmitVerification({this.code, this.type});

  final String code;
  final VerificationType type;

  @override
  List<Object> get props => [code, type];
}

class VerificationFailedWithPhone extends VerificationEvent {
  const VerificationFailedWithPhone(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

class CodeSentWithPhone extends VerificationEvent {
  const CodeSentWithPhone(this.verificationId);

  final String verificationId;

  @override
  List<Object> get props => [verificationId];
}
