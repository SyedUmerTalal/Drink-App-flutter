import 'dart:async';
import 'dart:math' as Math;
import 'package:drink/utility/asset_paths.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

double scaleHeight(BuildContext context, double height) {
  return (height / 781.09) * MediaQuery.of(context).size.height;
}

double scaleWidth(BuildContext context, double width) {
  return (width / 392.72) * MediaQuery.of(context).size.width;
}

AssetImage getAssetImage() => AssetImage(AssetPaths.DARK_BACKGROUND);

AssetImage getAssetImageLight() => AssetImage(AssetPaths.LIGHT_BACKGROUND);

Future<void> preload() async {
  final ImageStream imageStream =
      getAssetImage().resolve(ImageConfiguration.empty);
  final Completer completer = Completer();
  final ImageStreamListener listener = ImageStreamListener(
    (ImageInfo imageInfo, bool synchronousCall) => completer.complete(),
    onError: (e, stackTrace) => completer.completeError(e, stackTrace),
  );
  imageStream.addListener(listener);
  return completer.future
      .whenComplete(() => imageStream.removeListener(listener));
}

double getHeight(BuildContext context) =>
    MediaQuery.of(context).size.height - kToolbarHeight - 32;

double getZoomLevel(double radius) {
  double radiusValue = 1609 * radius;
  double scale = radiusValue / 380;
  return 14 - Math.log(scale) / Math.log(3);
}
