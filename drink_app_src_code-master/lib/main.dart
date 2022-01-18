import 'package:drink/blocs/authentication/authentication_bloc.dart';
import 'package:drink/blocs/cart/cart_cubit.dart';
import 'package:drink/blocs/deal_alert/deal_alert_bloc.dart';
import 'package:drink/blocs/deal_alert/deal_alert_service.dart';
import 'package:drink/blocs/signIn/signin_bloc.dart';
import 'package:drink/blocs/theme/theme_bloc.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:drink/repositories/cart_repository.dart';
import 'package:drink/repositories/theme_repository.dart';
import 'package:drink/screens/home/home_screen.dart';
import 'package:drink/screens/profile/profile_screen.dart';
import 'package:drink/screens/signin/signin_screen.dart';
import 'package:drink/screens/splash_screen/splash_screen.dart';
import 'package:drink/screens/verification/verification_screen.dart';
import 'package:flutter/scheduler.dart';
import 'utility/theme_data.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer' as developer;
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/device_info.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/permissions.dart';
import 'package:drink/utility/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'utility/bloc_observer.dart';

const String _storageKey = AppStrings.APP_TITLE;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await preload();
  await SplashScreen.preloadDarkModeLogo();
  await SplashScreen.preloadLightModeLogo();
  await Firebase.initializeApp();
  await SharedPref.instance.getSharedPreferences();
  Bloc.observer = SimpleBlocObserver();
  await DeviceInfo.instance.getDeviceToken();
  final _locationPermission = await PositionPermission.check();
  final _themeRepository = ThemeRepository();
  String _selectedTheme =
      SharedPref.instance.sharedPreferences.getString(_storageKey + 'theme');

  Brightness brightness = _selectedTheme == null
      ? SchedulerBinding.instance.window.platformBrightness
      : _selectedTheme == 'dark'
          ? Brightness.dark
          : Brightness.light;
  runApp(App(
    theme: brightness == Brightness.dark ? ThemeType.dark : ThemeType.light,
    authenticationRepository:
        AuthenticationRepository(facebookLogin: FacebookLogin()),
    themeRepository: _themeRepository,
    checkLocationPermission: _locationPermission.isAvailable,
  ));
}

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.theme,
    @required this.authenticationRepository,
    @required this.themeRepository,
    @required this.checkLocationPermission,
  })  : assert(authenticationRepository != null),
        super(key: key);
  final AuthenticationRepository authenticationRepository;
  final ThemeRepository themeRepository;
  final bool checkLocationPermission;
  final ThemeType theme;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>.value(
          value: authenticationRepository,
        ),
        RepositoryProvider<ThemeRepository>.value(
          value: themeRepository..init(theme),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(themeRepository, theme),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider<DealAlertBloc>(
            create: (context) =>
                DealAlertBloc(dealAlertService: DealAlertServiceImp()),
          ),
          BlocProvider<CartCubit>(
            create: (_) => CartCubit(CartRepository()),
          )
        ],
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    this.checkLocationPermission,
  }) : super();
  final bool checkLocationPermission;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            title: AppStrings.APP_TITLE,
            debugShowCheckedModeBanner: false,
            theme: state.type == ThemeType.light
                ? AppTheme.lightTheme
                : AppTheme.darkTheme,
            darkTheme: AppTheme.darkTheme,
            builder: (context, child) =>
                BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<SigninBloc>(
                          create: (_) => SigninBloc(
                            // authenticationBloc: context.watch<AuthenticationBloc>(),
                            authenticationRepository:
                                context.read<AuthenticationRepository>(),
                          ),
                          child: SigninScreen(),
                        ),
                      ),
                      (route) => false,
                    );
                    break;

                  case AuthenticationStatus.incompleteprofile:
                    final _currentUser = state.user;

                    _navigator.pushAndRemoveUntil<void>(
                      MaterialPageRoute(
                          builder: (_) => CompleteProfileView(
                                currentUser: _currentUser,
                                key: profileKey,
                              )),
                      (route) => false,
                    );
                    break;
                  case AuthenticationStatus.authenticated:
                    _navigator.pushAndRemoveUntil<void>(
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                      (route) => false,
                    );
                    break;
                  default:
                    break;
                }
              },
              child: child,
            ),
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => SplashScreen(),
            ),
          );
        });
      },
    );
  }
}
