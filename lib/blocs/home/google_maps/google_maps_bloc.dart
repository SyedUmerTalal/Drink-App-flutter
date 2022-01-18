import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:bloc/bloc.dart';
import 'package:drink/blocs/home/map_cluster/map_cluster_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/map_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'google_maps_event.dart';
part 'google_maps_state.dart';

class GoogleMapsBloc extends Bloc<GoogleMapsEvent, GoogleMapsState> {
  GoogleMapsBloc({
    @required Position currentLocation,
    @required MapsClusterCubit mapsClusterCubit,
    @required ThemeType themeType,
  })  : _mapsClusterCubit = mapsClusterCubit,
        _themeType = themeType,
        super(GoogleMapsState.mapsInitial(currentLocation)) {
    markerSubscription = _mapsClusterCubit.listen((state) {
      if (state is MapsClusterUpdate) {
        add(UpdateMarkers(state.mapMarkers));
      }
    });
  }
  final ThemeType _themeType;

  final MapsClusterCubit _mapsClusterCubit;

  StreamSubscription markerSubscription;

  BuildContext context;
  GoogleMapController controller;

  @override
  Stream<GoogleMapsState> mapEventToState(
    GoogleMapsEvent event,
  ) async* {
    if (event is UpdateLocation) {
      yield state.update(
        currentPosition: event.position,
        clearOnMove: state.clearOnMove,
        selectedPlace: state.selectedPlace,
      );
    } else if (event is UpdateMarkers) {
      yield state.update(
        markers: event.markers,
        clearOnMove: false,
        selectedPlace: state.selectedPlace,
      );
      if (state.selectedPlace != null) {
        add(RetainSelectedMarker());
      }
    } else if (event is UpdateMarkerColor) {
      if (state.selectedPlace != null) {
        if (state.selectedPlace != event.placeDetails) {
          add(GetMarkerColorBack());
          add(UpdateMarkerColor(event.placeDetails));
        } else if (event.placeDetails.name == state.selectedPlace.name) {
          add(GetMarkerColorBack());
        }
      } else {
        yield* _mapUpdateMarkerColorToState(event.placeDetails);
      }
    } else if (event is GetMarkerColorBack) {
      if (state.selectedPlace != null) {
        yield* _mapGetMarkerBackToState(state.selectedPlace);
      }
    } else if (event is DisableCameraMoveAction) {
      yield state.copyWith(
          clearOnMove: false, selectedPlace: state.selectedPlace);
    } else if (event is EnableCameraMoveAction) {
      yield state.copyWith(
          clearOnMove: true, selectedPlace: state.selectedPlace);
    } else if (event is RetainSelectedMarker) {
      yield* _mapRetainSelectedMarkerToState();
    }
  }

  Stream<GoogleMapsState> _mapUpdateMarkerColorToState(
      DPlaceDetails dPlaceDetails) async* {
    yield state.copyWith(
      clearOnMove: false,
      selectedPlace: null,
    );

    final BitmapDescriptor iconImage = BitmapDescriptor.fromBytes(
      await _getBytesFromAsset(AssetPaths.LOCATION_MARKER, 100),
    );

    Marker updatedMarker(Marker previousMarker) =>
        previousMarker.copyWith(iconParam: iconImage);

    yield state.update(
      clearOnMove: false,
      markers: state.markers
          .map(
            (marker) => marker.markerId.value == dPlaceDetails.name
                ? updatedMarker(marker)
                : marker,
          )
          .toSet(),
      selectedPlace: dPlaceDetails,
    );
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui
        .instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Stream<GoogleMapsState> _mapGetMarkerBackToState(
      DPlaceDetails selectedPlace) async* {
    yield state.copyWith(
      clearOnMove: true,
      selectedPlace: state.selectedPlace,
    );

    final BitmapDescriptor iconImage = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset(
            _themeType == ThemeType.light
                ? AssetPaths.UNSELECTED_MARKER_LIGHT
                : AssetPaths.UNSELECTED_MARKER,
            80));
    Marker updatedMarker(Marker previousMarker) =>
        previousMarker.copyWith(iconParam: iconImage);

    yield state.update(
      clearOnMove: true,
      markers: state.markers
          .map(
            (marker) => marker.markerId.value == state.selectedPlace.name
                ? updatedMarker(marker)
                : marker,
          )
          .toSet(),
      selectedPlace: null,
    );
  }

  Stream<GoogleMapsState> _mapRetainSelectedMarkerToState() async* {
    yield state.copyWith(
      clearOnMove: false,
      selectedPlace: state.selectedPlace,
    );

    final BitmapDescriptor iconImage = BitmapDescriptor.fromBytes(
      await _getBytesFromAsset(AssetPaths.LOCATION_MARKER, 100),
    );

    Marker updatedMarker(Marker previousMarker) =>
        previousMarker.copyWith(iconParam: iconImage);

    yield state.update(
      clearOnMove: false,
      markers: state.markers
          .map(
            (marker) => marker.markerId.value == state.selectedPlace.name
                ? updatedMarker(marker)
                : marker,
          )
          .toSet(),
      selectedPlace: state.selectedPlace,
    );
    add(EnableCameraMoveAction());
  }

  @override
  Future<void> close() {
    markerSubscription.cancel();
    return super.close();
  }
}
