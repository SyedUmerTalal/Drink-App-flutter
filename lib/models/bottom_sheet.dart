import 'package:drink/models/place_details.dart';
import 'package:equatable/equatable.dart';

class BottomInfoSheet extends Equatable {
  const BottomInfoSheet({
    this.placeDetails,
  });

  final DPlaceDetails placeDetails;

  BottomInfoSheet updatePlace(DPlaceDetails updatedPlaceDetails) {
    return BottomInfoSheet(
      placeDetails: updatedPlaceDetails,
    );
  }

  @override
  List<Object> get props => [
        placeDetails,
      ];

  @override
  String toString() {
    return ''' BottomInfoSheet{

      placeDetails: $placeDetails,
    }
    }''';
  }
}
