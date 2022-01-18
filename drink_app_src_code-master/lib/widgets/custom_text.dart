import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  const CustomText(
      {Key key,
      this.msg,
      this.style,
      this.textAlign,
      this.overflow,
      this.context,
      this.softwrap})
      : super(key: key);

  final BuildContext context;
  final String msg;
  final TextOverflow overflow;
  final bool softwrap;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  TextStyle style;

  @override
  @override
  void initState() {
    style = widget.style;
    super.initState();
  }

  Widget customText() {
    if (widget.msg == null) {
      return Container();
    }
    if (widget.context != null && widget.style != null) {
      final font = widget.style.fontSize == null
          ? Theme.of(context).textTheme.headline5.fontSize
          : widget.style.fontSize;
      style = widget.style.copyWith(
          fontSize: font - (MediaQuery.of(context).size.width <= 375 ? 2 : 0));
    }
    return Text(
      widget.msg,
      style: widget.style,
      textAlign: widget.textAlign,
      overflow: widget.overflow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return customText();
  }
}
