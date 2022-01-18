import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/blocs/bar_details/get_drinks/get_drinks_cubit.dart';
import 'package:drink/blocs/bar_details/get_tables/get_tables_cubit.dart';
import 'package:drink/blocs/bar_details/get_bites/get_bites_cubit.dart';
import 'package:drink/blocs/bar_details/get_bites/get_bites_cubit.dart'
    as bites;
import 'package:drink/blocs/bar_details/get_drinks/get_drinks_cubit.dart'
    as drinks;

import 'package:drink/blocs/bar_details/get_tables/get_tables_cubit.dart'
    as tables;
import 'package:sizer/sizer.dart';
import 'package:drink/blocs/bar_details/table_reservation/table_reservation_cubit.dart';
import 'package:drink/blocs/bar_details/update_tabbar/update_tabbar_cubit.dart';
import 'package:drink/blocs/cart/cart_cubit.dart';
import 'package:drink/blocs/checkout/checkout/checkout_cubit.dart';
import 'package:drink/blocs/credit_card/bookmark_creditcard/bookmark_creditcard_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/drink.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/models/tables.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/repositories/checkout_repository.dart';
import 'package:drink/repositories/table_repository.dart';
import 'package:drink/screens/checkout/checkout_screen.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/bar_button.dart';
import 'package:drink/widgets/bar_details_appbar.dart';
import 'package:drink/widgets/reservation_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';

GlobalKey barDetailsKey = GlobalKey();

class BarDetailsScreen extends StatefulWidget {
  const BarDetailsScreen({
    Key key,
    this.placeDetails,
    this.currentLocation,
  }) : super(key: key);
  final DPlaceDetails placeDetails;
  final Position currentLocation;

  @override
  _BarDetailsScreenState createState() => _BarDetailsScreenState();
}

class _BarDetailsScreenState extends State<BarDetailsScreen>
    with AutomaticKeepAliveClientMixin<BarDetailsScreen> {
  final List<String> listItems = [];
  ScrollController _scrollController;

  SliverPadding categoryListSliver(
    List<Drink> drinks,
    ThemeState themeState,
    bool isDrink,
  ) {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: 60,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                  height: 45, child: _categoryButtons(themeState, isDrink));
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: drinkListTile(
                  drinks[index - 1],
                  context,
                  themeState.type,
                ),
              );
            }
          },
          childCount: drinks.length + 1,
        ),
      ),
    );
  }

  Widget getBitesSliver(List<Drink> bites, String name, ThemeState themeState) {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: 60,
        left: 8,
        right: 8,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: drinkListTile(bites[index], context, themeState.type),
            );
          },
          childCount: bites.length,
        ),
      ),
    );
  }

  final List<String> _tabs = <String>[
    AppStrings.TABLES,
    AppStrings.DRINKS,
    AppStrings.BITES,
  ];

  final int _sliding = 0;

  PageController _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    _controller.addListener(
      () => context
          .read<UpdateTabbarCubit>()
          .updateTabbar(_controller.page.round()),
    );
    _scrollController = ScrollController();

    super.initState();
  }

  Widget categoryFilterButtons(
    List<Bite> bites,
    ThemeType themeType,
    bool isDrink,
  ) =>
      ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: bites.length,
        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
        separatorBuilder: (context, index) => SizedBox(
          width: 10,
        ),
        itemBuilder: (context, index) => BarButton(
          textSize: 10,
          isDrink: isDrink,
          borderRadius: 12,
          textPadding: 6,
          biteType: bites[index],
          themeType: themeType,
        ),
      );

  Widget _placeDetailsImageSquare(DPlaceDetails placeDetails) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: AppColors.BORDER_YELLOW, width: 0.5),
        ),
        color: Colors.white,
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: placeDetails.images.isNotEmpty
              ? Image.network(
                  placeDetails.images[0].url,
                  cacheHeight: 55,
                  cacheWidth: 55,
                  height: 55,
                  width: 55,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  AssetPaths.PLACE_HOLDER,
                  cacheHeight: 55,
                  cacheWidth: 55,
                  height: 55,
                  width: 55,
                  fit: BoxFit.cover,
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        bottomSheet: Container(
          height: 64,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: themeState.type == ThemeType.light
                      ? AppColors.TEXT_YELLOW
                      : Colors.black,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      AppStrings.INVITE_TEXT,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: themeState.type == ThemeType.light
                                ? Colors.black
                                : Colors.white,
                            size: 12,
                          ),
                          AutoSizeText(
                            AppStrings.INVITE_ALLCAPS,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(80, 22),
                        primary: themeState.type == ThemeType.light
                            ? Colors.white
                            : AppColors.TEXT_YELLOW,
                        shape: StadiumBorder(),
                      ),
                      onPressed: () {
                        final RenderBox box = context.findRenderObject();
                        Share.share(
                          AppStrings.googlePlaceURL(
                            widget.placeDetails.lat,
                            widget.placeDetails.long,
                            15,
                          ),
                          subject: AppStrings.INVITE_TEXT,
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size,
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: themeState.type == ThemeType.light
              ? backGroundImgDecorationLight
              : backGroundImgDecoration,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverPersistentHeader(
                      delegate: BarDetalsAppBar(
                        expandedHeight: shortestSide > 600 ? 53.h : 60.h,
                        placeDetails: widget.placeDetails,
                        currentLocation: widget.currentLocation,
                      ),
                      pinned: true,
                    ),
                  ),
                ),
              ];
            },
            body: BlocListener<UpdateTabbarCubit, int>(
              listener: (context, state) {
                _controller.jumpToPage(state);
              },
              child: PageView(
                physics: BouncingScrollPhysics(),
                controller: _controller,
                children: _tabs.map((String name) {
                  return Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        key: PageStorageKey<String>(name),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            // This is the flip side of the SliverOverlapAbsorber above.
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(0.0),
                            sliver: name == AppStrings.DRINKS
                                ? BlocConsumer<GetDrinksCubit, GetDrinksState>(
                                    listener: (context, state) {
                                      if (state is GetDrinksError) {
                                        if (state.message != 'success') {
                                          AppNavigation.showToast(
                                              message: state.message);
                                        }
                                      } else if (state
                                          is drinks.UnAuthenticated) {
                                        Navigator.of(context).pop();
                                        context
                                            .read<AuthenticationRepository>()
                                            .signOut();
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is GetDrinksInitial) {
                                        context
                                            .read<GetDrinksCubit>()
                                            .getFirstCategoryFirst(
                                              widget.placeDetails.id,
                                              widget.placeDetails.categories
                                                  .drinks,
                                            );
                                        return SliverToBoxAdapter(
                                          child: Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        AppColors
                                                            .CIRCLE_YELLOW),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (state is GetDrinkLoading) {
                                        return SliverToBoxAdapter(
                                          child: Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        AppColors
                                                            .CIRCLE_YELLOW),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (state is GetDrinksCompleted) {
                                        return categoryListSliver(
                                            state.drinks, themeState, true);
                                      } else if (state is GetDrinksError) {
                                        return SliverToBoxAdapter(
                                          child: Center(
                                            child: Text(
                                              state.message,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SliverToBoxAdapter(
                                          child: Center(
                                            child: Text(
                                              AppStrings.SOMETHING_WENT_WRONG,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : name == AppStrings.TABLES
                                    ? BlocConsumer<GetTablesCubit,
                                        GetTablesState>(
                                        listener: (context, state) {
                                          if (state is GetTablesError) {
                                            if (state.message != 'success') {
                                              AppNavigation.showToast(
                                                  message: state.message);
                                            }
                                          } else if (state
                                              is tables.UnAuthenticated) {
                                            Navigator.of(context).pop();
                                            context
                                                .read<
                                                    AuthenticationRepository>()
                                                .signOut();
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state is GetTablesInitial) {
                                            Future.delayed(Duration.zero, () {
                                              context
                                                  .read<GetTablesCubit>()
                                                  .getAllTables(
                                                      widget.placeDetails.id,
                                                      1);
                                            });
                                            return SliverToBoxAdapter(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      24.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            AppColors
                                                                .CIRCLE_YELLOW),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (state
                                              is GetTablesLoading) {
                                            return SliverToBoxAdapter(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      24.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            AppColors
                                                                .CIRCLE_YELLOW),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (state
                                              is GetTablesCompleted) {
                                            return SliverPadding(
                                              padding: EdgeInsets.only(
                                                bottom: 60,
                                                left: 8,
                                                right: 8,
                                              ),
                                              sliver: SliverList(
                                                delegate:
                                                    SliverChildBuilderDelegate(
                                                  (BuildContext context,
                                                      int index) {
                                                    return _tableListTile(
                                                      state.allTables[index],
                                                      themeState.type,
                                                    );
                                                  },
                                                  childCount:
                                                      state.allTables.length,
                                                ),
                                              ),
                                            );
                                          } else if (state is GetTablesError) {
                                            return SliverToBoxAdapter(
                                              child: Center(
                                                child: Text(
                                                  state.message,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return SliverToBoxAdapter(
                                              child: Center(
                                                child: Text(
                                                  AppStrings
                                                      .SOMETHING_WENT_WRONG,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : BlocConsumer<GetBitesCubit,
                                        GetBitesState>(
                                        listener: (context, state) {
                                          if (state is GetBitesInitial) {
                                          } else if (state is GetBitesError) {
                                            if (state.message != 'success') {
                                              AppNavigation.showToast(
                                                  message: state.message);
                                            }
                                          } else if (state
                                              is bites.UnAuthenticated) {
                                            Navigator.of(context).pop();
                                            context
                                                .read<
                                                    AuthenticationRepository>()
                                                .signOut();
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state is GetBitesInitial) {
                                            Future.delayed(Duration.zero, () {
                                              context
                                                  .read<GetBitesCubit>()
                                                  .getAllBites(
                                                      widget.placeDetails.id,
                                                      widget.placeDetails
                                                          .categories.bites);
                                            });
                                            return SliverToBoxAdapter(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      24.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            AppColors
                                                                .CIRCLE_YELLOW),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (state is GetDrinkLoading) {
                                            return SliverToBoxAdapter(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          } else if (state
                                              is GetBitesCompleted) {
                                            return categoryListSliver(
                                                state.bites, themeState, false);
                                          } else if (state is GetBitesError) {
                                            return SliverToBoxAdapter(
                                              child: Center(
                                                child: Text(
                                                  state.message,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return SliverToBoxAdapter(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      24.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                      AppColors.CIRCLE_YELLOW,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _categoryButtons(ThemeState themeState, bool isDrink) {
    return categoryFilterButtons(
      isDrink
          ? widget.placeDetails.categories.drinks
          : widget.placeDetails.categories.bites,
      themeState.type,
      isDrink,
    );
  }

  Widget dateSelection(Tables table) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return BlocConsumer<TableReservationCubit, TableReservationState>(
      listener: (context, state) {
        if (state.isFailure) {
          _reservationController.clear();
          AppNavigation.showDialogGeneral(
            context,
            GeneralAlertDialog(
              message: state.message,
            ),
          );
        } else if (state.isLoaded) {
          AppNavigation.showDialogGeneral(
            context,
            GeneralAlertDialog(
              message: state.message,
            ),
          );
        } else if (state.isUnAuthenticated ?? false) {
          Navigator.of(context).pop();
          context.read<AuthenticationRepository>().signOut();
        } else if (state.showTimePicker ?? false) {
          _showDatePicker(context).then((selectedDate) {
            context
                .read<TableReservationCubit>()
                .updateDateTimeAndTableID(table.id, selectedDate);
            if (selectedDate != null) {
              AppNavigation.animatedNavigation(
                context,
                MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                        value: context.read<TableReservationCubit>()),
                    BlocProvider<CheckoutCubit>(
                      create: (context) => CheckoutCubit(CheckoutRepository())
                        ..isTableReservation = true,
                    ),
                    BlocProvider<BookmarkCreditcardCubit>(
                      create: (context) => BookmarkCreditcardCubit(),
                    ),
                  ],
                  child: CheckoutScreen(
                    isTableReservation: true,
                    total: table.price.toDouble(),
                  ),
                ),
              );
            } else {
              context.read<TableReservationCubit>().noDateSelected();
            }
          });
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Container(
            height: 30,
            padding: EdgeInsets.all(4.0),
            child: FittedBox(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(AppColors.CIRCLE_YELLOW),
                ),
              ),
            ),
          );
        } else {
          return ElevatedButton(
            child: AutoSizeText(
              AppStrings.RESERVE,
              minFontSize: 10,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0),
              minimumSize: Size(
                  shortestSide < 600
                      ? 60
                      : MediaQuery.of(context).size.width * 0.1,
                  22),
              primary: AppColors.TEXT_YELLOW,
              shape: StadiumBorder(),
            ),
            onPressed: () => context.read<TableReservationCubit>().showPicker(),
          );
        }
      },
    );
  }

  Widget _tableListTile(
    Tables table,
    ThemeType themeType,
  ) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    return BlocProvider<TableReservationCubit>(
      create: (_) => TableReservationCubit(TableRepository())
        ..getPreselectedDate(table.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 6.0,
          ),
          decoration: ShapeDecoration(
            shadows: themeType == ThemeType.light
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]
                : [],
            color: themeType == ThemeType.light ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: themeType == ThemeType.light
                    ? Colors.white
                    : AppColors.LIGHT_GREY,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(table.picture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: shortestSide < 600 ? 37 : 41,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      table.tableName,
                      style: TextStyle(
                        color: AppColors.TEXT_YELLOW,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    AutoSizeText(
                      AppStrings.FOR +
                          ' ${table.seatingCapacity} ' +
                          AppStrings.PERSONS,
                      minFontSize: 12,
                      style: TextStyle(
                        color: themeType == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    AutoSizeText(
                      table.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      style: TextStyle(
                        color: themeType == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      '\$  ${table.price}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.TEXT_YELLOW,
                      ),
                    ),
                    dateSelection(table),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime _reservation;
  TimeOfDay _reservationTime;
  final FocusNode _reservationFocus = FocusNode();
  final TextEditingController _reservationController = TextEditingController();
  Future<DateTime> _showDatePicker(BuildContext context) async {
    final Completer<DateTime> _dateCompleter = Completer<DateTime>();

    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: _reservation ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 200),
      ),
    );
    if (pickedDate != null) {
      final TimeOfDay timeOfDate = await showTimePicker(
        context: context,
        initialTime: _reservationTime ?? TimeOfDay.now(),
      );
      if (timeOfDate != null) {
        setState(() {
          _reservationTime = timeOfDate;
          print(_reservationTime.toString());
        });
        final DateTime _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            timeOfDate.hour,
            timeOfDate.minute);
        _dateCompleter.complete(_selectedDateTime);

        return _dateCompleter.future;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  void updateKeepAlive() {}

  @override
  bool get wantKeepAlive => true;
}

Widget drinkListTile(
  Drink drink,
  BuildContext context,
  ThemeType themeType,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
    child: Container(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
      decoration: ShapeDecoration(
        color: themeType == ThemeType.light ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: themeType == ThemeType.light
                ? Colors.white
                : AppColors.LIGHT_GREY,
          ),
        ),
        shadows: themeType == ThemeType.light
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
      child: FittedBox(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        6,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(drink.picture),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.54,
                        ),
                        child: AutoSizeText(
                          drink.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.TEXT_YELLOW,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      AutoSizeText(
                        drink.category,
                        minFontSize: 12,
                        style: TextStyle(
                          color: themeType == ThemeType.light
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.58,
                        child: AutoSizeText(
                          drink.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          minFontSize: 10,
                          style: TextStyle(
                            color: themeType == ThemeType.light
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  AutoSizeText(
                    '\$ ' + drink.price,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.TEXT_YELLOW,
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.bottomCenter,
                    onPressed: () =>
                        context.read<CartCubit>().addProduct(drink),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.CIRCLE_YELLOW,
                      ),
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    ),
  );
}
