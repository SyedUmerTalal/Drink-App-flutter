import 'dart:math';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class EmptyListWidget extends StatefulWidget {
  const EmptyListWidget({
    this.title,
    this.subTitle,
    this.image,
    this.subtitleTextStyle,
    this.titleTextStyle,
    @required this.themeType,
  });

  final String image;
  final String subTitle;
  final TextStyle subtitleTextStyle;
  final String title;
  final TextStyle titleTextStyle;
  final ThemeType themeType;

  @override
  State<StatefulWidget> createState() => _EmptyListWidgetState();
}

class _EmptyListWidgetState extends State<EmptyListWidget>
    with TickerProviderStateMixin {
  // String title, subTitle,image = 'assets/images/emptyImage.png';

  AnimationController _backgroundController;

  String _image;
  Animation _imageAnimation;
  AnimationController _imageController;
  TextStyle _subtitleTextStyle;
  TextStyle _titleTextStyle;
  AnimationController _widgetController;

  @override
  void dispose() {
    _backgroundController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _backgroundController = AnimationController(
        duration: const Duration(minutes: 1),
        vsync: this,
        lowerBound: 0,
        upperBound: 20)
      ..repeat();
    _widgetController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
    )..forward();
    _imageController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _imageAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.linear),
    );
    super.initState();
  }

  void animationListner() {
    if (_imageController == null) {
      return;
    }
    if (_imageController.isCompleted) {
      setState(() {
        _imageController.reverse();
      });
    } else {
      setState(() {
        _imageController.forward();
      });
    }
  }

  Widget _imageWidget() {
    _image = widget.image;

    return Expanded(
      flex: 3,
      child: AnimatedBuilder(
        animation: _imageAnimation,
        builder: (BuildContext context, Widget child) {
          return Transform.translate(
              offset: Offset(
                  0,
                  sin(_imageAnimation.value > .9
                      ? 1 - _imageAnimation.value
                      : _imageAnimation.value)),
              child: child);
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            _image,
            fit: BoxFit.contain,
            color: widget.themeType == ThemeType.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _shell({Widget child}) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxHeight > constraints.maxWidth) {
        return Container(
          height: constraints.maxWidth,
          width: constraints.maxWidth,
          child: child,
        );
      } else {
        return child;
      }
    });
  }

  Widget _shellChild() {
    _titleTextStyle = widget.titleTextStyle ??
        Theme.of(context)
            .typography
            .dense
            .headline5
            .copyWith(color: Color(0xff9da9c7));
    _subtitleTextStyle = widget.subtitleTextStyle ??
        Theme.of(context)
            .typography
            .dense
            .bodyText2
            .copyWith(color: Color(0xffabb8d6));

    return FadeTransition(
      opacity: _widgetController,
      child: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxWidth,
                  width: constraints.maxWidth - 30,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      _imageWidget(),
                      Column(
                        children: <Widget>[
                          CustomText(
                            msg: widget.title,
                            style: _titleTextStyle,
                            context: context,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomText(
                              msg: widget.subTitle,
                              style: _subtitleTextStyle,
                              context: context,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center)
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    ],
                  ),
                );
              }),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _shell(child: _shellChild());
  }
}
