import 'package:drink/models/place_details.dart';
import 'package:drink/utility/asset_paths.dart';
import 'package:drink/utility/colors.dart';
import 'package:drink/utility/functions.dart';
import 'package:drink/utility/info_window_clipper.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final kTechnadoLocation = LatLng(24.928517939526888, 67.09328901317531);

class API {
  ///previous
  // static const String BASE_URL = 'https://myprojectstaging.com/appsservices/drinkapp_php/api/';
  static const BASE_URL = 'https://webprojectmockup.com/drinkapp_mobile/api/';

  // static const String PHOTO_URL = 'https://myprojectstaging.com/appsservices/drinkapp_php/public/uploads/';
  static const String PHOTO_URL =
      'https://webprojectmockup.com/appsservices/drinkapp_php/public/uploads/';
  static const String ACCEPT = 'application/json';
  static const int SUCCESS_CODE = 200;
  static const int API_SUCCESS_STATUS = 1;
  static const int EMAIL_VERIFIED = 1;
  static const int PROFILE_COMPLETED = 1;
  static const String ANDROID = 'android';
  static const String IOS = 'ios';
  static const String GOOGLE_SIGN_IN = 'google';
  static const String FACEBOOK_SIGN_IN = 'facebook';
  static const String APPLE_SIGN_IN = 'apple';
  static const String PHONE_SIGN_IN = 'phone';
  static const String INVALID_PHONE_NUMBER = 'invalidCredential';

  ////////////////////// API Operations ////////////////////////
  static const String LOGIN = 'login';
  static const String SIGN_UP = 'signup';
  static const String RESEND_OTP = 'otp-resend';
  static const String VERIFY_OTP = 'otp-verify';
  static const String SOCIAL_LOGIN = 'social-auth';
  static const String COMPLETE_PROFILE = 'complete-profile';
  static const String FORGOT_PASSWORD = 'forgot-password';
  static const String VERIFY_FORGOT_PASSWORD_OTP = 'forgot-password-otp-verify';
  static const String RESET_PASSWORD = 'reset-password';
  static const String CHANGE_PASSWORD = 'change-password';
  static const String LOGOUT = 'logout';
  static const String HOME = 'home';
  static const String PRODUCTS = 'products';
  static const String TABLES = 'tables';
  static const String TABLE_RESERVE = 'tables/reserve';
  static const String ORDERS = 'orders';
  static const String LIST_CARDS = 'payment/list-cards';
  static const String SAVE_CARD = 'payment/save-card';
  static const String CART = 'cart';
  static const String CONFIRM_ORDER = 'orders/confirm';
  static const String EMPTY_CART = 'cart/empty';
  static const String USER_PROFILE = 'user-profile';
  static const String HELP_AND_FEEDBACK = 'feedback';
  static const String CONTENT = 'content';
  static const String TYPE = 'type';
  static const String PrivacyPolicy = 'pp';
  static const String TermsAndConditions = 'tc';
  static const String DELETE_CARD = 'payment/delete-card';
  static const String DELETE_ACCOUNT = 'delete-account';
  static const String DEAL_ALERT = 'deal_alert';

  ///ARK Changes
  static const String READ_DEAL_ALERT = 'deal_alert_update';
  static const String TIP = 'tip';
}

final CameraPosition kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 19,
);
final GlobalKey profileKey = GlobalKey();

final location1 = LatLng(37.42864291771006, -122.07842492205432);
final location2 = LatLng(37.42196302961278, -122.0873942282867);
final location3 = LatLng(37.42642771474738, -122.07842492205432);
final location4 = LatLng(24.863661148555572, 67.058774097875);

GlobalKey windowKey = GlobalKey();

final backGroundImgDecoration = BoxDecoration(
  image: DecorationImage(image: getAssetImage(), fit: BoxFit.fill),
);

final backGroundImgDecorationLight = BoxDecoration(
  image: DecorationImage(
    image: getAssetImageLight(),
    fit: BoxFit.fill,
  ),
);

final markerWidget = Container(
  height: 200,
  width: 200,
  color: Colors.red,
);

final updatedmarkerWidget = Image.asset(
  AssetPaths.UNSELECTED_MARKER,
  width: 50,
  height: 100,
  cacheHeight: 100,
  cacheWidth: 50,
);

final updatedInfoWindowWidget = Material(
  child: Container(
    color: Colors.transparent,
    width: 200,
    height: 200,
    child: Column(
      children: [
        Expanded(
          child: infoWindowWidget,
        ),
        Expanded(child: updatedmarkerWidget),
      ],
    ),
  ),
);

final infoWindowWidget = ClipPath(
  clipper: InfoWidgetClipper(),
  child: InkWell(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
            color: AppColors.BORDER_YELLOW,
            width: 1.5,
            style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      height: 120,
      width: 250,
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.BAR_NAME,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.TEXT_YELLOW,
                  ),
                ),
                Text(AppStrings.BAR_LOCATION),
                Text(AppStrings.MILES_AWAY),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

const StripeConfig = {
  'publishableKey':
      'pk_test_51H0UoCJELxddsoRYqANwUqQLd24vQYATeVTsN7Sm1xnAD68ARNm6bK0vsdCSqisOhSMNCATShUvDmXdzeyW0Cezz00RbGzoMup',
  'merchantId': 'Test',
  'androidPayMode': 'test',
  'enabled': true,
};

class STRIPECONSTANTS {
  static const String PUBLISHABLE_KEY =
      'pk_test_51H0UoCJELxddsoRYqANwUqQLd24vQYATeVTsN7Sm1xnAD68ARNm6bK0vsdCSqisOhSMNCATShUvDmXdzeyW0Cezz00RbGzoMup';
  static const String STRIPE_SECRET =
      'sk_test_51H0UoCJELxddsoRYdF40WwR8HUvA8U5wgUNqQwDCweZT4TnbAuIGINVtVWAItPMcSoMOighLxdZR1Jjl8vdUwldb00EMPAVgIE';
}

const PaymentProviderEnabled = {'name': 'stripe'};

class SharedPref {
  SharedPref._init();

  static SharedPref _instance;

  static SharedPref get instance {
    _instance ??= SharedPref._init();
    return _instance;
  }

  void clear() {
    sharedPreferences.clear();
  }

  SharedPreferences sharedPreferences;
  Future<void> getSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}

RegExp doubleRE = RegExp(r'-?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?');

DPlaceDetails samplePlaceDetails = DPlaceDetails(
  id: 2020,
  name: 'test',
  address: 'test',
  distance: '0.0',
  lat: (-83.2909748069532).toString(),
  long: 40.32560681357928.toString(),
  images: [],
);
