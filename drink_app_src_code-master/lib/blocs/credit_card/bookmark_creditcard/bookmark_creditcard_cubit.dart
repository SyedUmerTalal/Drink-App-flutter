import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:drink/models/credit_card.dart' as cc;

import 'package:drink/utility/constants.dart';
import 'package:drink/utility/strings.dart';

part 'bookmark_creditcard_state.dart';

class BookmarkCreditcardCubit extends Cubit<BookmarkCreditcardState> {
  BookmarkCreditcardCubit() : super(BookmarkCreditcardState.initial());

  void getBookMarkedCreditCard() {
    final String stringData =
        SharedPref.instance.sharedPreferences.getString(AppStrings.BKCC);
    if (stringData?.isNotEmpty ?? false) {
      final mappedData = jsonDecode(stringData);
      if (mappedData != null) {
        emit(state.copyWith(
          creditCard: cc.CreditCard.fromJson(mappedData),
          isLoaded: true,
          isLoading: false,
          isFailure: false,
          isBookMarked: true,
        ));
      }
    } else {
      emit(state.copyWith(
        isLoaded: true,
        isLoading: false,
        isFailure: false,
        isBookMarked: false,
        creditCard: null,
      ));
    }
  }

  Future<void> bookMarkCreditCard(cc.CreditCard orignalProvider) async {
    emit(BookmarkCreditcardState.isLoading());
    try {
      SharedPref.instance.sharedPreferences
          .setString(AppStrings.BKCC, jsonEncode(orignalProvider));
      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: true,
          isBookMarked: true,
          creditCard: orignalProvider,
        ),
      );
    } catch (e) {
      emit(BookmarkCreditcardState.isFailure(message: e.message));
    }
  }

  Future<void> removebookMarkCreditCard(cc.CreditCard orignalProvider) async {
    emit(BookmarkCreditcardState.isLoading());
    try {
      SharedPref.instance.sharedPreferences.remove(AppStrings.BKCC);
      emit(
        state.copyWith(
          isLoading: false,
          isLoaded: true,
          isBookMarked: false,
          creditCard: null,
        ),
      );
    } catch (e) {
      emit(BookmarkCreditcardState.isFailure(message: e.message));
    }
  }
}
