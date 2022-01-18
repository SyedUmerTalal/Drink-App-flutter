part of 'credit_card_form_bloc.dart';

abstract class CreditCardFormEvent extends Equatable {
  const CreditCardFormEvent();

  @override
  List<Object> get props => [];
}

class CardNumberChanged extends CreditCardFormEvent {
  const CardNumberChanged({this.cardNumber});
  final String cardNumber;
  @override
  List<Object> get props => [cardNumber];
}

class MonthChanged extends CreditCardFormEvent {
  const MonthChanged({this.selectedMonth});
  final int selectedMonth;
  @override
  List<Object> get props => [selectedMonth];
}

class YearChanged extends CreditCardFormEvent {
  const YearChanged({this.year});
  final String year;
  @override
  List<Object> get props => [year];
}

class CVVChanged extends CreditCardFormEvent {
  const CVVChanged({this.cvv});
  final String cvv;
  @override
  List<Object> get props => [cvv];
}

class CreditCardSubmitted extends CreditCardFormEvent {
  const CreditCardSubmitted(
      {this.cardNumber, this.selectedMonth, this.year, this.ccv});
  final String cardNumber;
  final int selectedMonth;
  final String year;
  final String ccv;

  @override
  List<Object> get props => [cardNumber, selectedMonth, year, ccv];
}

class CreditCardDelete extends CreditCardFormEvent {
  const CreditCardDelete(this.creditCard);
  final cc.CreditCard creditCard;
  @override
  List<Object> get props => [creditCard];
}
