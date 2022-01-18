import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:drink/models/credit_card.dart';
import 'package:drink/repositories/card_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'get_creditcards_state.dart';

class GetCreditCardsCubit extends Cubit<GetCreditCardsState> {
  GetCreditCardsCubit(
    this.cardsRepository,
  ) : super(GetCreditCardsInitial());
  final CardsRepository cardsRepository;
  Future<void> getAllCreditCards() async {
    try {
      emit(GetCreditCardsLoading());
      final List<CreditCard> allCreditCards =
          await cardsRepository.getAllCards();
      emit(
        GetCreditCardsLoaded(allCreditCards: allCreditCards),
      );
    } on PlatformException catch (e) {
      emit(GetCreditCardsFailed(message: e.message));
    } on SocketException catch (e) {
      emit(GetCreditCardsFailed(message: e.message));
    } catch (e) {
      emit(GetCreditCardsFailed(message: e.toString()));
    }
  }
}
