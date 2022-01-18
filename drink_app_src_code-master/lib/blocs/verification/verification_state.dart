part of 'verification_bloc.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object> get props => [];
}

class VerificationInitial extends VerificationState {}

class VerificationSuccessful extends VerificationState {
  const VerificationSuccessful();
}

class VerificationSubmitting extends VerificationState {}

class VerificationFailure extends VerificationState {
  const VerificationFailure(this.message);

  final String message;
}
