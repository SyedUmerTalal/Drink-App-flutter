part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    @required this.isEmailValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    this.isUnAuthenticated,
    this.message,
  });
  factory ForgotPasswordState.empty() {
    return ForgotPasswordState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ForgotPasswordState.loading() {
    return ForgotPasswordState(
      isEmailValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory ForgotPasswordState.failure(String message) {
    return ForgotPasswordState(
        isEmailValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        message: message);
  }

  factory ForgotPasswordState.success() {
    return ForgotPasswordState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isUnAuthenticated;
  final String message;
  bool get isFormValid => isEmailValid;

  ForgotPasswordState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isConfirmPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  ForgotPasswordState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isConfirmPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isUnAuthenticated,
    String message,
  }) {
    return ForgotPasswordState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isUnAuthenticated: isUnAuthenticated ?? this.isUnAuthenticated,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return '''ForgotPasswordState {
      isEmailValid: $isEmailValid,

      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      message: $message,
    }''';
  }

  @override
  List<Object> get props => [
        isEmailValid,
        isSubmitting,
        isSuccess,
        isFailure,
        message,
      ];
}
