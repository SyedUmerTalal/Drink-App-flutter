part of 'delete_creditcard_cubit.dart';

class DeleteCreditcardState extends Equatable {
  const DeleteCreditcardState({
    this.isLoading,
    this.isLoaded,
    this.isFailure,
    this.isUnAuthenticated,
    this.message,
  });
  factory DeleteCreditcardState.initial() {
    return DeleteCreditcardState(
      isLoaded: false,
      isLoading: false,
      isFailure: false,
      message: '',
    );
  }

  factory DeleteCreditcardState.isLoading() {
    return DeleteCreditcardState(
      isLoaded: false,
      isLoading: true,
      isFailure: false,
    );
  }

  factory DeleteCreditcardState.isLoaded(String message) {
    return DeleteCreditcardState(
      isLoaded: true,
      isLoading: false,
      isFailure: false,
      message: message,
    );
  }
  factory DeleteCreditcardState.isFailure({String message}) {
    return DeleteCreditcardState(
      isLoaded: false,
      isLoading: false,
      isFailure: true,
      message: message,
    );
  }
  final bool isLoading;
  final bool isLoaded;
  final bool isFailure;
  final bool isUnAuthenticated;
  final String message;

  DeleteCreditcardState copyWith({
    bool isLoading,
    bool isLoaded,
    bool isFailure,
    bool isUnAuthenticated,
    String message,
  }) {
    return DeleteCreditcardState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isFailure: isFailure ?? this.isFailure,
      isUnAuthenticated: isUnAuthenticated ?? this.isUnAuthenticated,
      message: message,
    );
  }

  @override
  List<Object> get props =>
      [isLoaded, isLoading, isFailure, isUnAuthenticated, message];
}
