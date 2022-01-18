import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'update_circle_state.dart';

class UpdateCircleCubit extends Cubit<UpdateCircleState> {
  UpdateCircleCubit() : super(UpdateCircleState(radius: 1.0));

  void updateRadius(double radius) {
    emit(state.copyWith(radius: radius));
  }

  void updateCenter(LatLng center) {
    emit(state.copyWith(center: center));
  }
}
