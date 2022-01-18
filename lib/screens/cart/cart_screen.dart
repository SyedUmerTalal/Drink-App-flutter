import 'dart:developer';
import 'dart:io' show Platform;
import 'package:drink/blocs/checkout/checkout/checkout_cubit.dart';
import 'package:drink/blocs/credit_card/bookmark_creditcard/bookmark_creditcard_cubit.dart';
import 'package:drink/blocs/orders/get_orders/get_orders_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/repositories/checkout_repository.dart';
import 'package:drink/repositories/orders_repository.dart';
import 'package:drink/screens/checkout/checkout_screen.dart';
import 'package:drink/screens/orders/orders_screen.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/cart_list_tile.dart';
import 'package:drink/widgets/empty_widget.dart';
import 'package:drink/widgets/raised_gradient_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drink/blocs/cart/cart_cubit.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          // debugger();
          if (state.isLoaded) {
            LoadingDialog.hide(context);
            AppNavigation.navigateTo(
              context,
              MultiBlocProvider(
                providers: [
                  BlocProvider<CheckoutCubit>(
                    ///ARK Changes
                    create: (context) => CheckoutCubit(CheckoutRepository())
                      ..isTableReservation = false,
                  ),
                  BlocProvider<BookmarkCreditcardCubit>(
                    create: (context) => BookmarkCreditcardCubit(),
                  ),
                ],
                child: CheckoutScreen(
                  total: state.total,
                ),
              ),
            );
          } else if (state.isLoading) {
            LoadingDialog.show(context);
          } else if (state.isFailed) {
            if (state.message != 'success') {
              AppNavigation.showToast(message: state.message);
            }
            LoadingDialog.hide(context);
          }
        },
        child: Container(
          decoration: themeState.type == ThemeType.light
              ? backGroundImgDecorationLight
              : backGroundImgDecoration,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
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
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                AppStrings.CART,
                style: TextStyle(
                    color: themeState.type == ThemeType.light
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: addNewCard(context, themeState.type),
            ),
          ),
        ),
      );
    });
  }

  Widget addNewCard(
    BuildContext context,
    ThemeType themeType,
  ) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        // debugger();
        if (state.moveToProduct == true) {
          AppNavigation.navigateReplacement(
              context,
              BlocProvider<GetOrdersCubit>(
                create: (context) =>
                    GetOrdersCubit(ordersRepository: OrdersRepository()),
                child: OrdersScreen(orderId: state.pid),
              ));
        } else if (state.total == 0) {
          AppNavigation.navigatorPop(context);
        }
      },
      builder: (context, state) {
        return state.products.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.2,
                        maxHeight: MediaQuery.of(context).size.height * 0.54,
                      ),
                      child: ListView.separated(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: CartListTile(
                            cartModel: state.products[index],
                            themeType: themeType,
                          ),
                        ),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        itemCount: state.products.length,
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.TOTAL_AMOUNT,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeType == ThemeType.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '\$ ' + state.total.round().toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeType == ThemeType.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Visibility(
                    visible: state.total > 0,
                    child: BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        // debugger();
                        return RaisedGradientButton(
                          width: 184,
                          child: Text(
                            AppStrings.PROCEED_TO_CHECKOUT,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: state.total > 0 && !state.isLoading
                              ? () {
                                  Future.delayed(Duration.zero, () {
                                    context.read<CartCubit>().updateInAPI();
                                  });
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )
            : Center(
                child: EmptyListWidget(
                  image: 'assets/images/empty_cart_sad.png',
                  title: AppStrings.CART_EMPTY,
                  subTitle: AppStrings.CART_PUNCHLINE,
                  titleTextStyle:
                      Theme.of(context).typography.dense.headline5.copyWith(
                            color: themeType == ThemeType.light
                                ? Colors.black
                                : Colors.white,
                          ),
                  subtitleTextStyle:
                      Theme.of(context).typography.dense.bodyText2.copyWith(
                            color: themeType == ThemeType.light
                                ? Colors.black
                                : Colors.white,
                          ),
                  themeType: themeType,
                ),
              );
      },
    );
  }
}
