import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:drink/blocs/home/bottom_sheet/bottom_sheet_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:drink/blocs/home/cluster/cluster_cubit.dart';
import 'package:drink/blocs/home/google_maps/google_maps_bloc.dart';
import 'package:drink/blocs/home/search_dropdown/search_dropdown_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/cluster_property.dart';
import 'package:drink/models/map_marker.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/map_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

part 'map_cluster_state.dart';

class MapsClusterCubit extends Cubit<MapsClusterState> {
  MapsClusterCubit(
    this.searchDropdownBloc,
    this.clusterCubit,
  ) : super(MapsClusterInitial()) {
    _searchDropDownSubscription = searchDropdownBloc.listen((state) {
      if (state.selectedPlace != null) {
        _moveTo(state.selectedPlace.geometry.location.lat,
            state.selectedPlace.geometry.location.lng);
      }
    });
    _clusterCubitSubscription = clusterCubit.listen((state) {
      if (state.placeDetailsResponse.isNotEmpty) {
        coordinates = state.placeDetailsResponse;
        _initMarkers();
      }
    });
  }
  final Set<Marker> mapMarkers = {};

  final SearchDropdownBloc searchDropdownBloc;
  final ClusterCubit clusterCubit;
  GoogleMapController controller;
  GoogleMapsBloc googleMapsBloc;
  List<DPlaceDetails> coordinates;
  BottomSheetCubit bottomSheetCubit;

  BuildContext context;
  Fluster<MapMarker> _clusterManager;
  StreamSubscription _searchDropDownSubscription;
  StreamSubscription _clusterCubitSubscription;
  ClusterProperty clusterProperty = MapHelper.instance.clusterProperty;
  ThemeType _themeType;

  void initMapController(
    GoogleMapController controller,
    List<DPlaceDetails> coordinates,
    BottomSheetCubit bottomSheetCubit,
    GoogleMapsBloc googleMapsBloc,
    ThemeType themeType,
    SearchDropdownBloc searchDropdownBloc,
    BuildContext context,
  ) {
    this.controller = controller;
    this.coordinates = coordinates;
    this.googleMapsBloc = googleMapsBloc;
    this.bottomSheetCubit = bottomSheetCubit;
    this._themeType = themeType;
    this.context = context;

    emit(MapsClusterLoad(controller));

    _initMarkers();
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

  bool buttonEnabled = true;

  Future<void> markerTap(DPlaceDetails data) async {
    buttonEnabled = true;
  }

  Future _initMarkers() async {
    final BitmapDescriptor iconImage = BitmapDescriptor.fromBytes(
        await _getBytesFromAsset(
            _themeType == ThemeType.light
                ? AssetPaths.UNSELECTED_MARKER_LIGHT
                : AssetPaths.UNSELECTED_MARKER,
            80));
    // debugger();
    /// ARK
    double doubleParse(String value){
      if(value != null){
        if(value.isNotEmpty){
          if(value.contains('°')){

            return double.tryParse(value.substring(0,value.lastIndexOf('°')));
          }
          else{
            return double.tryParse(value);
          }
        }
        else{
          return 0.0;
        }
      }
      else{
        return 0.0;
      }
    }

    final List<MapMarker> markers = coordinates
        .map(
          (data) => MapMarker(
              id: data.name,
              icon: iconImage,
              // position: LatLng(double.parse(data.lat), double.parse(data.long)),
              position: LatLng(doubleParse(data.lat), doubleParse(data.long)),
              onTap: () {
                googleMapsBloc.add(UpdateMarkerColor(data));
                bottomSheetCubit.updateBottomInfoSheet(
                  placeDetails: data,
                  context: context,
                );
              }),
        )
        .toList();

    _clusterManager = await MapHelper.instance.initClusterManager(
      markers,
      clusterProperty.minClusterZoom,
      clusterProperty.maxClusterZoom,
    );
    updateMarkers();
  }

  Future<void> updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == clusterProperty.currentZoom) {
      return;
    }

    if (updatedZoom != null) {
      clusterProperty.currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.instance.getClusterMarkers(
      _clusterManager,
      clusterProperty.currentZoom,
      _themeType == ThemeType.light
          ? Colors.black
          : clusterProperty.clusterColor,
      clusterProperty.clusterTextColor,
      clusterProperty.clusterWidth,
    );

    emit(MapsClusterUpdate(Set.of(updatedMarkers)));
  }

  Future<void> _moveTo(double latitude, double longitude) async {
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 12,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _searchDropDownSubscription.cancel();
    _clusterCubitSubscription.cancel();
    return super.close();
  }
}
