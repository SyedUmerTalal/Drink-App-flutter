import 'package:flutter/material.dart';

class CircleRevealClipper extends CustomClipper<Rect> {
  CircleRevealClipper();

  @override
  Rect getClip(Size size) {
    final epicenter = Offset(size.width, size.height);

    // Calculate distance from epicenter to the top left corner to make sure clip the image into circle.

    final distanceToCorner = epicenter.dy;

    final radius = distanceToCorner;
    final diameter = radius;

    return Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
