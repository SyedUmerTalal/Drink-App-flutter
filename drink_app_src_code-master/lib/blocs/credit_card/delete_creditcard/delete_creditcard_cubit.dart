import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:drink/repositories/card_repository.dart';
import 'package:drink/models/credit_card.dart' as cc;
import 'package:flutter/services.dart';

part 'delete_creditcard_state.dart';

class DeleteCreditcardCubit extends Cubit<DeleteCreditcardState> {
  DeleteCreditcardCubit(this.cardsRepository)
      : super(DeleteCreditcardState.initial());
  final CardsRepository cardsRepository;
  Future<void> deleteCreditCard(cc.CreditCard creditCard) async {
    emit(DeleteCreditcardState.isLoading());
    try {
      await cardsRepository.deleteCard(creditCard);
      emit(state.copyWith(isLoading: false, isLoaded: true));
    } on PlatformException catch (e) {
      emit(DeleteCreditcardState.isFailure(message: e.message));
    } on SocketException catch (e) {
      emit(DeleteCreditcardState.isFailure(message: e.message));
    } on AuthException {
      emit(state.copyWith(isUnAuthenticated: true));
    } catch (e) {
      emit(DeleteCreditcardState.isFailure(message: e.toString()));
    }
  }
}
