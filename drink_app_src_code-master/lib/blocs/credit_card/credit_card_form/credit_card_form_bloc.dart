import 'dart:async';
import 'dart:io';
import 'package:drink/models/credit_card.dart' as cc;

import 'package:bloc/bloc.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_validator/validation_results.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:drink/repositories/card_repository.dart';
import 'package:equatable/equatable.dart';
part 'credit_card_form_event.dart';
part 'credit_card_form_state.dart';

class CreditCardFormBloc
    extends Bloc<CreditCardFormEvent, CreditCardFormState> {
  CreditCardFormBloc(this.cardsRepository)
      : super(CreditCardFormState.initial()) {
    StripePayment.setOptions(StripeOptions(
        publishableKey: StripeConfig['publishableKey'],
        merchantId: StripeConfig['merchantId'],
        androidPayMode: StripeConfig['androidPayMode']));
  }
  final CreditCardValidator _ccValidator = CreditCardValidator();
  int tempMonth;
  final CardsRepository cardsRepository;

  CCNumValidationResults cardType;

  @override
  Stream<CreditCardFormState> mapEventToState(
    CreditCardFormEvent event,
  ) async* {
    if (event is CardNumberChanged) {
      yield* _mapCreditCardNumberChangedToState(event.cardNumber);
    } else if (event is MonthChanged) {
      yield* _mapMonthChangedToState(event.selectedMonth);
    } else if (event is YearChanged) {
      yield* _mapYearChangedToState(event.year);
    } else if (event is CVVChanged) {
      yield* _mapCCVChangedToState(event.cvv);
    } else if (event is CreditCardSubmitted) {
      yield* _mapCreditCardSubmittedToState(event);
    } else if (event is CreditCardDelete) {
      yield* _mapCreditCardDeleted(event.creditCard);
    }
  }

  Stream<CreditCardFormState> _mapCreditCardDeleted(
      cc.CreditCard creditCard) async* {
    yield state.copyWith(isLoading: true);
    await cardsRepository.deleteCard(creditCard);
    yield state.copyWith(isLoading: false, isLoaded: true);
  }

  Stream<CreditCardFormState> _mapCreditCardNumberChangedToState(
      String cardNumber) async* {
    cardType = _ccValidator.validateCCNum(cardNumber);
    print(cardType.isValid.toString());
    yield state.copyWith(
      isCardNumberValid: cardType.isValid,
      message: cardType.isValid ? null : AppStrings.PROVIDE_VALID_CARDNUMBER,
    );
  }

  Stream<CreditCardFormState> _mapMonthChangedToState(int month) async* {
    tempMonth = month;

    final bool _isValid = month <= 12 && month > 0;
    yield state.copyWith(
        isMonthValid: _isValid,
        message: _isValid ? null : AppStrings.PROVIDE_VALID_MONTH);
  }

  Stream<CreditCardFormState> _mapYearChangedToState(String year) async* {
    yield state.copyWith(
        isYearValid:
            _ccValidator.validateExpDate('${tempMonth ?? 0}/$year').isValid,
        message: tempMonth == null
            ? AppStrings.MONTH_NOT_VALID
            : _ccValidator.validateExpDate('${tempMonth ?? 0}/$year').isValid
                ? null
                : AppStrings.YEAR_NOT_VALID);
  }

  Stream<CreditCardFormState> _mapCCVChangedToState(String ccv) async* {
    yield state.copyWith(
      isCCVValid: cardType != null
          ? _ccValidator.validateCVV(ccv.toString(), cardType.ccType).isValid
          : false,
      message: cardType == null
          ? AppStrings.PROVIDE_CARD_NUMBER
          : _ccValidator.validateCVV(ccv.toString(), cardType.ccType).isValid
              ? null
              : AppStrings.PROVIDE_VALID_CVV,
    );
  }

  Stream<CreditCardFormState> _mapCreditCardSubmittedToState(
      CreditCardSubmitted event) async* {
    try {
      yield state.copyWith(isLoading: true);
      final String _cardNumber = event.cardNumber.replaceAll(' ', '');
      final CreditCard card = CreditCard(
        number: _cardNumber,
        expMonth: event.selectedMonth,
        expYear: int.parse(event.year),
        cvc: event.ccv,
      );

      final Token token = await StripePayment.createTokenWithCard(
        card,
      );
      await cardsRepository.saveCard(token.tokenId);

      yield state.copyWith(isLoading: false, isLoaded: true);
    } on PlatformException catch (e) {
      yield CreditCardFormState.isFailure(e.message);
    } on SocketException catch (e) {
      yield CreditCardFormState.isFailure(e.message);
    } on AuthException {
      yield state.copyWith();
    } catch (e) {
      yield CreditCardFormState.isFailure(e.message);
    }
  }
}
