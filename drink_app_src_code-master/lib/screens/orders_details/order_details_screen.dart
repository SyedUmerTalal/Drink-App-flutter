import 'dart:developer';
import 'dart:io' show Platform;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/blocs/orders/get_orders/get_orders_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/blocs/tips/tips_cubit.dart';
import 'package:drink/blocs/tips/tips_service.dart';
import 'package:drink/models/credit_card.dart' as cc;
import 'package:drink/models/order.dart';
import 'package:drink/repositories/orders_repository.dart';
import 'package:drink/screens/Tip/tip_screen.dart';
import 'package:drink/screens/home/home_screen.dart';
import 'package:drink/screens/orders/orders_screen.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/card.dart';
import 'package:drink/widgets/order_list_tile.dart';
import 'package:drink/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen(
      {Key key, @required this.order, @required this.isPrevious})
      : super(key: key);

  ///ARK Changes
  final bool isPrevious;

  final Order order;

  Widget orderDetails(ThemeType themeType, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: themeType == ThemeType.dark ? Colors.white : Colors.grey,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: 350,
          // width: MediaQuery.of(context).size.shortestSide,
          child: DataTable(
            dataRowHeight: 100,
            columnSpacing: 2,
            horizontalMargin: 5,
            showBottomBorder: true,
            dividerThickness: 1,
            columns: [
              DataColumn(
                label: Text(
                  AppStrings.NAME,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: themeType == ThemeType.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  AppStrings.QUANTITY,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: themeType == ThemeType.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  AppStrings.PRICE,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.TEXT_YELLOW),
                ),
              )
            ],
            rows: order.items
                .map((item) => DataRow(cells: [
                      DataCell(
                        Wrap(
                          // direction: Axis.horizontal,
                          // alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              item.name.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: themeType == ThemeType.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            item.qty.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: themeType == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '\$ ' + item.price.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.TEXT_YELLOW,
                          ),
                        ),
                      )
                    ]))
                .cast<DataRow>()
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          decoration: themeState.type == ThemeType.light
              ? backGroundImgDecorationLight
              : backGroundImgDecoration,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Platform.isAndroid
                    ? Icon(
                        Icons.arrow_back,
                        color: themeState.type == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                      )
                    : Icon(
                        Icons.arrow_back_ios,
                        color: themeState.type == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                      ),
                onPressed: () async {
                  ///ARK Changes
                  // debugger();
                  if (isPrevious == true) {
                    // Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  } else {
                    AppNavigation.navigatorPop(context);
                    // AppNavigation.navigateReplacement(
                    //     context,
                    //     BlocProvider<GetOrdersCubit>(
                    //       create: (context) => GetOrdersCubit(
                    //           ordersRepository: OrdersRepository()),
                    //       child: OrdersScreen(),
                    //     ));
                  }
                },
              ),
              title: AutoSizeText(
                AppStrings.ORDERS_DETAILS,
                style: TextStyle(
                  color: themeState.type == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      OrderListTile(
                        order: order,
                        themeType: themeState.type,
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: shortestSide < 600
                        ? MediaQuery.of(context).size.height * 0.39
                        : MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          // padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: orderDetails(themeState.type, context),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // SizedBox(
                      //   height: getHeight(context) * 0.018,
                      // ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            AppStrings.TOTAL_COST,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 36,
                          ),
                          AutoSizeText(
                            '\$ ' + order.total.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.TEXT_YELLOW,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            AppStrings.PAYMENT,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          order?.card != null
                              ? CreditCard(
                                  orignalProvider: cc.CreditCard(
                                    id: order?.card?.id,
                                    brand: order?.card?.brand,
                                    expMonth: order?.card?.expMonth,
                                    expYear: order?.card?.expYear,
                                    lastFour: order?.card?.lastFour,
                                  ),
                                  isOrdertailsScreen: true,
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: themeState.type == ThemeType.light
                              ? [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]
                              : [],
                        ),
                        child: QrImage(
                          data:
                              'https://webprojectmockup.com/custom/drinkWeb/public/invoice/' +
                                  order.id.toString(),
                          version: QrVersions.auto,
                          size: shortestSide < 600 ? 100.0 : 200,
                        ),
                      ),
                    ),

                    ///Salman Changes
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: RaisedGradientButton(
                        child: Text(
                          AppStrings.ADD_TIP,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          // AppNavigation.navigateTo(context, TipScreen());
                          var _messageIntent = await AppNavigation.navigateTo(
                              context,
                              BlocProvider<TipsCubit>(
                                create: (context) =>
                                    TipsCubit(tipsservice: TipsServiceImp()),
                                child: TipScreen(
                                  orderId: order.id,
                                ),
                              ));
                          // debugger();
                          if (_messageIntent != null) {
                            await Future.delayed(Duration(seconds: 1));
                            await AppNavigation.showAsyncToast(
                                message: _messageIntent['message']);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
