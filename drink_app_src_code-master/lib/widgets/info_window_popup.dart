import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:drink/utility/pop_up_route.dart';
import 'package:meta/meta.dart';

class InfoWidgetPopUp extends StatefulWidget {
  const InfoWidgetPopUp({
    Key key,
    @required this.infoWidgetRoute,
  })  : assert(infoWidgetRoute != null),
        super(key: key);

  final InfoWidgetRoute infoWidgetRoute;

  @override
  _InfoWidgetPopUpState createState() => _InfoWidgetPopUpState();
}

class _InfoWidgetPopUpState extends State<InfoWidgetPopUp> {
  CurvedAnimation _fadeOpacity;

  @override
  void initState() {
    super.initState();
    _fadeOpacity = CurvedAnimation(
      parent: widget.infoWidgetRoute.animation,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOpacity,
      child: Material(
        type: MaterialType.transparency,
        textStyle: widget.infoWidgetRoute.textStyle,
        child: ClipPath(
          clipper: _InfoWidgetClipper(),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 10),
            child: Center(child: widget.infoWidgetRoute.child),
          ),
        ),
      ),
    );
  }
}

class _InfoWidgetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 20);
    path.quadraticBezierTo(0.0, size.height - 10, 10.0, size.height - 10);
    path.lineTo(size.width / 2 - 10, size.height - 10);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + 10, size.height - 10);
    path.lineTo(size.width - 10, size.height - 10);
    path.quadraticBezierTo(
        size.width, size.height - 10, size.width, size.height - 20);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(10, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 10);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
