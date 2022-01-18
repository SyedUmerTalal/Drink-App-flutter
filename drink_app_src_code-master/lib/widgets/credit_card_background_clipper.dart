import 'package:flutter/material.dart';

class CreditCardBgClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width / 1.18, 0);
    path.lineTo(size.width / 1.18, 62);
    path.quadraticBezierTo(size.width / 1.18, 62, size.width / 1.18 - 10.0, 72);
    path.lineTo(0.0, 72);
    path.lineTo(0.0, 72);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
