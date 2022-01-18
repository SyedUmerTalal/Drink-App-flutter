import 'package:drink/utility/asset_paths.dart';
import 'package:flutter/material.dart';

Image logoImage = Image.asset(
  AssetPaths.APP_LOGO,
  width: 200,
  height: 100,
);

Image logoDarkImage = Image.asset(
  AssetPaths.LOGO_DARK,
  width: 200,
  height: 100,
);

Image backgroundImage(BuildContext context) => Image.asset(
      AssetPaths.DARK_BACKGROUND,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.fill,
    );
