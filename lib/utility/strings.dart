class AppStrings {
  static double doubleParse(String value) {
    if (value != null) {
      if (value.isNotEmpty) {
        if (value.contains('°')) {
          return double.tryParse(value.substring(0, value.lastIndexOf('°')));
        } else {
          return double.tryParse(value);
        }
      } else {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  }

  static const String APP_TITLE = 'Drink';
  static const String EMAIL_LOGIN = 'Signin With Email';
  static const String PHONE_LOGIN = 'Signin With Phone';
  static const String APPLE_LOGIN = 'Signin With Apple';
  static const String FACEBOOK_LOGIN = 'Signin With Facebook';
  static const String GOOGLE_LOGIN = 'Signin With Google';
  static const String ALERT = 'Alert!';
  static const String AGREE_CONDITION = 'I have read and agrees with the';
  static const String ACCEPT = 'Accept';
  static const String REJECT = 'Reject';
  static const String SIGNIN = ' Signin';
  static const String EMAIL_HINT = 'Email Address';
  static const String EMAIL_ADDRESS = 'Email Address:';
  static const String ENTER_TIP_HINT = 'Enter Tip';
  static const String ENTER_TIP = 'Enter Tip:';
  static const String GIVE_TIPS = 'Give Tip';
  static const String PASSWORD = 'Password:';
  static const String PASSWORD_GET = 'Password';
  static const String PASSWORD_HINT = 'Password';
  static const String SIGN_IN = 'SIGN IN';
  static const String FORGET_PASSWORD = 'Forget Password?';
  static const String DONT_HAVE_ACCOUNT = 'Don\'t have an account? ';
  static const String SIGNUP = 'Signup';
  static const String FORGET_PASSWORD_TITLE = 'Forget Password';
  static const String RESET = 'Reset';
  static const String ALREADY_HAVE_ACCOUNT = 'Already have an account?';
  static const String VERIFICATION = 'Verification';
  static const String VERIFICATION_TEXT_ONE =
      'We have sent you an email, containing the verification code. Please enter the verification code in order to verify your email address.';
  static const String VERIFICATION_TEXT_TWO =
      'If you didn\'t receive the email, please check your junk/spam folder or wait few more moments. ';
  static const String COMPLETE_PROFILE = 'Complete Profile';
  static const String GENDER = 'Gender';
  static const String MALE = 'Male';
  static const String FEMALE = 'Female';
  static const String DATEOFBIRTH = 'Date of Birth';
  static const String DONE = 'Done';
  static const String COMPLETE_NAME = 'Complete Name';

  static const String CHANGE_PASSWORD = 'Change Password';
  static const String UPDATE = 'Update';
  static const String OLD_PASSWORD = 'Old Password';
  static const String NEW_PASSWORD = 'New Password';
  static const String CONFIRM_NEW_PASSWORD = 'Confirm New Password';
  static const String USERNAME = 'USERNAME';
  static const String USER_AGE = '21';
  static const String USER_EMAIL = 'username@domain.com';
  static const String HOME = 'Home';
  static const String ADDRESS = 'Address';
  static const String CARDS = 'Cards';
  static const String ORDERS = 'Orders';
  static const String SIGNOUT = 'Signout';
  static const String SETTINGS = 'Settings';
  static const String DELETE_ACCOUNT = 'Delete Account';
  static const String TERMS_AND_CONDITIONS = 'Terms & Conditions';
  static const String PRIVACY_POLICY = 'Privacy Policy';
  static const String EMAIL_ADDRESS_GET = 'Email Address';
  static const String CHECKOUT = 'Checkout';
  static const String DATE_FORMAT_DOB = 'dd-MM-yyyy';
  static const String RESERVATION_FORMAT = 'dd-MM-yyyy hh:mm a';
  static const String API_RESERVATION_FORMAT = 'yyyy-MM-dd hh:mm:ss';

  static const String ADD_TIP = 'Add Tip';

  static const String DATE_FORMAT_DOB_DATABASE = 'yyyy-MM-dd';
  static const String DATE_FORMAT_EXPEIRY = 'MM/yyyy';
  static const String DATE_FORMAT_ORDER = 'MM dd, yyyy';

  static const String DATE_ATTRIBUTE = 'date';
  static const String SPACE = ' ';
  static const String GALLERY = 'Gallery';
  static const String CAMERA = 'Camera';
  static const String DELIVERY = 'Delivery';
  static const String PICK_UP = 'Pick up';
  static const String ADD_NEW_ADDRESS = 'Add new address';
  static const String SAMPLE_ADDRESS_ONE = 'Sample Address One';
  static const String SAMPLE_ADDRESS_TWO = 'Sample Address Two';
  static const String ADDRESS_NAME = 'Address Name';
  static const String RECIPIENT_NAME = 'Recipient Name';
  static const String RECIPIENT_CONTACT_NO = 'Recipient Contact No.';
  static const String RECIPIENT_ADDRESS = 'Recipient Address';
  static const String ADD_NEW_CARD = 'Add New Card';
  static const String CARD_NUMBER = 'Card Number';
  static const String EXP_MONTH = 'Exp. Month';
  static const String EXP_YEAR = 'Exp. Year';
  static const String CCV = 'CCV';
  static const String TOTAL_COST = 'Total Cost';
  static const String THIRTY_USD = '30\$';
  static const String PAY_NOW = 'Pay Now';
  static const String BAR_NAME = 'Bar Name';
  static const String BAR_LOCATION = 'Bar Location';
  static const String MILES_AWAY = ' miles away';
  static const String TABLES = 'Tables';
  static const String DRINKS = 'Drinks';
  static const String BITES = 'Bites';
  static const String SMOOTHIES = 'SMOOTHIES';
  static const String SOFT_DRINKS = 'SOFT DRINKS';
  static const String HENNESSY = 'Hennessy';
  static const String SIX_USD = '\$6';
  static const String CART = 'Cart';
  static const String DEALS = 'Deals';
  static const String DRINK_NAME = 'DRINK NAME';
  static const String TOTAL_AMOUNT = 'Total Amount';
  static const String PROCEED_TO_CHECKOUT = 'Proceed to checkout';
  static const String SEVEN_USD = '\$7';
  static const String TWENTYONE_USD = '\$21';
  static const String DUMMY_CARD_NO = '**** **** **** 1234';
  static const String DUMMY_DATE = '12 / 20';
  static const String ADD_CARD = 'Add Card';
  static const String ADD = 'Add';
  static const String CANCEL = 'Cancel';
  static const String ORDER_ID = 'Order ID';
  static const String DUMMY_ORDER_DATE = 'Jan 1, 2020';
  static const String DUMMY_ORDER_AMOUNT = '\$400';
  static const String ORDERS_DETAILS = 'Orders Details';
  static const String PRODUCT_NO_ONE = 'Product #1';
  static const String FIFTY_USD = '\$50';
  static const String PAYMENT = 'Payment';
  static const String LOCATION = 'Location';
  static const String EDIT_PROFILE = 'Edit Profile';

  static const String HOME_SCREEN = 'HomeScreen';
  static const String BAR_SCREEN = 'BarScreen';
  static const String PHONE_NUMBER = 'Phone Number';
  static const String DOB_HELP_TEXT = 'Please provide you Date of Birth.';
  static const String ONE_MILE = '1 mi.';
  static const String TEN_MILE = '10 mi.';
  static const String EXCEPTION_MAPS = 'No Bool Returned from Dialog';
  static const String QR_CODE_TITLE = 'QR Code';
  static const String QR_CODE = '1234567890';
  static const String LOREM_IPSUM = 'Lorem Ipsum';
  static const int CARD_NUMBER_ONE = 1234567891234567;
  static const int CARD_NUMBER_TWO = 7654321987654321;
  static const ADD_PAYMENT_METHOD = 'Add a payment method';
  static const PAYMENT_OPTIONS = 'Payment Options';
  static const String IOS = 'ios';
  static const String ANDROID = 'android';
  static const String SMALL_MALE = 'male';
  static const String SMALL_FEMALE = 'female';
  static const String RESERVE = 'Reserve';
  static const String MAKE_RESERVATION = 'Make Reservation';
  static const String RESERVATION = 'Reservation';
  static const String NO_ORDERS = 'No Orders Yet!';
  static const String NO_ORDERS_PUNCHLINE =
      'Grab a drink from your nearest bar!';
  static const String CART_EMPTY = 'Your Cart Is Empty!';
  static const String DEAL_ALERT_EMPTY = 'Your Deal Alert Is Empty!';
  static const String CART_PUNCHLINE =
      'Looks like you havn\'t added anything to your cart yet.';
  static const String DEAL_PUNCHLINE = 'No Deals Yet!';
  static const String NO_CARD = 'No Card Added';
  static const String NO_CARD_PUNCHLINE = 'Press the + icon to add a new card.';
  static const String RESEND_OTP = 'Resend OTP';
  static const String OK = 'OK';
  static const String SHOW_ALL = 'Show all';
  static const String BKCC = 'bookmarked_credit_card';
  static const String UNAUTHENTICATED = 'Unauthenticated';
  static const String UNAUTHENTICATED_ERROR = 'Unauthenticated Error!';
  static const String TIME_OUT = 'Request Timed Out';
  static const String DIO_ERROR = 'Sorry Dio Error Occured';
  static const String INVITE_TEXT = 'HAVE A DRINK WITH YOUR MATE';
  static const String INVITE = 'Invite';
  static String googlePlaceURL(String lat, String long, int zoom) =>
      'https://www.google.com/maps/@${lat},${long},${zoom}z';

  static const String OUR_MENU = 'MENU';
  static const String INVITE_ALLCAPS = 'INVITE';
  static const String PLACEHOLDER_IMAGE =
      'https://picsum.photos/id/237/200/300';
  static const String YOUR_FRIENDS = 'YOUR FRIENDS';
  static const String TABLE_NAME = 'Table Name';
  static const String CAPACITY = 'Capacity';

  //-----------------ERROR MESSAGES-------------------//
  static const String PASSWORD_LENGTH_ERROR =
      'Password must be 8 characters long.';
  static const String PASSWORD_MATCH_ERROR = 'Passwords Don\'t Match.';
  static const String PASSWORD_EMPTY_ERROR = 'Password can\'t be empty.';
  static const String ERROR_TEXT = 'Sorry, an error has ocurred';
  static const String GENDER_ERROR = 'Gender is required';
  static const String DOB_ERROR = 'Date of birth is required.';
  static const String PROFILE_PICTURE_ERROR = 'Profile Picture is required';
  static const String NAME_ERROR = 'Name can\'t be empty.';
  static const String EMAIL_ERROR = 'Email is not valid';
  static const String NAME = 'Name';
  static const String QUANTITY = 'Quantity';
  static const String PRICE = 'Price';
  static const String EMAIL_EMPTY_ERROR = 'Email can\'t be empty.';
  static const String TIP_EMPTY_ERROR = 'Tip can\'t be empty.';
  static const String CONDITIONS_NOT_ACCEPTED_ERROR =
      'Please accept the terms and condition by checking it before proceeding further';
  static const String PRIVACY_POLICY_NOT_ACCEPTED_ERROR =
      'Please accept the privacy policy by checking it before proceeding further';
  static const String PRIVACY_AND_CONDITIONS_NOT_ACCEPTED_ERROR =
      'Please accept the Privacy Policy and Terms And Conditions by checking them first before proceeding further';
  static const String ADDRESS_NAME_ERROR = 'Please enter a valid address name';
  static const String GENERIC_ERROR = 'can\'t be empty.';
  static const String PASSWORD_INVALID_ERROR =
      'Password must be 8 characters long and contains at least 1 upper case, 1 lower case, 1 digit & 1 special character';
  static const String MONTH_GREATER_TWELVE = 'Month should be less than 12';
  static const String YEAR_EXCEEDED = 'Invalid year value';
  static const String CARD_LENGTH_ERROR =
      'Please ensure that the Card number is of 16 digits length.';
  static const String CCV_LENGTH_ERROR = 'Please write a valid CCV';
  static const String PAYMENT_METHOD_ERROR = 'A Payment Method is required.';
  static const String EMAIL_UNVERIFIED = 'Please verify your email first';
  static const String NO_INTERNET_CONNECTION = 'No Internet Conenction';
  static const String REQUEST_TIME_OUT = 'Request Time Out';
  static const String COMPLETE_PROFILE_FORM = 'Please complete the form first';
  static const String SOMETHING_WENT_WRONG = 'Something went wrong';
  static const String RESERVATION_ERROR =
      'Please provid a valid table reservation.';
  static const String MONTH_NOT_VALID = 'Please provide month first.';
  static const String YEAR_NOT_VALID = 'Please provide a valid year.';
  static const String PROVIDE_CARD_NUMBER = 'Please provide card number first';
  static const String PROVIDE_VALID_CVV = 'Please provide a valid CVV number.';
  static const String PROVIDE_VALID_MONTH = 'Please provide a valid month';
  static const String PROVIDE_VALID_CARDNUMBER =
      'Please provide a valid card number.';
  static const String DATE_ERROR = 'Please provide a valid date';
  static const String RESERVED_DATE = 'reserved-date';
  static const String SIGNOUT_ALERT = 'Are you sure you want to signout?';
  static const String DELETE_ALERT =
      'Are you sure you want to delete your account?';
  static const String SOFT_DRINK = 'Soft Drink';
  static const String SMOOTHIE = 'Smoothie';
  static const String FOR = 'for';
  static const String PERSONS = 'Persons';
  static const String DARK_THEME = 'Dark Theme';
  static const String LIGHT_THEME = 'Light Theme';
  static const String DEAL_ALERTS = 'Deal Alerts';

  //------------------------- API KEYS--------------------------//
  static const PLACES_API_KEY = 'AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ';
}
