part of 'google_maps_bloc.dart';

class GoogleMapsState extends Equatable {
  const GoogleMapsState({
    this.markers,
    this.currentPosition,
    this.selectedPlace,
    this.clearOnMove,
  });
  factory GoogleMapsState.mapsInitial(
    Position currentPosition,
  ) {
    return GoogleMapsState(
      currentPosition: currentPosition,
      markers: const {},
      clearOnMove: true,
    );
  }
  GoogleMapsState update({
    Set<Marker> markers,
    DPlaceDetails selectedPlace,
    Position currentPosition,
    bool clearOnMove,
  }) {
    return copyWith(
      markers: markers,
      selectedPlace: selectedPlace,
      currentPosition: currentPosition,
      clearOnMove: clearOnMove,
    );
  }

  GoogleMapsState copyWith({
    Set<Marker> markers,
    DPlaceDetails selectedPlace,
    Position currentPosition,
    bool clearOnMove,
  }) {
    return GoogleMapsState(
      markers: markers ?? this.markers,
      currentPosition: currentPosition ?? this.currentPosition,
      selectedPlace: selectedPlace,
      clearOnMove: clearOnMove ?? this.clearOnMove,
    );
  }

  final Set<Marker> markers;
  final Position currentPosition;
  final DPlaceDetails selectedPlace;
  final bool clearOnMove;
  @override
  List<Object> get props => [
        markers,
        currentPosition,
        selectedPlace,
        clearOnMove,
      ];
  @override
  String toString() {
    return '''GoogleMapsState {
      markers: ${markers.length.toString()},
      currentPosition: $currentPosition,
      selectedPlace :$selectedPlace,
      clearOnMove: $clearOnMove,
    }''';
  }
}
