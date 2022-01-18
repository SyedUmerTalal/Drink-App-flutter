import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:drink/blocs/home/location/location_bloc.dart';
import 'package:drink/blocs/home/update_circle/update_circle_cubit.dart';
import 'package:drink/models/pick_result.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/repositories/map_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:drink/utility/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:developer';

part 'cluster_state.dart';


class ClusterCubit extends Cubit<ClusterState> {
  ClusterCubit({
    @required UpdateCircleCubit updateRadiusCubit,
    @required MapRepository mapRepository,
    @required LocationBloc locationBloc,
  })  : _mapRepository = mapRepository,
        _radiusCubit = updateRadiusCubit,
        super(ClusterState.initial()) {
    radiusSubscription = _radiusCubit.listen((UpdateCircleState circleState) {
      fetchWithRadius(
          Position(
            latitude: circleState.center.latitude,
            longitude: circleState.center.longitude,
          ),
          (circleState.radius * 1.60934));
    });
  }

  StreamSubscription radiusSubscription;
  double radius = 1.0;
  final UpdateCircleCubit _radiusCubit;
  final MapRepository _mapRepository;

  Future<void> fetchWithRadius(
      Position newCurrentPosition, double newRadius) async {
    try {
      emit(
        state.copyWith(requested: true),
      );
      final responseItems = await _mapRepository.getSpecificPoints(
        newCurrentPosition.latitude,
        newCurrentPosition.longitude,
        newRadius,
      );
      if (responseItems != null) {
        emit(
          state.copyWith(
            placeDetailsResponse: responseItems,
          ),
        );
      } else
        emit(state.copyWith(
          message: 'Data Not Found',
          placeDetailsResponse: [],
        ));
    } on PlatformException catch (e) {
      emit(state.copyWith(
          message: e.message, placeDetailsResponse: [samplePlaceDetails]));
    } catch (e) {
      emit(state.copyWith(
          message: e.message, placeDetailsResponse: [samplePlaceDetails]));
    }
  }

  Future<void> fetchAllPoints(Position currentPosition) async {
    try {
      emit(
        state.copyWith(requested: true),
      );
      if (currentPosition == null) {
        throw Exception(['Current Position Is Null']);
      }
      final responseItems = await _mapRepository.getSpecificPoints(
        currentPosition.latitude,
        currentPosition.longitude,
        radius,
      );
      print(responseItems.toString() + ' Testing');
      if (responseItems != null) {
        emit(
          state.copyWith(
            placeDetailsResponse: responseItems,
          ),
        );
      } else
        emit(state.copyWith(
          message: 'Data Not Found',
          placeDetailsResponse: [],
        ));
    } on AuthException {
      emit(state.copyWith());
    } on PlatformException catch (e) {
      emit(state.copyWith(
          message: e.message, placeDetailsResponse: [samplePlaceDetails]));
    } catch (e) {
      emit(state.copyWith(
          message: e.message, placeDetailsResponse: [samplePlaceDetails]));
    }
  }

  Future<void> getSpecificCoordinates(
      PickResult selectedPlace, Position currentPosition) async {
    try {
      final response = await _mapRepository.getSpecificPoints(
        selectedPlace.geometry.location.lat,
        selectedPlace.geometry.location.lng,
        radius,
      );
      if (response != null) {
        emit(state.copyWith(
          placeDetailsResponse: response,
        ));
      } else {
        emit(
          state.copyWith(
            message: 'Data Not Found',
            placeDetailsResponse: [],
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          message: 'Data Not Found',
          placeDetailsResponse: [],
        ),
      );
    }
  }

  @override
  Future<void> close() {
    radiusSubscription.cancel();
    return super.close();
  }
}
