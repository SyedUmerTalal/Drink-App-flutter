import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/blocs/bar_details/get_bites/get_bites_cubit.dart';
import 'package:drink/blocs/bar_details/get_drinks/get_drinks_cubit.dart';
import 'package:drink/blocs/bar_details/get_tables/get_tables_cubit.dart';
import 'package:drink/blocs/bar_details/update_tabbar/update_tabbar_cubit.dart';
import 'package:drink/blocs/cart/cart_cubit.dart';
import 'package:drink/blocs/deal_alert/deal_alert_bloc.dart';
import 'package:drink/blocs/deal_alert/deal_alert_event.dart';
import 'package:drink/blocs/deal_alert/deal_alert_model.dart';
import 'package:drink/blocs/deal_alert/deal_alert_state.dart';
import 'package:drink/blocs/home/bottom_sheet/bottom_sheet_cubit.dart';
import 'package:drink/blocs/home/cluster/cluster_cubit.dart';
import 'package:drink/blocs/home/google_maps/google_maps_bloc.dart';
import 'package:drink/blocs/home/location/location_bloc.dart';
import 'package:drink/blocs/home/map_cluster/map_cluster_cubit.dart';
import 'package:drink/blocs/home/search_dropdown/search_dropdown_bloc.dart';
import 'package:drink/blocs/home/update_circle/update_circle_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/bottom_sheet.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/repositories/google_places_repository.dart';
import 'package:drink/repositories/map_repository.dart';
import 'package:drink/repositories/place_repository.dart';
import 'package:drink/repositories/table_repository.dart';
import 'package:drink/screens/bar_details/bar_details_screen.dart';
import 'package:drink/screens/cart/cart_screen.dart';
import 'package:drink/screens/deals/deals_alert_screen.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/deal_alert_dialog.dart';
import 'package:drink/widgets/drawer.dart';
import 'package:drink/widgets/search_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'dart:developer';

GlobalKey _key = GlobalKey();

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpdateCircleCubit>(
            lazy: false, create: (_) => UpdateCircleCubit()),
        BlocProvider<LocationBloc>(
          lazy: false,
          create: (_) => LocationBloc()..add(LocationStarted()),
        ),
        BlocProvider<BottomSheetCubit>(
          lazy: false,
          create: (_) => BottomSheetCubit(),
        ),
        BlocProvider<SearchDropdownBloc>(
          lazy: false,
          create: (_) => SearchDropdownBloc(
            placesRepository: GooglePlacesRepository(),
          ),
        ),
        BlocProvider<ClusterCubit>(
          create: (context) => ClusterCubit(
            updateRadiusCubit: _key.currentContext.read<UpdateCircleCubit>(),
            mapRepository: MapRepository(),
            locationBloc: _key.currentContext.read<LocationBloc>(),
          ),
        ),
        BlocProvider<MapsClusterCubit>(
          create: (context) => MapsClusterCubit(
            _key.currentContext.read<SearchDropdownBloc>(),
            _key.currentContext.read<ClusterCubit>(),
          ),
        ),
      ],
      child: Home(
        key: _key,
      ),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _placesController = TextEditingController();
  final FocusNode _locationFocus = FocusNode();
  GoogleMapController mapController;
  final GlobalKey _sliderKey = GlobalKey();
  BottomSheetCubit _bottomSheetCubit;
  Position position;
  bool keyboardVisibility = false;
  List<DealAlertModel> _alert_list = [];
  int alertsCount = 0;

  Widget get buildCenterLoading => Container(
        color: Colors.white,
        child: Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColors.CIRCLE_YELLOW),
        )),
      );

  Future<void> _goToMyLocation(
      Position position, UpdateCircleCubit updateCircleCubit) async {
    CameraPosition _currentCameraPosition = CameraPosition(
      bearing: 20,
      target: LatLng(position.latitude, position.longitude),
      tilt: 0,
      zoom: getZoomLevel(updateCircleCubit.state.radius),
    );
    updateCircleCubit.updateCenter(
      LatLng(position.latitude, position.longitude),
    );
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
    _bottomSheetCubit.hideBottomInfoSheet();
  }

  Future<void> getMapsBackground(
      BuildContext context, ThemeType themeType) async {
    final String string = await DefaultAssetBundle.of(context).loadString(
      themeType == ThemeType.light
          ? AssetPaths.MAP_STYLE_LIGHT
          : AssetPaths.MAP_STYLE,
    );
    mapController.setMapStyle(string);
  }

  @override
  Widget build(BuildContext context) {
    String controllerText = '';
    bool textChangedCheck(String text) {
      if (controllerText != text) {
        controllerText = text;
        return true;
      } else {
        return false;
      }
    }

    void textChanged() {
      if (position != null) {
        if (_locationFocus.hasFocus) {
          if (textChangedCheck(_placesController.text)) {
            context.read<SearchDropdownBloc>().add(
                  SearchInputChanged(
                    _placesController.text,
                    position,
                  ),
                );
          }
        }
      }
    }

    _placesController.addListener(textChanged);
    _bottomSheetCubit = context.read<BottomSheetCubit>();

    loadDeals() {
      BlocProvider.of<DealAlertBloc>(context)
          .add(DealAlertEvents.fetchDealAlert);
    }

    void fetchAllPoints(
      BuildContext context,
      Position currentPosition,
    ) {
      print('Fetch All Points');
      Future.delayed(Duration.zero, () {
        context.read<ClusterCubit>().fetchAllPoints(currentPosition);
      });
    }

    return BlocConsumer<ThemeBloc, ThemeState>(
      listener: (context, state) {
        getMapsBackground(context, state.type);
        loadDeals();
      },
      builder: (context, themeState) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          drawer: Drawer(
            child: SafeArea(
              child: CustomDrawer(
                screenName: AppStrings.HOME_SCREEN,
              ),
            ),
          ),
          appBar: customAppBar(context, themeState.type),
          body: BlocConsumer<LocationBloc, LocationState>(
            listener: (context, locationState) {
              // debugger();
              if (locationState is LocationLoadSuccess) {
                context.read<UpdateCircleCubit>().updateCenter(
                      LatLng(
                        locationState.position.latitude,
                        locationState.position.longitude,
                      ),
                    );
                fetchAllPoints(context, locationState.position);
              }
            },
            builder: (context, locationState) {
              if (locationState is LocationLoadInProgress) {
                return buildCenterLoading;
              } else if (locationState is LocationLoadSuccess) {
                position = locationState.position;
                // debugger();
                loadDeals();
                return BlocBuilder<ClusterCubit, ClusterState>(
                  buildWhen: (currentState, nextState) =>
                      currentState.placeDetailsResponse !=
                      nextState.placeDetailsResponse,
                  builder: (context, state) {
                    return BlocProvider<GoogleMapsBloc>(
                      create: (_) => GoogleMapsBloc(
                        themeType: context.read<ThemeBloc>().state.type,
                        currentLocation: locationState.position,
                        mapsClusterCubit: context.read<MapsClusterCubit>(),
                      ),
                      child: BlocConsumer<UpdateCircleCubit, UpdateCircleState>(
                        listener: (context, circleState) {
                          // debugger();
                          final CameraPosition userLocationCameraPosition =
                              CameraPosition(
                            target: LatLng(
                              circleState.center.latitude,
                              circleState.center.longitude,
                            ),
                            zoom: getZoomLevel(circleState.radius),
                          );
                          mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              userLocationCameraPosition,
                            ),
                          );
                        },
                        builder: (context, updateCircleState) => Stack(
                          alignment: Alignment.center,
                          children: [
                            googleMapWidget(
                              state.placeDetailsResponse,
                              locationState.position,
                              updateCircleState,
                              themeState,
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  _goToMyLocation(
                                    position,
                                    context.read<UpdateCircleCubit>(),
                                  );
                                },
                                child: ClipOval(
                                  child: Material(
                                    color:
                                        AppColors.CIRCLE_YELLOW, // button color
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ImageIcon(
                                            AssetImage(
                                                AssetPaths.LOCATION_ICON),
                                            color: Colors.white,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                child: updateCustomBottomSheet(context))
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }

  Widget dealAlertNotification({@required List<DealAlertModel> list}) {
    alertsCount = 0;
    list.forEach((element) {
      if (element.is_read == 0) {
        alertsCount++;
      }
    });
    return alertsCount == 0
        ? Container()
        : Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.CIRCLE_YELLOW,
            ),
            child: FittedBox(
              child: AutoSizeText(
                '$alertsCount',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }

  Widget googleMapWidget(
    List<DPlaceDetails> clusters,
    Position currentPosition,
    UpdateCircleState updateCircleState,
    ThemeState themeState,
  ) {
    return BlocConsumer<GoogleMapsBloc, GoogleMapsState>(
      listener: (context, state) {
        if (state.selectedPlace != null && !state.clearOnMove) {
          mapController.getZoomLevel().then((zoom) => mapController
                  .animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    // target: LatLng(double.parse(state.selectedPlace.lat),
                    target: LatLng(
                        AppStrings.doubleParse(state.selectedPlace.lat),
                        AppStrings.doubleParse(state.selectedPlace.long)),
                    zoom: zoom,
                  ),
                ),
              )
                  .whenComplete(() {
                print('Camera move action done');
                context.read<GoogleMapsBloc>().add(EnableCameraMoveAction());
              }));
        }
      },
      builder: (context, state) {
        Future<void> _onMapCreated(
          GoogleMapController controller,
          ThemeType themeType,
        ) async {
          final String string = await DefaultAssetBundle.of(context).loadString(
            themeType == ThemeType.light
                ? AssetPaths.MAP_STYLE_LIGHT
                : AssetPaths.MAP_STYLE,
          );
          mapController = controller;
          mapController.setMapStyle(string);
        }

        return GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onCameraMoveStarted: () {
              if (state.clearOnMove) {
                _bottomSheetCubit.hideBottomInfoSheet();
                context.read<GoogleMapsBloc>().add(GetMarkerColorBack());
              }
            },
            onTap: (value) {
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

              if (state.selectedPlace != null && state.clearOnMove) {
                _bottomSheetCubit.hideBottomInfoSheet();
                context.read<GoogleMapsBloc>().add(GetMarkerColorBack());
              }
            },
            zoomControlsEnabled: false,
            compassEnabled: false,
            markers: state.markers,
            circles: updateCircleState.center != null
                ? {
                    Circle(
                      circleId: CircleId('mainCircle'),
                      strokeColor: AppColors.CIRCLE_YELLOW,
                      center: updateCircleState.center,
                      radius: 1609.34 * updateCircleState.radius,
                      strokeWidth: 1,
                    )
                  }
                : {},
            initialCameraPosition: CameraPosition(
              bearing: 20,
              target: LatLng(
                state.currentPosition?.latitude,
                state.currentPosition.longitude,
              ),
              tilt: 0,
              zoom: getZoomLevel(1),
            ),
            onCameraMove: (position) {
              context.read<MapsClusterCubit>().updateMarkers(position.zoom);
            },
            onMapCreated: (controller) async {
              await _onMapCreated(controller, themeState.type);
              context.read<MapsClusterCubit>().initMapController(
                  controller,
                  clusters,
                  _bottomSheetCubit,
                  context.read<GoogleMapsBloc>(),
                  context.read<ThemeBloc>().state.type,
                  context.read<SearchDropdownBloc>(),
                  context);
            });
      },
    );
  }

  Widget updateCustomBottomSheet(BuildContext context) {
    return BlocBuilder<BottomSheetCubit, BottomInfoSheet>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          child: state.placeDetails != null
              ? bottomSheetCustom(context, state.placeDetails, position)
              : SizedBox.shrink(),
        );
      },
    );
  }

  double _calculateDistanceBetween(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    double distance =
        Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
    distance = (distance / 1000) * 0.621371;
    return distance;
  }

  Widget _placeDetailsImageSquare(
      DPlaceDetails placeDetails, BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

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
                  height: shortestSide < 600
                      ? 55
                      : MediaQuery.of(context).size.height * 0.3,
                  width: 55,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  AssetPaths.PLACE_HOLDER,
                  cacheHeight: 55,
                  cacheWidth: 55,
                  height: shortestSide < 600
                      ? 55
                      : MediaQuery.of(context).size.height * 0.3,
                  width: 55,
                  fit: BoxFit.cover,
                )),
    );
  }

  Widget bottomSheetCustom(BuildContext context, DPlaceDetails placeDetails,
      Position currentLocation) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return InkWell(
          onTap: () => AppNavigation.navigateTo(
              context,
              MultiBlocProvider(
                providers: [
                  BlocProvider<UpdateTabbarCubit>(
                    create: (_) => UpdateTabbarCubit(),
                  ),
                  BlocProvider<GetDrinksCubit>(
                      create: (_) =>
                          GetDrinksCubit(placeRepository: PlaceRepository())),
                  BlocProvider<GetTablesCubit>(
                      create: (_) => GetTablesCubit(TableRepository())),
                  BlocProvider<GetBitesCubit>(
                    create: (_) =>
                        GetBitesCubit(placeRepository: PlaceRepository()),
                  ),
                ],
                child: BarDetailsScreen(
                  key: barDetailsKey,
                  placeDetails: placeDetails,
                  currentLocation: currentLocation,
                ),
              )),
          child: Container(
            height: placeDetails.name.length > 16 ? 147 : 140,
            width: MediaQuery.of(context).size.width,
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))),
            child: Column(
              children: [
                Expanded(
                  flex: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeState.type == ThemeType.light
                          ? Colors.white
                          : AppColors.DARK_GREY,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)),
                      boxShadow: themeState.type == ThemeType.light
                          ? [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ]
                          : [],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 5,
                              child: _placeDetailsImageSquare(
                                  placeDetails, context)),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 11,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  placeDetails.name,
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: themeState.type == ThemeType.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: themeState.type == ThemeType.light
                                          ? AppColors.TEXT_YELLOW
                                          : Colors.white,
                                      size: 12,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    AutoSizeText(
                                      placeDetails.address,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            themeState.type == ThemeType.light
                                                ? Colors.black
                                                : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.road,
                                      color: themeState.type == ThemeType.light
                                          ? AppColors.TEXT_YELLOW
                                          : Colors.white,
                                      size: 12,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    AutoSizeText(
                                      _calculateDistanceBetween(
                                                  currentLocation.latitude,
                                                  currentLocation.longitude,
                                                  // double.parse(placeDetails.lat),
                                                  // double.parse(placeDetails.long))
                                                  AppStrings.doubleParse(
                                                      placeDetails.lat),
                                                  AppStrings.doubleParse(
                                                      placeDetails.long))
                                              .toStringAsFixed(2) +
                                          AppStrings.SPACE +
                                          AppStrings.MILES_AWAY,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              themeState.type == ThemeType.light
                                                  ? Colors.black
                                                  : Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            child: Text(AppStrings.OUR_MENU),
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(80, 20),
                              textStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              primary: themeState.type == ThemeType.light
                                  ? Colors.black
                                  : Colors.white,
                              side: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: AppColors.CIRCLE_YELLOW,
                              ),
                              shape: StadiumBorder(),
                            ),
                            onPressed: () => AppNavigation.navigateTo(
                                context,
                                MultiBlocProvider(
                                  providers: [
                                    BlocProvider<UpdateTabbarCubit>(
                                      create: (_) => UpdateTabbarCubit(),
                                    ),
                                    BlocProvider<GetDrinksCubit>(
                                        create: (_) => GetDrinksCubit(
                                            placeRepository:
                                                PlaceRepository())),
                                    BlocProvider<GetTablesCubit>(
                                        create: (_) =>
                                            GetTablesCubit(TableRepository())),
                                    BlocProvider<GetBitesCubit>(
                                      create: (_) => GetBitesCubit(
                                          placeRepository: PlaceRepository()),
                                    ),
                                  ],
                                  child: BarDetailsScreen(
                                    key: barDetailsKey,
                                    placeDetails: placeDetails,
                                    currentLocation: currentLocation,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: themeState.type == ThemeType.light
                          ? AppColors.TEXT_YELLOW
                          : Colors.black,
                      // borderRadius: BorderRadius.only(
                      //     bottomLeft: Radius.circular(8.0),
                      //     bottomRight: Radius.circular(8.0)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 15,
                          child: Text(
                            AppStrings.INVITE_TEXT,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
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
                              Text(
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
                                    placeDetails.lat, placeDetails.long, 15),
                                subject: AppStrings.INVITE_TEXT,
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size);
                          },
                        ),

                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget customAppBar(BuildContext context, ThemeType themeType) {
    loadDeals() {
      BlocProvider.of<DealAlertBloc>(context)
          .add(DealAlertEvents.fetchDealAlert);
    }

    return PreferredSize(
      // key: _textFieldKey,
      preferredSize: Size.fromHeight(
        kToolbarHeight + 120,
      ),
      child: GestureDetector(
        onTap: () =>
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
        child: Container(
          decoration: BoxDecoration(
            color: themeType == ThemeType.light ? Colors.white : Colors.black,
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
          child: Column(
            children: [
              AppBar(
                elevation: themeType == ThemeType.light ? 0 : 16,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: themeType == ThemeType.light
                        ? Colors.black
                        : Colors.white,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openDrawer(),
                ),
                title: AutoSizeText(
                  AppStrings.HOME,
                  style: TextStyle(
                    color: themeType == ThemeType.light
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                actions: [
                  IconButton(
                    iconSize: 20,
                    icon: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topRight,
                      children: [
                        Icon(
                          FontAwesomeIcons.solidBell,
                          color: themeType == ThemeType.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        Positioned(
                          right: -10,
                          top: -10,
                          child: BlocConsumer<DealAlertBloc, DealAlertState>(
                            listener: (context, circleState) {
                              if (BlocProvider.of<DealAlertBloc>(context)
                                      .currentState ==
                                  true) {
                                // debugger();
                                final bool show = SharedPref
                                    .instance.sharedPreferences
                                    .getBool('ShowDealAlert');
                                if ((show ?? true) && alertsCount > 0) {
                                  SharedPref.instance.sharedPreferences
                                      .setBool('ShowDealAlert', false);
                                  AppNavigation.showDialogGeneral(
                                      context,
                                      DealAlertDialog(
                                        message: 'You have ' +
                                            alertsCount.toString() +
                                            ' Deals',
                                      )).then((result) {
                                    if (result) {
                                      AppNavigation.navigateTo(
                                              context,
                                              DealsAlertScreen(
                                                  dealAlertList: _alert_list))
                                          .whenComplete(() {
                                        print('Deal update');
                                        loadDeals();
                                      });
                                    }
                                  });
                                }
                              }
                            },
                            builder: (context, state) {
                              // debugger();
                              if (state is PostLoadedState) {
                                _alert_list = state.dealalert ?? [];
                                return dealAlertNotification(list: _alert_list);
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      AppNavigation.navigateTo(context,
                              DealsAlertScreen(dealAlertList: _alert_list))
                          .whenComplete(() {
                        print('Deal update');
                        loadDeals();
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 20,
                    icon: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topRight,
                      children: [
                        Icon(
                          FontAwesomeIcons.shoppingCart,
                          color: themeType == ThemeType.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        Positioned(
                          right: -10,
                          top: -10,
                          child: BlocBuilder<CartCubit, CartState>(
                            builder: (context, state) {
                              return Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.CIRCLE_YELLOW,
                                ),
                                child: FittedBox(
                                  child: AutoSizeText(
                                    state.products.isNotEmpty
                                        ? state.products
                                            .map((item) => item.qty)
                                            .reduce(
                                                (sum, element) => sum + element)
                                            .toString()
                                        : '0',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      AppNavigation.navigateTo(context, CartScreen());
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  height: 32,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: BlocBuilder<LocationBloc, LocationState>(
                    builder: (context, state) {
                      if (state is LocationLoadSuccess) {
                        return BlocListener<SearchDropdownBloc,
                            SearchDropdownState>(
                          listenWhen: (oldState, newState) =>
                              oldState.selectedPlace != newState.selectedPlace,
                          listener: (context, searchState) {
                            if (searchState.selectedPlace != null) {
                              context
                                  .read<ClusterCubit>()
                                  .getSpecificCoordinates(
                                    searchState.selectedPlace,
                                    state.position,
                                  );
                            }
                          },
                          child: SearchTextField(
                            placesController: _placesController,
                            locationFocus: _locationFocus,
                            position: state.position,
                            themeType: themeType,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      AppStrings.ONE_MILE,
                      style: TextStyle(
                        color: themeType == ThemeType.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Expanded(
                    child: circleSlider(themeType),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Text(
                      AppStrings.TEN_MILE,
                      style: TextStyle(
                          color: themeType == ThemeType.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 10),
                    ),
                  )
                ],
              ),
              SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Widget circleSlider(ThemeType themeType) {
    return BlocBuilder<UpdateCircleCubit, UpdateCircleState>(
      builder: (context, state) {
        return FlutterSlider(
          key: _sliderKey,
          values: [state.radius],
          max: 10,
          min: 1,
          selectByTap: true,
          step: FlutterSliderStep(
            step: 0.01,
          ),
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 1.5,
            inactiveTrackBarHeight: 1,
            activeTrackBar: BoxDecoration(
              color: AppColors.TEXT_YELLOW,
            ),
            inactiveTrackBar: BoxDecoration(
              color: themeType == ThemeType.light ? Colors.black : Colors.white,
            ),
          ),
          tooltip: FlutterSliderTooltip(
            textStyle: TextStyle(fontSize: 10, color: Colors.white),
            boxStyle: FlutterSliderTooltipBox(
              decoration: BoxDecoration(color: AppColors.TEXT_YELLOW),
            ),
          ),
          hatchMark: FlutterSliderHatchMark(
            disabled: true,
          ),
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(color: Colors.transparent),
            child: ImageIcon(
              AssetImage(
                AssetPaths.DISTANCE_ARROW_ICON,
              ),
              size: 12,
              color: AppColors.TEXT_YELLOW,
            ),
          ),
          onDragCompleted: (handlerIndex, lowerValue, upperValue) {
            context.read<UpdateCircleCubit>().updateRadius(lowerValue);
          },
        );
      },
    );
  }
}
