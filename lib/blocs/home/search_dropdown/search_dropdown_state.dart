part of 'search_dropdown_bloc.dart';

class SearchDropdownState extends Equatable {
  const SearchDropdownState({
    this.isLoading,
    this.isLoaded,
    this.isFailure,
    this.clearIconVisibility,
    this.resetTextField,
    this.overlayVisibility,
    this.selectedPlace,
    this.places,
    this.message,
  });
  factory SearchDropdownState.empty() {
    return SearchDropdownState(
      isLoading: false,
      isLoaded: false,
      isFailure: false,
      resetTextField: false,
      clearIconVisibility: false,
    );
  }
  factory SearchDropdownState.rset() {
    return SearchDropdownState(
      isLoading: false,
      isLoaded: false,
      isFailure: false,
      resetTextField: true,
      clearIconVisibility: true,
    );
  }

  factory SearchDropdownState.loading() {
    return SearchDropdownState(
      isLoading: true,
      isLoaded: false,
      isFailure: false,
      overlayVisibility: true,
    );
  }
  factory SearchDropdownState.loaded(PlacesAutocompleteResponse placeResponse) {
    return SearchDropdownState(
      isLoading: false,
      isLoaded: true,
      isFailure: false,
      overlayVisibility: true,
      places: placeResponse,
    );
  }

  factory SearchDropdownState.failure(String message) {
    return SearchDropdownState(
      isLoading: false,
      isLoaded: true,
      isFailure: true,
      overlayVisibility: false,
      message: message,
    );
  }

  factory SearchDropdownState.placeSelected(PickResult selectedPlace) {
    return SearchDropdownState(
      isLoading: false,
      isLoaded: true,
      isFailure: false,
      overlayVisibility: false,
      places: null,
      resetTextField: false,
      selectedPlace: selectedPlace,
      clearIconVisibility: false,
    );
  }

  SearchDropdownState copyWith({
    bool isLoading,
    bool isLoaded,
    bool isFailure,
    bool clearIconVisibility,
    bool resetTextField,
    bool overlayVisibility,
    PlacesAutocompleteResponse places,
    PickResult selectedPlace,
    String message,
  }) {
    return SearchDropdownState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      isFailure: isFailure ?? this.isFailure,
      overlayVisibility: overlayVisibility ?? this.overlayVisibility,
      places: places ?? this.places,
      resetTextField: resetTextField ?? this.resetTextField,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      clearIconVisibility: clearIconVisibility ?? this.clearIconVisibility,
    );
  }

  final bool isLoading;
  final bool isLoaded;
  final bool isFailure;
  final bool clearIconVisibility;
  final bool resetTextField;
  final bool overlayVisibility;
  final PlacesAutocompleteResponse places;
  final PickResult selectedPlace;
  final String message;

  @override
  String toString() {
    return '''SearchDropdownState {
      isLoading: $isLoading,
      isLoaded: $isLoaded,
      isFailure: $isFailure,
      clearIconVisibility: $clearIconVisibility,
      overlayVisibility : $overlayVisibility,
      pickedResult: $selectedPlace,
      places: $places,
      message: $message,
    }''';
  }

  @override
  List<Object> get props => [
        isLoading,
        isLoaded,
        isFailure,
        clearIconVisibility,
        places,
        message,
        selectedPlace
      ];
}
