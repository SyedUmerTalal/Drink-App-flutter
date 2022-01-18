part of 'search_dropdown_bloc.dart';

abstract class SearchDropdownEvent extends Equatable {
  const SearchDropdownEvent();

  @override
  List<Object> get props => [];
}

class SearchInputChanged extends SearchDropdownEvent {
  const SearchInputChanged(this.input, this.currentPosition);

  final String input;
  final Position currentPosition;

  @override
  List<Object> get props => [input, currentPosition];
}

class ClearOverlay extends SearchDropdownEvent {}

class ShowClearIcon extends SearchDropdownEvent {}

class ResetTextField extends SearchDropdownEvent {}

class PlaceSelected extends SearchDropdownEvent {
  const PlaceSelected(this.selectedPrediction);

  final Prediction selectedPrediction;
  @override
  List<Object> get props => [selectedPrediction];
}
