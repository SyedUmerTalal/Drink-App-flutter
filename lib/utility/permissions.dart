import 'package:geolocator/geolocator.dart';

class PositionPermission {
  const PositionPermission(this.isAvailable);
  final bool isAvailable;

  static Future<PositionPermission> check() async {
    try {
      final bool _location = (await Geolocator.requestPermission()).index == 1;
      return PositionPermission(_location);
    } catch (e) {
      return PositionPermission(false);
    }
  }
}
