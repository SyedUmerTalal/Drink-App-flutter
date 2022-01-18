part of 'change_password_bloc.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.isOldPasswordValid,
    this.isNewPasswordValid,
    this.isConfirmPasswordValid,
    this.isSubmitting,
    this.isSuccess,
    this.isFailure,
    this.isUnAuthenticated,
    this.message,
  });
  factory ChangePasswordState.empty() {
    return ChangePasswordState(
      isOldPasswordValid: true,
      isNewPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
    );
  }
  factory ChangePasswordState.success() {
    return ChangePasswordState(
      isOldPasswordValid: true,
      isNewPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: true,
    );
  }

  factory ChangePasswordState.submitting() {
    return ChangePasswordState(
      isOldPasswordValid: true,
      isNewPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: true,
      isFailure: false,
      isSuccess: false,
    );
  }
  factory ChangePasswordState.failure(String message) {
    return ChangePasswordState(
      isOldPasswordValid: true,
      isNewPasswordValid: true,
      isConfirmPasswordValid: true,
      isSubmitting: false,
      isFailure: true,
      isSuccess: false,
      message: message,
    );
  }
  final bool isOldPasswordValid;
  final bool isNewPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isUnAuthenticated;
  final String message;
  @override
  List<Object> get props => [
        isOldPasswordValid,
        isNewPasswordValid,
        isConfirmPasswordValid,
        isSubmitting,
        isSuccess,
        isFailure,
        isUnAuthenticated,
        message
      ];

  bool get isFormValid =>
      isOldPasswordValid && isNewPasswordValid && isConfirmPasswordValid;

  ChangePasswordState update({
    bool isOldPasswordValid,
    bool isNewPasswordValid,
    bool isConfirmPasswordValid,
  }) {
    return copyWith(
      isOldPasswordValid: isOldPasswordValid,
      isNewPasswordValid: isNewPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  ChangePasswordState copyWith({
    bool isOldPasswordValid,
    bool isNewPasswordValid,
    bool isConfirmPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isUnAuthenticated,
    String message,
  }) {
    return ChangePasswordState(
        isOldPasswordValid: isOldPasswordValid ?? this.isOldPasswordValid,
        isNewPasswordValid: isNewPasswordValid ?? this.isNewPasswordValid,
        isConfirmPasswordValid:
            isConfirmPasswordValid ?? this.isConfirmPasswordValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        isUnAuthenticated: isUnAuthenticated ?? this.isUnAuthenticated,
        message: message ?? this.message);
  }

  @override
  String toString() {
    return '''SignupState {
      isOldPasswordValid: $isOldPasswordValid,
      isNewPasswordValid: $isNewPasswordValid,
      isConfirmPasswordValid: $isConfirmPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      message: $message,
    }''';
  }
}
