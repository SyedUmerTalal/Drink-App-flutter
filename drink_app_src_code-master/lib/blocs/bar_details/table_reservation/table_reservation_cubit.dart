import 'package:bloc/bloc.dart';
import 'package:drink/repositories/table_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:drink/utility/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:drink/utility/strings.dart';

part 'table_reservation_state.dart';

class TableReservationCubit extends Cubit<TableReservationState> {
  TableReservationCubit(this._tableRepository)
      : super(TableReservationState.initial());
  final TableRepository _tableRepository;

  void getPreselectedDate(int tableId) {
    try {
      String date = SharedPref.instance.sharedPreferences
          .getString(AppStrings.RESERVED_DATE + tableId.toString());
      if (date != null) {
        DateTime selectedDate = DateTime.parse(date);
        emit(
          state.copyWith(
            selectedDateTime: selectedDate,
            isPreselected: true,
          ),
        );
      }
    } on PlatformException catch (e) {
      emit(state.copyWith(
          isLoaded: false,
          isLoading: false,
          isFailure: true,
          message: e.message));
    } on AuthException {
      emit(state.copyWith(
        isLoaded: false,
        isLoading: false,
        isFailure: true,
        isUnAuthenticated: true,
        message: AppStrings.UNAUTHENTICATED,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          isLoaded: false,
          isLoading: false,
          isFailure: true,
          message: e.toString(),
        ),
      );
    }
  }

  void updateCardId(int cardId) {
    emit(state.copyWith(cardId: cardId));
  }

  void showPicker() {
    emit(TableReservationState.showPicker());
  }

  void updateDateTimeAndTableID(int tableID, DateTime selectedDateTime) {
    emit(state.copyWith(selectedDateTime: selectedDateTime, tableId: tableID));
  }

  void noDateSelected() {
    emit(
      state.copyWith(showTimePicker: false),
    );
  }

  Future<void> selectDate(int cardId) async {
    if (cardId != null) {
      emit(state.copyWith(cardId: cardId));

      try {
        emit(state.copyWith(
          isLoading: true,
          isFailure: false,
          message: null,
        ));
        final String message = await _tableRepository.reserveTable(
            state.tableId, state.selectedDateTime, cardId);
        print(message);
        //   if (message.isNotEmpty) {
        // SharedPref.instance.sharedPreferences.setString(
        //     AppStrings.RESERVED_DATE + tableId.toString(),
        //     dateTime.toString());
        //
        emit(
          state.copyWith(
            isLoaded: true,
            message: message,
            isLoading: false,
            isPreselected: true,
            // selectedDateTime: dateTime,
            // amount: amount,
          ),
        );
      } on PlatformException catch (e) {
        emit(state.copyWith(
            isLoaded: false,
            isLoading: false,
            isFailure: true,
            message: e.message));
      } on AuthException {
        emit(state.copyWith(
          isLoaded: false,
          isLoading: false,
          isFailure: true,
          isUnAuthenticated: true,
          message: AppStrings.UNAUTHENTICATED,
        ));
      } catch (e) {
        emit(
          state.copyWith(
            isLoaded: false,
            isLoading: false,
            isFailure: true,
            message: e.toString(),
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          isLoaded: false,
          isLoading: false,
          isFailure: true,
          message: AppStrings.DATE_ERROR,
        ),
      );
    }
  }
}
