part of 'signin_bloc.dart';

@immutable
class SigninState {
  const SigninState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isPhoneValid,
    @required this.isSmsCodeValid,
    this.message,
    this.verificationCode,
  });

  factory SigninState.empty() {
    return SigninState(
      isPhoneValid: true,
      isSmsCodeValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SigninState.loading() {
    return SigninState(
      isPhoneValid: true,
      isSmsCodeValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SigninState.failure(message) {
    return SigninState(
        isEmailValid: true,
        isPasswordValid: true,
        isPhoneValid: true,
        isSmsCodeValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        message: message);
  }

  factory SigninState.success({String verificationCode}) {
    return SigninState(
      isPhoneValid: true,
      isSmsCodeValid: true,
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      verificationCode: verificationCode,
    );
  }
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String message;
  final bool isPhoneValid;
  final bool isSmsCodeValid;
  final String verificationCode;

  bool get isFormValid => isEmailValid && isPasswordValid;
  bool get isPhoneAuthValid => isPhoneValid;

  SigninState update(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isPhoneValid,
      bool isSmsCodeValid}) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isPhoneValid: isPhoneValid,
      isSmsCodeValid: isSmsCodeValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  SigninState copyWith({
    bool isPhoneValid,
    bool isSmsCodeValid,
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return SigninState(
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isSmsCodeValid: isSmsCodeValid ?? this.isSmsCodeValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      message: message,
    );
  }

  @override
  String toString() {
    return '''SigninState {
      isPhoneValid: $isPhoneValid,
      isSmsCodeValid: $isSmsCodeValid,
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      message: $message
    }''';
  }
}
