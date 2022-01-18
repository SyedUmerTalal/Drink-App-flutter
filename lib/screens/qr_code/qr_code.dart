import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/cart_model.dart';
import 'package:drink/models/checkout_model.dart';
import 'package:drink/models/order.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/card.dart';

import 'package:drink/widgets/order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:drink/models/credit_card.dart' as cc;

class QRCode extends StatelessWidget {
  const QRCode({Key key, @required this.id, @required this.checkoutModel})
      : super(key: key);
  final String id;
  final CheckoutModel checkoutModel;

  @override
  Widget build(BuildContext context) {
    // debugger();
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return Container(
        decoration: themeState.type == ThemeType.light
            ? backGroundImgDecorationLight
            : backGroundImgDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
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
              onPressed: () {
                AppNavigation.navigatorPop(context);
              },
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              AppStrings.QR_CODE_TITLE,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: Column(
            children: [
              Center(
                child: Container(
                  color: Colors.white,
                  child: QrImage(
                    data: id,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    // debugger();

                    CheckoutModel _checkoutModel = checkoutModel;
                  },
                  child: Text(
                    "Checkout",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ),
        ),
      );
    });
  }
}

/*
class QRCode extends StatefulWidget {
  const QRCode(
      {Key key,
      @required this.id,
      @required this.checkoutModel,
      @required this.productsList})
      : super(key: key);
  final String id;
  final List<CartModel> productsList;
  final CheckoutModel checkoutModel;

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  Widget orderDetails(ThemeType themeType, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: themeType == ThemeType.dark ? Colors.white : Colors.grey,
      ),
      child: DataTable(
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
                color:
                    themeType == ThemeType.light ? Colors.black : Colors.white,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              AppStrings.QUANTITY,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color:
                    themeType == ThemeType.light ? Colors.black : Colors.white,
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
        rows: widget.productsList
            .map((item) => DataRow(cells: [
                  DataCell(
                    Text(
                      item.drink.name.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: themeType == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
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
                  DataCell(
                    Text(
                      '\$ ' + item.drink.price.toString(),
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
    );
  }

  @override
  Widget build(BuildContext context) {
  // debugger();
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return Container(
        decoration: themeState.type == ThemeType.light
            ? backGroundImgDecorationLight
            : backGroundImgDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
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
              onPressed: () {
                AppNavigation.navigatorPop(context);
              },
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              // AppStrings.QR_CODE_TITLE,
              AppStrings.ORDERS_DETAILS,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Text("aB"),
                ElevatedButton(
                  onPressed: () {
                  // debugger();
                    int y = 0;
                    widget.productsList;
                    widget.checkoutModel;
                  },
                  child: Text("AB"),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  int StringIntoInt(String val) {
    if (val != null) {
      if (val.isNotEmpty) {
        try {
          int _val = int.parse(val);
          return _val;
        } catch (e) {
          return 0000;
        }
      } else {
        return 0000;
      }
    } else {
      return 0000;
    }
  }
}
*/
