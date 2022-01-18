part of 'get_creditcards_cubit.dart';

abstract class GetCreditCardsState extends Equatable {
  const GetCreditCardsState();

  @override
  List<Object> get props => [];
}

class GetCreditCardsInitial extends GetCreditCardsState {}

class GetCreditCardsLoading extends GetCreditCardsState {}

class GetCreditCardsLoaded extends GetCreditCardsState {
  const GetCreditCardsLoaded({this.allCreditCards});

  final List<CreditCard> allCreditCards;
  @override
  List<Object> get props => [allCreditCards];
}

class GetCreditCardsFailed extends GetCreditCardsState {
  const GetCreditCardsFailed({this.message});

  final String message;
  @override
  List<Object> get props => [message];
}

class UnAuthenticated extends GetCreditCardsState {}
