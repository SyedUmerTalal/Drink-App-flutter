import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/progress_controller.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class RestartableCircularProgressIndicator extends StatefulWidget {
  const RestartableCircularProgressIndicator({
    Key key,
    @required this.controller,
    @required this.themeType,
    this.onTimeout,
  })  : assert(controller != null),
        super(key: key);
  final ProgressController controller;
  final VoidCallback onTimeout;
  final ThemeType themeType;

  @override
  _RestartableCircularProgressIndicatorState createState() =>
      _RestartableCircularProgressIndicatorState();
}

class _RestartableCircularProgressIndicatorState
    extends State<RestartableCircularProgressIndicator> {
  ProgressController get controller => widget.controller;

  VoidCallback get onTimeout => widget.onTimeout;

  @override
  void initState() {
    super.initState();
    controller.progressStream.listen((_) => updateState());
    controller.timeoutStream.listen((_) => onTimeout());
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 5.0,
      percent: 1 - controller.progress,
      center: Text(
        '${(controller.progress * 60).round()}',
        style: TextStyle(
          color:
              widget.themeType == ThemeType.light ? Colors.black : Colors.white,
          fontSize: 14,
        ),
      ),
      progressColor:
          widget.themeType == ThemeType.light ? Colors.white60 : Colors.white,
      backgroundColor: AppColors.CIRCLE_YELLOW,
    );
    // return Container(
    //   width: 50,
    //   height: 50,
    //   child: Stack(
    //     fit: StackFit.expand,
    //     children: [
    //       CircularProgressIndicator(
    //         value: controller.progress - 1,

    //         // valueColor: AlwaysStoppedAnimation<Color>(AppColors.CIRCLE_YELLOW),
    //       ),
    //       Center(
    //           child:

    //       ),
    //     ],
    //   ),
    // );
  }

  void updateState() => setState(() {});
}
