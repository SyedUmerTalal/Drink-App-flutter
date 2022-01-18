import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationRepository {
  Stream<Position> getUsersPositionStream() async* {
    yield* Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5,
    );
  }
}
