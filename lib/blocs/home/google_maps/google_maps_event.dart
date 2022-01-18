part of 'google_maps_bloc.dart';

abstract class GoogleMapsEvent extends Equatable {
  const GoogleMapsEvent();

  @override
  List<Object> get props => [];
}

class UpdateLocation extends GoogleMapsEvent {
  const UpdateLocation(this.position);
  final Position position;

  @override
  List<Object> get props => [position];
}

class UpdateMarkers extends GoogleMapsEvent {
  const UpdateMarkers(this.markers);

  final Set<Marker> markers;
  @override
  List<Object> get props => [markers];
}

class UpdateMarkerColor extends GoogleMapsEvent {
  const UpdateMarkerColor(this.placeDetails);
  final DPlaceDetails placeDetails;
}

class GetMarkerColorBack extends GoogleMapsEvent {
  const GetMarkerColorBack();
}

class DisableCameraMoveAction extends GoogleMapsEvent {}

class EnableCameraMoveAction extends GoogleMapsEvent {}

class RetainSelectedMarker extends GoogleMapsEvent {}
