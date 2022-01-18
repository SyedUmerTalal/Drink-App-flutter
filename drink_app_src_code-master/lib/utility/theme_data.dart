import 'package:drink/utility/colors.dart';
import 'package:flutter/material.dart';
// ThemeData(
//               fontFamily: 'Montserrat',
//               primaryIconTheme: IconThemeData(
//                 color: Colors.white,
//                 opacity: 1.0,
//               ),
//               primaryColor: AppColors.CIRCLE_YELLOW,
//               canvasColor: AppColors.GOLDEN,
//               primarySwatch: Colors.orange,
//               dividerColor: Colors.white,
//               visualDensity: VisualDensity.adaptivePlatformDensity,
//               bottomSheetTheme: BottomSheetThemeData(
//                 backgroundColor: Colors.transparent,
//               )),

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: AppColors.BORDER_YELLOW,
    primaryColorDark: AppColors.BORDER_YELLOW,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
        opacity: 1.0,
      ),
    ),
    primarySwatch: Colors.orange,
    dividerColor: Colors.white,
    unselectedWidgetColor: Colors.black45,
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      background: AppColors.GOLDEN,
      primary: AppColors.CIRCLE_YELLOW,
      onPrimary: AppColors.GOLDEN,
      primaryVariant: AppColors.BORDER_YELLOW,
      secondary: Colors.black,
    ),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Montserrat',
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: AppColors.BORDER_YELLOW,
    primaryColorDark: AppColors.BORDER_YELLOW,
    scaffoldBackgroundColor: Colors.transparent,
    unselectedWidgetColor: Colors.black45,
    appBarTheme: AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
        opacity: 1.0,
      ),
    ),
    primarySwatch: Colors.orange,
    dividerColor: Colors.white,
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      background: AppColors.GOLDEN,
      primary: AppColors.CIRCLE_YELLOW,
      onPrimary: AppColors.GOLDEN,
      primaryVariant: AppColors.BORDER_YELLOW,
      secondary: Colors.black,
    ),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
  );
}
