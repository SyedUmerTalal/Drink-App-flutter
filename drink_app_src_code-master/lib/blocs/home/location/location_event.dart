part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class LocationStarted extends LocationEvent {}

class LocationChanged extends LocationEvent {
  const LocationChanged({@required this.position});
  final Position position;
}
