part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends ForgotPasswordEvent {
  const EmailChanged({@required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class Submitted extends ForgotPasswordEvent {
  const Submitted({@required this.email});

  final String email;
  @override
  List<Object> get props => [email];
}
