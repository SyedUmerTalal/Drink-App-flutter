import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderListTile extends StatelessWidget {
  const OrderListTile({
    Key key,
    this.callBack,
    @required this.order,
    @required this.themeType,
  }) : super(key: key);
  final VoidCallback callBack;
  final Order order;
  final ThemeType themeType;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callBack(),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: themeType == ThemeType.light
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]
              : [],
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.ORDER_ID + ': ${order.id}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMMd('en_US').format(order.date),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              Text(
                '\$ ${order.total}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.MONEY_TEXT_COLOR,
                ),
              ),
            ]),
      ),
    );
  }
}
