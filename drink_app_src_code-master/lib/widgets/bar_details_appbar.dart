import 'dart:io' show Platform;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:drink/blocs/bar_details/update_tabbar/update_tabbar_cubit.dart';
import 'package:drink/blocs/cart/cart_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/screens/cart/cart_screen.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class BarDetalsAppBar extends SliverPersistentHeaderDelegate {
  BarDetalsAppBar({
    @required this.expandedHeight,
    @required this.placeDetails,
    @required this.currentLocation,
  });
  final double expandedHeight;
  final DPlaceDetails placeDetails;
  final Position currentLocation;
  bool buttonEnabled = true;
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

  Widget barOfferings(
      {String icon,
      String title,
      int value,
      int currentValue,
      ThemeState themeState,
      BuildContext context}) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    return Container(
      width: shortestSide > 600
          ? MediaQuery.of(context).size.width * 0.2
          : MediaQuery.of(context).size.width * 0.255,
      height: 47,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Spacer(),
          ImageIcon(
            AssetImage(icon),
            color: currentValue == value ? Colors.black : Colors.white,
            size: 14,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
              color: currentValue == value ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double height =
        inverseLerp(180, expandedHeight, expandedHeight - shrinkOffset)
                .isNegative
            ? 0
            : inverseLerp(180, expandedHeight, expandedHeight - shrinkOffset);
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height:
                  (expandedHeight - shrinkOffset).clamp(180.0, expandedHeight),
              decoration: themeState.type == ThemeType.light
                  ? backGroundImgDecorationLight
                  : backGroundImgDecoration,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      title: AutoSizeText(
                        placeDetails.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeState.type == ThemeType.light
                              ? Colors.black
                              : Colors.white,
                        ),
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
                          AppNavigation.navigatorPop(context);
                        },
                      ),
                      actions: [
                        IconButton(
                          iconSize: 20,
                          icon: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topRight,
                            children: [
                              Icon(
                                FontAwesomeIcons.shoppingCart,
                                color: themeState.type == ThemeType.light
                                    ? Colors.black
                                    : Colors.white,
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
                                        child: Text(
                                          state.products.isNotEmpty
                                              ? state.products
                                                  .map((item) => item.qty)
                                                  .reduce((sum, element) =>
                                                      sum + element)
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
                        )
                      ],
                    ),
                    placeDetails.images.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: height *
                                (shortestSide < 600
                                    ? MediaQuery.of(context).size.height *
                                        0.2304
                                    : MediaQuery.of(context).size.height *
                                        0.28),
                            child: CaroselSliderWidget(
                              imagesURL: placeDetails.images,
                            ))
                        : SizedBox.shrink(),
                    SizedBox(
                      height:
                          height * MediaQuery.of(context).size.height * 0.0128,
                    ),
                    Opacity(
                      opacity: height,
                      child: Container(
                        height: height *
                            (MediaQuery.of(context).size.height * 0.1024),
                        child: FittedBox(
                          child: Column(
                            children: [
                              Text(
                                placeDetails.name,
                                style: TextStyle(
                                  color: AppColors.TEXT_YELLOW,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                placeDetails.address,
                                style: TextStyle(
                                  color: themeState.type == ThemeType.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                _calculateDistanceBetween(
                                            currentLocation.latitude,
                                            currentLocation.longitude,
                                            // double.parse(placeDetails.lat),
                                            // double.parse(placeDetails.long)
                                            AppStrings.doubleParse(
                                                placeDetails.lat),
                                            AppStrings.doubleParse(
                                                placeDetails.long))
                                        .toStringAsFixed(2) +
                                    AppStrings.SPACE +
                                    AppStrings.MILES_AWAY,
                                style: TextStyle(
                                    color: themeState.type == ThemeType.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:
                          height * MediaQuery.of(context).size.height * 0.0128,
                    ),
                    BlocBuilder<UpdateTabbarCubit, int>(
                      builder: (context, state) {
                        return CupertinoSlidingSegmentedControl(
                          padding: EdgeInsets.zero,
                          backgroundColor: AppColors.BORDER_YELLOW,
                          thumbColor: Colors.white,
                          children: {
                            0: barOfferings(
                              icon: AssetPaths.TABLE,
                              title: AppStrings.TABLES,
                              value: 0,
                              currentValue: state,
                              themeState: themeState,
                              context: context,
                            ),
                            1: barOfferings(
                              icon: AssetPaths.DRINK,
                              title: AppStrings.DRINKS,
                              value: 1,
                              currentValue: state,
                              themeState: themeState,
                              context: context,
                            ),
                            2: barOfferings(
                              icon: AssetPaths.BITES,
                              title: AppStrings.BITES,
                              value: 2,
                              currentValue: state,
                              themeState: themeState,
                              context: context,
                            )
                          },
                          groupValue: state,
                          onValueChanged: (newValue) => context
                              .read<UpdateTabbarCubit>()
                              .updateTabbar(newValue),
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0128,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
        ;
      },
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 180;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class CaroselSliderWidget extends StatefulWidget {
  const CaroselSliderWidget({
    Key key,
    @required this.imagesURL,
  }) : super(key: key);
  final List<PlaceImage> imagesURL;

  @override
  _CaroselSliderWidgetState createState() => _CaroselSliderWidgetState();
}

class _CaroselSliderWidgetState extends State<CaroselSliderWidget> {
  int _current = 0;

  double x = 0;
  double y = 0;
  double z = 0;
  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    return CarouselSlider.builder(
      itemCount: widget.imagesURL.length,
      itemBuilder: (context, index) => carouselImage(index, context, _current),

      options: CarouselOptions(
        height: shortestSide < 600
            ? 200
            : MediaQuery.of(context).size.height * 0.28,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        initialPage: (widget.imagesURL.length / 2).round(),
        viewportFraction: 0.5,
        autoPlay: true,
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),

      // itemCount: 6,
      // itemBuilder: (context, int index) {
      //   return _returnImage(index);
      // },
    );
  }

  Widget carouselImage(int current, BuildContext context, int currentIndex) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    // final Matrix4 pvMatrix = current < currentIndex
    //     ? (Matrix4.identity()
    //       ..setEntry(3, 3, 1 / 0.9)
    //       ..setEntry(1, 1, 0.5)
    //       ..setEntry(3, 0, 0.004))
    //     : Matrix4.identity();
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.BORDER_YELLOW, width: 0.5),
        ),
        color: Colors.white,
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ColorFiltered(
        colorFilter: currentIndex == current
            ? ColorFilter.mode(Colors.transparent, BlendMode.overlay)
            : ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
        child: Image.network(
          widget.imagesURL[current].url,
          cacheHeight: 200,
          cacheWidth: 250,
          // height: shortestSide < 600
          //     ? 200
          //     : MediaQuery.of(context).size.height * 0.2,
          width: 1000,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

double inverseLerp(double min, double max, double value) {
  return (value - min) / (max - min);
}
