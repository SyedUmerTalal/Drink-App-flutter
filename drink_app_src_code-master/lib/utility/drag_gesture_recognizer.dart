import 'package:flutter/gestures.dart';

class MapDragGesture extends DragGestureRecognizer {
  MapDragGesture(this._test);

  Function _test;

  @override
  void resolve(GestureDisposition disposition) {
    super.resolve(disposition);
    _test();
  }

  @override
  String get debugDescription => 'google maps drag';

  @override
  bool isFlingGesture(VelocityEstimate estimate, PointerDeviceKind kind) {
    final double minVelocity = minFlingVelocity ?? kMinFlingVelocity;
    final double minDistance = minFlingDistance ?? computeHitSlop(kind);
    return estimate.pixelsPerSecond.dx.abs() > minVelocity &&
        estimate.offset.dx.abs() > minDistance;
  }
}
