import 'package:bloc/bloc.dart';
import 'package:drink/models/bottom_sheet.dart';
import 'package:drink/models/place_details.dart';
import 'package:flutter/material.dart';

class BottomSheetCubit extends Cubit<BottomInfoSheet> {
  BottomSheetCubit()
      : super(
          BottomInfoSheet(),
        );

  void updateBottomInfoSheet({
    DPlaceDetails placeDetails,
    BuildContext context,
  }) {
    if (state.placeDetails == placeDetails) {
      emit(state.updatePlace(null));
    } else {
      emit(state.updatePlace(placeDetails));
    }
  }

  void showBottomSheet(DPlaceDetails placeDetails) =>
      emit(state.updatePlace(placeDetails));

  void hideBottomInfoSheet() => emit(state.updatePlace(null));
}
