import 'package:drink/utility/colors.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget imageSouceSheet({
  @required VoidCallback onCameraPressed,
  @required VoidCallback onGalleryPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          AppColors.DARK_BROWN.withOpacity(0.8),
          AppColors.BORDER_YELLOW
        ],
      ),
    ),
    child: SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
              leading: Icon(
                Icons.camera_enhance,
                color: Colors.white,
              ),
              title: Text(
                AppStrings.CAMERA,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onTap: onCameraPressed),
          Divider(
            color: Colors.white,
          ),
          ListTile(
              leading: Icon(
                Icons.image,
                color: Colors.white,
              ),
              title: Text(
                AppStrings.GALLERY,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onTap: onGalleryPressed)
        ],
      ),
    ),
  );
}
