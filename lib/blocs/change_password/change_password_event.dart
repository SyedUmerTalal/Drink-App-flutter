part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class OldPasswordChanged extends ChangePasswordEvent {
  const OldPasswordChanged({this.oldPassword});
  final String oldPassword;
}

class NewPasswordChanged extends ChangePasswordEvent {
  const NewPasswordChanged({@required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class ConfirmNewPasswordChanged extends ChangePasswordEvent {
  const ConfirmNewPasswordChanged({this.password, this.confirmPassword});

  final String confirmPassword;
  final String password;

  @override
  List<Object> get props => [confirmPassword];
}

class Submitted extends ChangePasswordEvent {
  const Submitted({
    this.oldPasswrod,
    this.newPassword,
    this.token,
    this.email,
  });

  final String oldPasswrod;
  final String newPassword;
  final String token;
  final String email;

  @override
  List<Object> get props => [
        oldPasswrod,
        newPassword,
        token,
        email,
      ];
}
