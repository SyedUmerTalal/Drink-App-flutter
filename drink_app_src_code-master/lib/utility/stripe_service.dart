import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:drink/utility/constants.dart';

class StripeTransactionResponse {
  StripeTransactionResponse({this.message, this.success});

  String message;
  bool success;
}

class StripeService {
  static const String apiBase = 'https://api.stripe.com/v1';
  static const String paymentApiUrl =
      '${StripeService.apiBase}/payment_intents';
  static const String secret = STRIPECONSTANTS.STRIPE_SECRET;
  static const Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static void init() {
    StripePayment.setOptions(
        StripeOptions(publishableKey: STRIPECONSTANTS.PUBLISHABLE_KEY));
  }

  static Future<StripeTransactionResponse> confirmPaymentIntent(
      String sec, Token token) async {
    try {
      // debugger();
      final response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(clientSecret: sec, paymentMethodId: token.tokenId),
      );
      // debugger();
      if (response.status == 'succeeded') {
        return StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      // debugger();
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      // debugger();
      return StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static StripeTransactionResponse getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }
    return StripeTransactionResponse(message: message, success: false);
  }
}
