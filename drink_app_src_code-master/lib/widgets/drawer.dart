import 'package:auto_size_text/auto_size_text.dart';
import 'package:drink/blocs/authentication/authentication_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/blocs/cart/cart_cubit.dart';
import 'package:drink/blocs/change_password/change_password_bloc.dart';
import 'package:drink/blocs/content/content_cubit.dart';
import 'package:drink/blocs/orders/get_orders/get_orders_cubit.dart';
import 'package:drink/models/user.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/repositories/content_repository.dart';
import 'package:drink/repositories/orders_repository.dart';
import 'package:drink/screens/cards/cards_screen.dart';
import 'package:drink/screens/change_password/change_password_screen.dart';
import 'package:drink/screens/html_screens/html_screens.dart';
import 'package:drink/screens/orders/orders_screen.dart';
import 'package:drink/screens/profile/profile_screen.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:drink/widgets/custom_expansion_tile.dart';
import 'package:drink/widgets/reservation_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:drink/utility/sized_extention.dart';
import 'package:sizer/sizer.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key key,
    @required this.screenName,
  }) : super(key: key);
  static String currentRoute = '';

  final String screenName;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  UserModel currentUser;
  String userName;
  String userEmail;
  String userImage;
  bool buttonEnabled = true;
  void _handleChanged() {
    context.read<ThemeBloc>().add(
          ThemeChanged(),
        );
  }

  @override
  void initState() {
    super.initState();
    CustomDrawer.currentRoute = widget.screenName;

    currentUser = context.read<AuthenticationBloc>()?.currentUser;
    userName = currentUser?.name;
    userEmail = currentUser?.email;
    userImage = currentUser?.profilePicture?.isNotEmpty ?? false
        ? API.PHOTO_URL + currentUser?.profilePicture
        : null;
  }

  Widget _menuTile(String name, VoidCallback onPressed, String iconPath,
      ThemeType themeType) {
    return InkWell(
      child: SizedBox(
        height: 40.getContextHeight(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(
              flex: 8,
            ),
            Expanded(
              flex: 4,
              child: ImageIcon(
                AssetImage(iconPath),
                color: AppColors.CIRCLE_YELLOW,
                size: 14.sp,
              ),
            ),
            Spacer(
              flex: 6,
            ),
            Expanded(
              flex: 47,
              child: Text(
                name,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: themeType == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  Widget _themeSelectionTile(
    VoidCallback selected,
  ) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        bool value = state.type == ThemeType.dark ? true : false;
        return SizedBox(
          height: 30.getContextHeight(context),
          child: Row(
            children: [
              Spacer(
                flex: 13,
              ),
              Expanded(
                flex: 7,
                child: Icon(
                  FontAwesomeIcons.adjust,
                  color: AppColors.CIRCLE_YELLOW,
                  size: 10.sp,
                ),
              ),
              Spacer(
                flex: 7,
              ),
              Expanded(
                flex: 40,
                child: Text(
                  value ? AppStrings.DARK_THEME : AppStrings.LIGHT_THEME,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    color: value ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 13,
                child: Switch(
                  focusColor: Theme.of(context).primaryColor,
                  hoverColor: AppColors.CIRCLE_YELLOW,
                  activeColor: AppColors.CIRCLE_YELLOW,
                  value: value,
                  onChanged: (selectedValue) => selected(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _expandedMenuTile(
    String name,
    VoidCallback onPressed,
    String iconPath,
    ThemeType themeType,
  ) {
    return InkWell(
      child: SizedBox(
        height: 30.getContextHeight(context),
        child: Row(
          children: [
            Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 1,
              child: ImageIcon(
                AssetImage(iconPath),
                color: AppColors.BORDER_YELLOW,
                size: 10.sp,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 8,
              child: Text(
                name,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: themeType == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    currentUser = context.watch<AuthenticationBloc>().currentUser;
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themestate) {
      ThemeType themeType = themestate.type ?? ThemeType.light;
      return Stack(
        children: [
          Image.asset(
            themeType == ThemeType.light
                ? AssetPaths.DRAWER_BACKGROUND_LIGHT
                : AssetPaths.DRAWER_BACKGROUND_DARK,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.shrink(),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.solidEdit,
                      color: themeType == ThemeType.light
                          ? Colors.black
                          : Colors.white,
                      size: 18,
                    ),
                    onPressed: () {
                      AppNavigation.navigatorPop(context);
                      AppNavigation.navigateTo(
                          context,
                          EditProfileView(
                            currentUser: currentUser,
                            key: profileKey,
                          ));
                    },
                  ),
                ],
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: AppColors.BORDER_YELLOW,
                      style: BorderStyle.solid,
                    )),
                child: Center(
                  child: CircleAvatar(
                    radius: 54,
                    backgroundImage: currentUser?.profilePicture == null
                        ? AssetImage(
                            AssetPaths.PROFILE_IMAGE,
                          )
                        : NetworkImage(
                            userImage,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                userName ?? AppStrings.USERNAME,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.TEXT_YELLOW,
                ),
              ),
              Text(
                userEmail ?? AppStrings.USER_EMAIL,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: themeType == ThemeType.light
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 44.getContextHeight(context),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _menuTile(
                      AppStrings.HOME,
                      () {
                        if (widget.screenName == AppStrings.HOME_SCREEN) {
                          AppNavigation.navigatorPop(context);
                        } else if (widget.screenName == AppStrings.BAR_SCREEN) {
                          AppNavigation.navigatorPop(context);
                        }
                      },
                      AssetPaths.HOME_ICON,
                      themeType,
                    ),
                    _menuTile(
                      AppStrings.CARDS,
                      () {
                        AppNavigation.navigateTo(
                            context,
                            CardScreen(
                              overlayDisabled: false,
                            ));
                      },
                      AssetPaths.MAP_MARKER_ICON,
                      themeType,
                    ),
                    _menuTile(
                      AppStrings.ORDERS,
                      () {
                        AppNavigation.navigateTo(
                            context,
                            BlocProvider<GetOrdersCubit>(
                              create: (context) => GetOrdersCubit(
                                  ordersRepository: OrdersRepository()),
                              child: OrdersScreen(),
                            ));
                      },
                      AssetPaths.SHOPPING_ICON,
                      themeType,
                    ),
                    CustomExpansionTile(
                      title: AppStrings.SETTINGS,
                      children: [
                        _expandedMenuTile(
                          AppStrings.CHANGE_PASSWORD,
                          () {
                            AppNavigation.navigateTo(
                                context,
                                BlocProvider(
                                  create: (context) => ChangePasswordBloc(
                                      authenticationRepository: context
                                          .read<AuthenticationRepository>()),
                                  child: ChangePasswordScreen(),
                                ));
                          },
                          AssetPaths.CHANGE_PASSWORD,
                          themeType,
                        ),
                        _expandedMenuTile(
                          AppStrings.DELETE_ACCOUNT,
                          () {
                            AppNavigation.showDialogGeneral(
                                context,
                                GeneralAlertDialog(
                                  message: AppStrings.DELETE_ALERT,
                                )).then((result) {
                              if (result) {
                                if (buttonEnabled) {
                                  buttonEnabled = false;
                                  deleteAccount();
                                }
                              }
                            });
                          },
                          AssetPaths.DELETE,
                          themeType,
                        ),
                        _expandedMenuTile(
                          AppStrings.TERMS_AND_CONDITIONS,
                          () {
                            AppNavigation.navigateTo(
                              context,
                              BlocProvider<ContentCubit>(
                                create: (context) =>
                                    ContentCubit(ContentRepository()),
                                child: HTMLScreens(
                                  htmlPath: AssetPaths.PRIVACY_HTML,
                                  title: AppStrings.TERMS_AND_CONDITIONS,
                                ),
                              ),
                            );
                          },
                          AssetPaths.TERMS_AND_CONDITIONS_ICON,
                          themeType,
                        ),
                        _expandedMenuTile(
                          AppStrings.PRIVACY_POLICY,
                          () {
                            AppNavigation.navigateTo(
                              context,
                              BlocProvider<ContentCubit>(
                                create: (context) =>
                                    ContentCubit(ContentRepository()),
                                child: HTMLScreens(
                                  htmlPath: AssetPaths.PRIVACY_HTML,
                                  title: AppStrings.PRIVACY_POLICY,
                                ),
                              ),
                            );
                          },
                          AssetPaths.PRIVACY_POLICY_ICON,
                          themeType,
                        ),
                        _themeSelectionTile(_handleChanged),
                      ],
                    ),
                    _menuTile(
                      AppStrings.SIGNOUT,
                      () {
                        AppNavigation.showDialogGeneral(
                            context,
                            GeneralAlertDialog(
                              message: AppStrings.SIGNOUT_ALERT,
                            )).then((result) {
                          if (result) {
                            if (buttonEnabled) {
                              buttonEnabled = false;
                              signOut();
                            }
                          }
                        });
                      },
                      AssetPaths.SIGNOUT_ICON,
                      themeType,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Future<void> signOut() async {
    await context.read<CartCubit>().emptyCart();
    context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
    AppNavigation.navigatorPop(context);
    buttonEnabled = true;
  }

  Future<void> deleteAccount() async {
    await context.read<CartCubit>().emptyCart();
    context.read<AuthenticationBloc>().add(AuthenticationDeleteRequested());
    AppNavigation.navigatorPop(context);
    buttonEnabled = true;
  }
}
