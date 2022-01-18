import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/blocs/bar_details/get_bites/get_bites_cubit.dart';
import 'package:drink/blocs/bar_details/get_drinks/get_drinks_cubit.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/utility/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

typedef ContextCallBack = Future<void> Function(BuildContext context);

class BarButton extends StatelessWidget {
  BarButton({
    Key key,
    this.borderRadius,
    this.textPadding,
    this.textSize,
    this.biteType,
    this.isDrink,
    this.onPressed,
    @required this.themeType,
  }) : super(key: key);
  final double borderRadius;
  final double textPadding;
  final double textSize;
  final bool isDrink;
  final VoidCallback onPressed;
  final Bite biteType;
  final ThemeType themeType;
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return isDrink
        ? BlocBuilder<GetDrinksCubit, GetDrinksState>(
            builder: (context, state) {
              if (state is GetDrinksCompleted) {
                enabled = state.drinkCategory.id == biteType.id;
              }
              return _categoryButton(context);
            },
          )
        : BlocBuilder<GetBitesCubit, GetBitesState>(
            builder: (context, state) {
              if (state is GetBitesCompleted) {
                enabled = state.biteCategory.id == biteType.id;
              }
              return _categoryButton(context);
            },
          );
    ;
  }

  InkWell _categoryButton(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      onTap: () {
        if (isDrink) {
          context.read<GetDrinksCubit>().updateDrinks(biteType);
        } else {
          context.read<GetBitesCubit>().updateBite(biteType);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        alignment: Alignment.center,
        width: (shortestSide > 600
                ? MediaQuery.of(context).size.width * 0.2
                : MediaQuery.of(context).size.width * 0.255) +
            24,
        height: 36,
        decoration: BoxDecoration(
          color: enabled
              ? Colors.white
              : themeType == ThemeType.light
                  ? AppColors.BORDER_YELLOW
                  : Colors.transparent,
          border: Border.all(
            color: AppColors.BORDER_YELLOW,
            width: enabled ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(
            borderRadius ?? 10,
          ),
        ),
        child: AutoSizeText(
          biteType.title ?? 'Not Found',
          minFontSize: 12,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: enabled ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
