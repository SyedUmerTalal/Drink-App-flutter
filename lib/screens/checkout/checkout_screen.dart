import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:drink/blocs/bar_details/table_reservation/table_reservation_cubit.dart';
import 'package:drink/blocs/cart/cart_cubit.dart';
import 'package:drink/blocs/checkout/checkout/checkout_cubit.dart';
import 'package:drink/blocs/credit_card/bookmark_creditcard/bookmark_creditcard_cubit.dart';
import 'package:drink/blocs/orders/get_orders/get_orders_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/checkout_model.dart';
import 'package:drink/models/credit_card.dart' as cc;
import 'package:drink/repositories/orders_repository.dart';
import 'package:drink/screens/cards/cards_screen.dart';
import 'package:drink/screens/orders/orders_screen.dart';
import 'package:drink/screens/orders_details/order_details_screen.dart';
import 'package:drink/screens/qr_code/qr_code.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/custom_snacks_bar.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/card.dart';
import 'package:drink/widgets/drop_down_field.dart';
import 'package:drink/widgets/empty_widget.dart';
import 'package:drink/widgets/raised_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    Key key,
    @required this.total,
    this.isTableReservation = false,
  }) : super(key: key);
  final double total;
  final bool isTableReservation;

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // final FocusNode _deliveryFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _addressNameFocus = FocusNode();

  // String _selectedDeliveryOption;
  String _selectedAddress;

  final _formKey = GlobalKey<FormState>();

  cc.CreditCard _currentProvider;

  @override
  void initState() {
    super.initState();
    final String stringData =
        SharedPref.instance.sharedPreferences.getString(AppStrings.BKCC);
    if (stringData?.isNotEmpty ?? false) {
      final mappedData = jsonDecode(stringData);
      _currentProvider = cc.CreditCard.fromJson(mappedData);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        // debugger();
        if (state is CheckoutLoading) {
          LoadingDialog.show(context);
        } else if (state is CheckoutLoaded) {
          // debugger();
          LoadingDialog.hide(context);
          // Navigator.of(context).pop();
          // context.read<CartCubit>().emptyCart();

          ///Salman Changes
          /*AppNavigation.navigateTo(
              context,
              BlocProvider<GetOrdersCubit>(
                create: (context) =>
                    GetOrdersCubit(ordersRepository: OrdersRepository()),
                child: OrdersScreen(orderId: state.checkoutModel.id),
              )).whenComplete(() async {
            await context
                .read<CartCubit>()
                .emptyCart()
                .whenComplete(() => Navigator.of(context).pop());
          });*/

          ///ARK Changes
          Navigator.of(context).pop();
          context.read<CartCubit>().emptyCart1(state.checkoutModel.id);

          // Navigator.of(context).pop();
        } else if (state is CheckoutFailed) {
          LoadingDialog.hide(context);
          if (state.message != 'success') {
            AppNavigation.showToast(message: state.message);
          }
        }
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          // debugger();
          return Container(
            decoration: themeState.type == ThemeType.light
                ? backGroundImgDecorationLight
                : backGroundImgDecoration,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
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
                title: Text(
                  AppStrings.CHECKOUT,
                  style: TextStyle(
                    color: themeState.type == ThemeType.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: AppColors.BORDER_YELLOW,
                                ),
                              ),
                              color: themeState.type == ThemeType.light
                                  ? Colors.white
                                  : Colors.transparent,
                              shadows: themeState.type == ThemeType.light
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
                            child: Column(
                              children: [
                                ListTile(
                                  leading: ImageIcon(
                                    AssetImage(AssetPaths.CREDIT_CARD_ICON),
                                    color: themeState.type == ThemeType.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  title: Text(
                                    AppStrings.PAYMENT_OPTIONS,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: themeState.type == ThemeType.light
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  trailing: Visibility(
                                    visible: _currentProvider != null,
                                    child: IconButton(
                                      icon: ImageIcon(
                                        AssetImage(AssetPaths.EDIT),
                                        color:
                                            themeState.type == ThemeType.light
                                                ? Colors.black
                                                : Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        final _result =
                                            await AppNavigation.navigateTo(
                                          context,
                                          CardScreen(
                                            overlayDisabled: true,
                                          ),
                                        );
                                        if (_result != null) {
                                          _currentProvider = _result[0];
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                _currentProvider == null
                                    ? ListTile(
                                        leading: Icon(
                                          Icons.add,
                                          color: AppColors.CIRCLE_YELLOW,
                                        ),
                                        title: Text(
                                          AppStrings.ADD_PAYMENT_METHOD,
                                          style: TextStyle(
                                            color: AppColors.CIRCLE_YELLOW,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onTap: () async {
                                          final _result =
                                              await AppNavigation.navigateTo(
                                            context,
                                            CardScreen(
                                              overlayDisabled: true,
                                            ),
                                          );
                                          if (_result != null) {
                                            _currentProvider = _result[0];
                                            setState(() {});
                                          }
                                        })
                                    : CreditCard(
                                        orignalProvider: _currentProvider,
                                        onDelete: _handleDeleteTapped,
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          totalCostText(themeState.type),
                          SizedBox(
                            height: 48,
                          ),
                          payNowButton(),
                          SizedBox(
                            height: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget payNowButton() {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        // debugger();
        // if (state is CheckoutLoaded) {
        // // debugger();
        //   return ElevatedButton(
        //       onPressed: () {
        //       // debugger();
        //         CheckoutModel checkoutModel = state.checkoutModel;
        //       },
        //       child: Text(
        //         "Checkout",
        //         style: TextStyle(color: Colors.blue),
        //       ));
        // } else {
        return RaisedGradientButton(
          child: Text(
            AppStrings.PAY_NOW,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: (!(state is CheckoutLoading) || widget.isTableReservation)
              ? () {
                  // debugger();
                  if (_currentProvider == null) {
                    CustomSnacksBar.showSnackBar(
                        context, AppStrings.PAYMENT_METHOD_ERROR);
                  } else {
                    // debugger();
                    if (!widget.isTableReservation) {
                      dynamic val = context
                          .read<CheckoutCubit>()
                          .placeOrder(_currentProvider.id);
                      // debugger();
                      int y = 0;
                    } else {
                      context
                          .read<TableReservationCubit>()
                          .updateCardId(_currentProvider.id);
                      print(_currentProvider.id.toString() +
                          'This is the card id inside the checkout screen');
                      Future.delayed(Duration(milliseconds: 100), () {
                        context
                            .read<TableReservationCubit>()
                            .selectDate(_currentProvider.id);
                      });
                      Navigator.of(context).pop();
                    }
                  }
                }
              : null,
        );
        // }
      },
    );
  }

  Padding totalCostText(ThemeType themeType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.TOTAL_COST,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeType == ThemeType.light ? Colors.black : Colors.white,
            ),
          ),
          Text(
            '\$ ' + widget.total.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeType == ThemeType.light ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _handleDeleteTapped(cc.CreditCard model) {
    _currentProvider = null;
    setState(() {});
  }

  DropDownField addNewAddressTextField(BuildContext context) {
    return DropDownField(
      validator: (value) => value?.isEmpty ?? true
          ? AppStrings.ADDRESS_NAME +
              AppStrings.SPACE +
              AppStrings.GENERIC_ERROR
          : null,
      focusNode: _addressFocus,
      currentValue: _selectedAddress,
      innerText: AppStrings.ADD_NEW_ADDRESS,
      options: [AppStrings.SAMPLE_ADDRESS_ONE, AppStrings.SAMPLE_ADDRESS_TWO],
      onChanged: (String newValue) {
        _addressFocus.unfocus();
        FocusScope.of(context).requestFocus(_addressNameFocus);
        setState(() {
          _selectedAddress = newValue;
        });
      },
    );
  }
}
