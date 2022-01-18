part of 'signin_bloc.dart';

@immutable
abstract class SigninEvent extends Equatable {
  const SigninEvent();
}

class EmailChanged extends SigninEvent {
  const EmailChanged({@required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends SigninEvent {
  const PasswordChanged({@required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class Submitted extends SigninEvent {
  const Submitted({@required this.email, @required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SigninWithGooglePressed extends SigninEvent {
  @override
  List<Object> get props => [];
}

class SigninWithFacebookPressed extends SigninEvent {
  @override
  List<Object> get props => [];
}

class SigninWithApplePressed extends SigninEvent {
  @override
  List<Object> get props => [];
}

class SigninWithCredentialsPressed extends SigninEvent {
  const SigninWithCredentialsPressed(
      {@required this.email, @required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class PhoneChanged extends SigninEvent {
  const PhoneChanged({@required this.phone});

  final String phone;

  @override
  List<Object> get props => [phone];
}

class SendVerificationCodePressed extends SigninEvent {
  const SendVerificationCodePressed({@required this.phone});

  final String phone;

  @override
  List<Object> get props => [phone];
}

class SigninWithPhonePressed extends SigninEvent {
  const SigninWithPhonePressed({
    @required this.smsCode,
  });

  //TODO
  final String smsCode;

  @override
  List<Object> get props => [
        smsCode,
      ];
}

class VerificationFailedWithPhone extends SigninEvent {
  const VerificationFailedWithPhone(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}

class CodeSentWithPhone extends SigninEvent {
  const CodeSentWithPhone(this.verificationId);

  final String verificationId;

  @override
  List<Object> get props => [verificationId];
}

class VerificationSubmit extends SigninEvent {
  final String email;
  final String password;

  VerificationSubmit({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}
