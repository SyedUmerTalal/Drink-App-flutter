import 'dart:async';

import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);
  static AssetImage getAssetImageDark() => AssetImage(AssetPaths.APP_LOGO);

  static AssetImage getAssetImageLight() => AssetImage(AssetPaths.LOGO_DARK);

  static Future<void> preloadDarkModeLogo() async {
    final ImageStream imageStream =
        getAssetImageDark().resolve(ImageConfiguration.empty);
    final Completer completer = Completer();
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) => completer.complete(),
      onError: (e, stackTrace) => completer.completeError(e, stackTrace),
    );
    imageStream.addListener(listener);
    return completer.future
        .whenComplete(() => imageStream.removeListener(listener));
  }

  static Future<void> preloadLightModeLogo() async {
    final ImageStream imageStream =
        getAssetImageLight().resolve(ImageConfiguration.empty);
    final Completer completer = Completer();
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) => completer.complete(),
      onError: (e, stackTrace) => completer.completeError(e, stackTrace),
    );
    imageStream.addListener(listener);
    return completer.future
        .whenComplete(() => imageStream.removeListener(listener));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return Container(
          color: themeState.type == ThemeType.light
              ? Colors.white
              : Color(0xFF170C00),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:32.0),
              child: Image(
                width: MediaQuery.of(context).size.width*0.75,
                height: 74,
                image: themeState.type == ThemeType.dark
                    ? getAssetImageDark()
                    : getAssetImageLight(),
              ),
            ),
          ));
    });
  }
}
