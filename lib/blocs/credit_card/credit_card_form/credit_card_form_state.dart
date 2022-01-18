part of 'credit_card_form_bloc.dart';

class CreditCardFormState extends Equatable {
  const CreditCardFormState({
    this.isLoading,
    this.isLoaded,
    this.isFailure,
    this.isCardNumberValid,
    this.isMonthValid,
    this.isYearValid,
    this.isCCVValid,
    this.isUnAuthenticated,
    this.message,
  });
  factory CreditCardFormState.initial() {
    return CreditCardFormState(
      isLoaded: false,
      isLoading: false,
      isFailure: false,
      isCardNumberValid: true,
      isMonthValid: true,
      isYearValid: true,
      isCCVValid: true,
      message: '',
    );
  }

  factory CreditCardFormState.isLoading() {
    return CreditCardFormState(
      isLoaded: false,
      isLoading: true,
      isFailure: false,
      isCardNumberValid: true,
      isMonthValid: true,
      isYearValid: true,
      isCCVValid: true,
    );
  }

  factory CreditCardFormState.isLoaded(String message) {
    return CreditCardFormState(
      isLoaded: true,
      isLoading: false,
      isFailure: false,
      isCardNumberValid: true,
      isMonthValid: true,
      isYearValid: true,
      isCCVValid: true,
      message: message,
    );
  }
  factory CreditCardFormState.isFailure(String message) {
    return CreditCardFormState(
      isLoaded: false,
      isLoading: false,
      isFailure: true,
      isCardNumberValid: true,
      isMonthValid: true,
      isYearValid: true,
      isCCVValid: true,
      message: message,
    );
  }
  final bool isLoading;
  final bool isLoaded;
  final bool isFailure;
  final bool isCardNumberValid;
  final bool isMonthValid;
  final bool isYearValid;
  final bool isCCVValid;
  final bool isUnAuthenticated;
  final String message;

  bool get isFormValid =>
      !isLoading &&
      isCardNumberValid &&
      isMonthValid &&
      isYearValid &&
      isCCVValid;

  CreditCardFormState copyWith({
    bool isLoading,
    bool isLoaded,
    bool isFailure,
    bool isCardNumberValid,
    bool isMonthValid,
    bool isYearValid,
    bool isCCVValid,
    bool isUnAuthenticated,
    String message,
  }) {
    return CreditCardFormState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isFailure: isFailure ?? this.isFailure,
      isCardNumberValid: isCardNumberValid ?? this.isCardNumberValid,
      isMonthValid: isMonthValid ?? this.isMonthValid,
      isYearValid: isYearValid ?? this.isYearValid,
      isCCVValid: isCCVValid ?? this.isCCVValid,
      isUnAuthenticated: isUnAuthenticated ?? this.isUnAuthenticated,
      message: message,
    );
  }

  @override
  List<Object> get props => [
        isLoaded,
        isLoading,
        isFailure,
        isCardNumberValid,
        isMonthValid,
        isYearValid,
        isCCVValid,
        message
      ];
}
