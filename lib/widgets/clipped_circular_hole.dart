import 'package:flutter/material.dart';

class InvertedClipper extends CustomClipper<Path> {
  InvertedClipper(this.radius);

  final double radius;

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: radius * size.width * 0.065,
        ),
      )
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Widget getOverlay(double radius) {
  return ClipPath(
    clipper: InvertedClipper(radius),
    child: Container(
      color: Colors.black.withOpacity(0.8),
    ),
  );
}

Widget getCustomPaintOverlay() {
  return CustomPaint(painter: OverlayWithHolePainter());
}

class OverlayWithHolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.width)),
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(size.width - 44, size.width - 44), radius: 40))
            ..close(),
        ),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Ring extends CustomClipper<Path> {
  Ring({this.strokeWidth});

  double strokeWidth;

  @override
  Path getClip(Size size) {
    final path = Path();
    final rect = Rect.fromLTRB(0, 0, size.width, size.width);
    path.addOval(rect);
    path.fillType = PathFillType.evenOdd;
    final rect2 = Rect.fromLTRB(0 + strokeWidth, 0 + strokeWidth,
        size.width - strokeWidth, size.width - strokeWidth);
    path.addOval(rect2);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
