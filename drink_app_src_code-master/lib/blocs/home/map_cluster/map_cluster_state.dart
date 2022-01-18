part of 'map_cluster_cubit.dart';

abstract class MapsClusterState extends Equatable {}

class MapsClusterInitial extends MapsClusterState {
  @override
  List<Object> get props => [];
}

class MapsClusterLoad extends MapsClusterState {
  MapsClusterLoad(this.controller);

  final GoogleMapController controller;
  @override
  List<Object> get props => [controller];
}

class MapsClusterUpdate extends MapsClusterState {
  MapsClusterUpdate(this.mapMarkers);
  final Set<Marker> mapMarkers;
  @override
  List<Object> get props => [mapMarkers];
}
