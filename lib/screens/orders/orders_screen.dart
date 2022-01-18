import 'dart:developer';
import 'dart:io' show Platform;

import 'package:drink/blocs/credit_card/bookmark_creditcard/bookmark_creditcard_cubit.dart';
import 'package:drink/blocs/orders/get_orders/get_orders_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/order.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/screens/orders_details/order_details_screen.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/empty_widget.dart';
import 'package:drink/widgets/order_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key key, this.orderId}) : super(key: key);
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetOrdersCubit, GetOrdersState>(
        listener: (context, state) {
      if (state is GetOrdersLoading) {
        LoadingDialog.show(context);

        ///ARK Changes
      } else if (state is GetOrdersLoadedForDetails) {
        LoadingDialog.hide(context);
        AppNavigation.navigateTo(
          context,
          BlocProvider<BookmarkCreditcardCubit>(
            create: (context) => BookmarkCreditcardCubit(),
            child: OrderDetailsScreen(
              order: state.order,
              isPrevious: true,
            ),
          ),
        );
      } else if (state is GetOrdersLoaded) {
        LoadingDialog.hide(context);
      } else if (state is GetOrdersFailed) {
        LoadingDialog.hide(context);
        if (state.message != 'success') {
          AppNavigation.showToast(message: state.message);
        }
      }

      ///ARK Changes
      else if (state is UnAuthenticated) {
        Navigator.of(context).pop();
        context.read<AuthenticationRepository>().signOut();
      }
    }, child: BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Container(
          decoration: themeState.type == ThemeType.light
              ? backGroundImgDecorationLight
              : backGroundImgDecoration,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                AppStrings.ORDERS,
                style: TextStyle(
                    color: themeState.type == ThemeType.light
                        ? Colors.black
                        : Colors.white),
              ),
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
                  /// Changes will occur
                  AppNavigation.navigatorPop(context);
                },
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocBuilder<GetOrdersCubit, GetOrdersState>(
                builder: (context, state) {
                  // debugger();
                  if (state is GetOrdersInitial && orderId != null) {
                    context
                        .read<GetOrdersCubit>()
                        .getAllOrdersForDetail(orderId);
                    return Container();
                  }
                  if (state is GetOrdersInitial) {
                    context.read<GetOrdersCubit>().getAllOrders();
                    return Container();
                  }

                  ///ARK Changes
                  else if (state is GetOrdersLoadedForDetails) {
                    return Container();
                  } else if (state is GetOrdersLoaded) {
                    return ListView.separated(
                      itemBuilder: (context, index) => OrderListTile(
                        order: state.allOrders[index],
                        themeType: themeState.type,
                        callBack: () {
                          final Order order = state.allOrders[index];
                          // debugger();
                          order.id;
                          int y = 0;
                          AppNavigation.navigateTo(
                            context,
                            BlocProvider<BookmarkCreditcardCubit>(
                              create: (context) => BookmarkCreditcardCubit(),
                              child: OrderDetailsScreen(
                                order: state.allOrders[index],
                                isPrevious: false,
                              ),
                            ),
                          );
                        },
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 20,
                      ),
                      itemCount: state.allOrders.length,
                    );
                  } else if (state is GetOrdersFailed) {
                    return Center(
                      child: EmptyListWidget(
                        title: AppStrings.NO_ORDERS,
                        subTitle: AppStrings.NO_ORDERS_PUNCHLINE,
                        titleTextStyle: Theme.of(context)
                            .typography
                            .dense
                            .headline5
                            .copyWith(
                                color: themeState.type == ThemeType.light
                                    ? Colors.black
                                    : Colors.white),
                        image: AssetPaths.SAD_IMAGE,
                        subtitleTextStyle: Theme.of(context)
                            .typography
                            .dense
                            .bodyText2
                            .copyWith(
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                        themeType: themeState.type,
                      ),
                    );
                  }
                  /*else if (state is UnAuthenticated) {
                    context.read<AuthenticationRepository>().signOut();
                    return SigninScreen();
                  } */
                  else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        );
      },
    ));
  }
}
