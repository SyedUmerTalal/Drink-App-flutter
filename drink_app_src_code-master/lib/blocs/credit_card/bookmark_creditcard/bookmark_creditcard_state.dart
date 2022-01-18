part of 'bookmark_creditcard_cubit.dart';

class BookmarkCreditcardState extends Equatable {
  const BookmarkCreditcardState({
    this.isLoading,
    this.isLoaded,
    this.isFailure,
    this.creditCard,
    this.message,
  });
  factory BookmarkCreditcardState.initial() {
    return BookmarkCreditcardState(
      isLoaded: false,
      isLoading: false,
      isFailure: false,
      message: '',
    );
  }

  factory BookmarkCreditcardState.isLoading() {
    return BookmarkCreditcardState(
      isLoaded: false,
      isLoading: true,
      isFailure: false,
    );
  }

  factory BookmarkCreditcardState.isLoaded(String message) {
    return BookmarkCreditcardState(
      isLoaded: true,
      isLoading: false,
      isFailure: false,
      message: message,
    );
  }
  factory BookmarkCreditcardState.isFailure({String message}) {
    return BookmarkCreditcardState(
      isLoaded: false,
      isLoading: false,
      isFailure: true,
      message: message,
    );
  }
  final bool isLoading;
  final bool isLoaded;
  final bool isFailure;
  final cc.CreditCard creditCard;
  final String message;

  BookmarkCreditcardState copyWith({
    bool isLoading,
    bool isLoaded,
    bool isFailure,
    bool isBookMarked,
    cc.CreditCard creditCard,
    String message,
  }) {
    return BookmarkCreditcardState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isFailure: isFailure ?? this.isFailure,
      creditCard: creditCard ?? this.creditCard,
      message: message,
    );
  }

  @override
  List<Object> get props =>
      [isLoaded, isLoading, isFailure, message, creditCard];
}
