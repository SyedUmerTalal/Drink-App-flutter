part of 'table_reservation_cubit.dart';

class TableReservationState extends Equatable {
  const TableReservationState({
    this.isLoading,
    this.isLoaded,
    this.isFailure,
    this.isDateTimeValid,
    this.selectedDateTime,
    this.showTimePicker,
    this.isUnAuthenticated,
    this.isPreselected,
    this.amount,
    this.cardId,
    this.tableId,
    this.message,
  });
  factory TableReservationState.initial() {
    return TableReservationState(
      isLoading: false,
      isLoaded: false,
      isFailure: false,
      isDateTimeValid: true,
      showTimePicker: false,
      isPreselected: false,
    );
  }
  factory TableReservationState.showPicker() {
    return TableReservationState(
      isLoading: false,
      isLoaded: false,
      isFailure: false,
      isDateTimeValid: true,
      showTimePicker: true,
      isPreselected: false,
    );
  }

  final bool isLoading;
  final bool isLoaded;
  final bool isFailure;
  final bool isDateTimeValid;
  final DateTime selectedDateTime;
  final String message;
  final bool showTimePicker;
  final bool isUnAuthenticated;
  final bool isPreselected;
  final double amount;
  final int cardId;
  final int tableId;
  @override
  List<Object> get props => [
        isLoading,
        isLoaded,
        isFailure,
        isDateTimeValid,
        selectedDateTime,
        message,
        showTimePicker,
        isUnAuthenticated,
        amount,
        cardId,
        tableId,
        isPreselected,
      ];

  TableReservationState copyWith({
    bool isLoading,
    bool isLoaded,
    bool isFailure,
    bool isDateTimeValid,
    DateTime selectedDateTime,
    bool isUnAuthenticated,
    bool showTimePicker,
    bool isPreselected,
    double amount,
    int cardId,
    int tableId,
    String message,
  }) {
    return TableReservationState(
      isLoaded: isLoaded ?? this.isLoaded,
      isLoading: isLoading ?? this.isLoading,
      isFailure: isFailure ?? this.isFailure,
      isDateTimeValid: isDateTimeValid ?? this.isDateTimeValid,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      isUnAuthenticated: isUnAuthenticated ?? this.isUnAuthenticated,
      message: message ?? this.message,
      isPreselected: isPreselected ?? this.isPreselected,
      amount: amount ?? this.amount,
      tableId: tableId ?? this.tableId,
      cardId: cardId ?? this.cardId,
    );
  }
}
