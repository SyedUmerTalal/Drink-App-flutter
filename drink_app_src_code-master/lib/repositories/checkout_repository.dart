import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:drink/models/cart_model.dart';
import 'package:drink/models/checkout_model.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/network_utility.dart';
import 'package:flutter/services.dart';

class CheckoutRepository {
  // List<CartModel> productsList = [];
  // CheckoutRepository() {}
  // CheckoutRepository.forProduct(List<CartModel> products) {
  //   this.productsList = products;
  // }

  Future<CheckoutModel> placeOrder(int cardId) async {
    // debugger();
    final FormData _formData = FormData.fromMap({'card_id': cardId});
    final Response response = await Network.instance.authPostRequest(
      endPoint: API.CONFIRM_ORDER,
      formData: _formData,
      bearerToken:
          SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    // debugger();
    // productsList;
    if (response.data['status'] == 1) {
      print(response.data.toString());

      // AppNavigation.showToast(message: response.data['message']);
      final CheckoutResponse _response =
          checkoutResponseFromJson(jsonEncode(response.data));
      return _response.data;
    } else {
      // debugger();
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }
  }
}
