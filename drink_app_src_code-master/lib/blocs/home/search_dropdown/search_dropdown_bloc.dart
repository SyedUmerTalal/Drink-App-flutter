import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:drink/models/pick_result.dart';
import 'package:drink/repositories/google_places_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_webservice/places.dart';

part 'search_dropdown_event.dart';
part 'search_dropdown_state.dart';

class SearchDropdownBloc
    extends Bloc<SearchDropdownEvent, SearchDropdownState> {
  SearchDropdownBloc({
    @required GooglePlacesRepository placesRepository,
  })  : assert(placesRepository != null),
        _placesRepository = placesRepository,
        super(SearchDropdownState.empty());
  final GooglePlacesRepository _placesRepository;

  @override
  Stream<Transition<SearchDropdownEvent, SearchDropdownState>> transformEvents(
    Stream<SearchDropdownEvent> events,
    TransitionFunction<SearchDropdownEvent, SearchDropdownState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return event is! SearchInputChanged;
    });
    final debounceStream = events.where((event) {
      return event is SearchInputChanged;
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<SearchDropdownState> mapEventToState(
    SearchDropdownEvent event,
  ) async* {
    if (event is SearchInputChanged) {
      yield* _mapSearchInputChangedToState(event.input, event.currentPosition);
    } else if (event is ClearOverlay) {
      yield SearchDropdownState.empty();
    } else if (event is ResetTextField) {
      yield SearchDropdownState.rset();
    } else if (event is PlaceSelected) {
      yield* _mapPlaceSelectedToState(event.selectedPrediction);
    }
  }

  Stream<SearchDropdownState> _mapSearchInputChangedToState(
      String input, Position currentPosition) async* {
    yield state.copyWith(overlayVisibility: false);
    if (input.isNotEmpty) {
      yield SearchDropdownState.loading();
      try {
        final PlacesAutocompleteResponse placeResponse =
            await _placesRepository.autoCompleteSearch(
          input,
          currentPosition,
        );
        yield SearchDropdownState.loaded(placeResponse);
      } catch (e) {
        yield SearchDropdownState.failure(e.toString());
      }
    } else {
      add(ClearOverlay());
    }
  }

  Stream<SearchDropdownState> _mapPlaceSelectedToState(
      Prediction prediction) async* {
    final PlacesDetailsResponse response =
        await _placesRepository.placeDetails(prediction);
    final PickResult selectedPlace =
        PickResult.fromPlaceDetailResult(response.result);
    yield SearchDropdownState.placeSelected(selectedPlace);
  }
}
