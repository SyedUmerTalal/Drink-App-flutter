import 'dart:core';

import 'package:flutter/material.dart';

class InfoWidgetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 40);
    path.quadraticBezierTo(0.0, size.height - 20, 20.0, size.height - 20);
    path.lineTo(size.width / 2 - 15, size.height - 20);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + 15, size.height - 20);
    path.lineTo(size.width - 20, size.height - 20);
    path.quadraticBezierTo(
        size.width, size.height - 20, size.width, size.height - 40);
    path.lineTo(size.width, 20.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 20.0, 0.0);
    path.lineTo(20, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 20);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
