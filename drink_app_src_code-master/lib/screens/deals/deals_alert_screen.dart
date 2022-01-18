import 'dart:developer';
import 'dart:io' show Platform;

import 'package:drink/blocs/deal_alert/deal_alert_bloc.dart';
import 'package:drink/blocs/deal_alert/deal_alert_event.dart';
import 'package:drink/blocs/deal_alert/deal_alert_model.dart';
import 'package:drink/blocs/deal_alert/deal_alert_state.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/loading_dialog.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/deals_list_tile.dart';
import 'package:drink/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DealsAlertScreen extends StatefulWidget {
  DealsAlertScreen({Key key, this.dealAlertList}) : super(key: key);
  List<DealAlertModel> dealAlertList;

  @override
  _DealsAlertScreenState createState() => _DealsAlertScreenState();
}

class _DealsAlertScreenState extends State<DealsAlertScreen> {
  @override
  void initState() {
    if (widget.dealAlertList.isNotEmpty) {
      _readAlerts();
    }
    super.initState();
  }

  _getAlerts() {
    BlocProvider.of<DealAlertBloc>(context)
        .add(DealAlertEvents.againfetchDealAlert);
  }

  _readAlerts() {
    BlocProvider.of<DealAlertBloc>(context).add(DealAlertEvents.readDealAlert);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return Container(
        decoration: themeState.type == ThemeType.light
            ? backGroundImgDecorationLight
            : backGroundImgDecoration,
        child: Scaffold(
          extendBody: true,
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
            actions: [
              IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: themeState.type == ThemeType.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ],
                ),
                onPressed: () {
                  _getAlerts();
                },
              ),
            ],
            title: Text(
              AppStrings.DEALS,
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
            child: BlocConsumer<DealAlertBloc, DealAlertState>(
              listener: (context, state) {
                // debugger();
                if (state is PostLoadingState) {
                  if (state.isagain == true) {
                    LoadingDialog.show(context);
                  }
                }
                if (state is PostAgainLoadedState) {
                  LoadingDialog.hide(context);
                }
                if (state is PostListErrorState) {
                  if (state.isagain == true) {
                    LoadingDialog.hide(context);
                  }
                }
              },
              builder: (context, state) {
                if (state is PostAgainLoadedState) {
                  debugger();
                  return addNewCard(context, themeState.type, state.dealalert);
                } else {
                  return addNewCard(
                      context, themeState.type, widget.dealAlertList);
                }
              },
            ),
            // child: addNewCard(context, themeState.type),
          ),
        ),
      );
    });
  }

  Widget addNewCard(BuildContext context, ThemeType themeType,
      List<DealAlertModel> _dealAlertList) {
    // _dealAlertList = [];
    return _dealAlertList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: DealListTile(
                dealModel: _dealAlertList[index],
                themeType: themeType,
              ),
            ),
            itemCount: _dealAlertList.length,
          )
        : EmptyList(context, themeType);
  }
}

Widget EmptyList(BuildContext context, ThemeType themeType) {
  return Center(
    child: EmptyListWidget(
      image: 'assets/images/empty_bell_icon.png',
      title: AppStrings.DEAL_ALERT_EMPTY,
      subTitle: AppStrings.DEAL_PUNCHLINE,
      titleTextStyle: Theme.of(context).typography.dense.headline5.copyWith(
            color: themeType == ThemeType.light ? Colors.black : Colors.white,
          ),
      subtitleTextStyle: Theme.of(context).typography.dense.bodyText2.copyWith(
            color: themeType == ThemeType.light ? Colors.black : Colors.white,
          ),
      themeType: themeType,
    ),
  );
}
