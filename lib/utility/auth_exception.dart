import 'package:drink/utility/strings.dart';

class AuthException implements Exception {
  final String message = AppStrings.UNAUTHENTICATED_ERROR;
}
