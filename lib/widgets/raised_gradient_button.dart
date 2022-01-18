import 'package:flutter/material.dart';
import 'package:drink/utility/colors.dart';

class RaisedGradientButton extends StatelessWidget {
  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.gradient = const LinearGradient(
      colors: <Color>[AppColors.DARK_BROWN, AppColors.BORDER_YELLOW],
    ),
    this.width,
    this.height = 34.0,
    this.onPressed,
  }) : super(key: key);
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.3,
      height: height,
      decoration: ShapeDecoration(
        gradient: gradient,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onTap: onPressed,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
