import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/blocs/cart/cart_cubit.dart';
import 'package:drink/blocs/deal_alert/deal_alert_model.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/cart_model.dart';
import 'package:drink/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DealListTile extends StatefulWidget {
  const DealListTile({
    Key key,
    @required this.dealModel,
    @required this.themeType,
  }) : super(key: key);
  final DealAlertModel dealModel;
  final ThemeType themeType;

  @override
  _DealListTileState createState() => _DealListTileState();
}

class _DealListTileState extends State<DealListTile> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.CIRCLE_YELLOW,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.dealModel.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.themeType == ThemeType.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  AutoSizeText(
                    widget.dealModel.description,
                    minFontSize: 12,
                    style: TextStyle(
                      color: widget.themeType == ThemeType.light
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  /*SizedBox(height: 8.0),
                  AutoSizeText(
                    widget.dealModel.is_read.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    minFontSize: 10,
                    style: TextStyle(
                      color: widget.themeType == ThemeType.light
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),*/
                ],
              ),
            ),
            /*Expanded(
              flex: 20,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '\$ ${widget.dealModel.is_read.toString()}',
                    style: TextStyle(
                      color: AppColors.TEXT_YELLOW,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
