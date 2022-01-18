import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:drink/models/cart_model.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/network_utility.dart';
import 'package:flutter/services.dart';

class CartRepository {
  Future<void> addAllProductsToAPI(List<CartModel> productList) async {
    await Future.wait(productList.map((product) async {
      await _addProductToAPI(product);
    }));
  }

  Future<void> _addProductToAPI(CartModel cartModel) async {
    final FormData _formData = FormData.fromMap(
        {'product_id': cartModel.drink.id, 'qty': cartModel.qty});
    final Response response = await Network.instance.authPostRequest(
      endPoint: API.CART,
      formData: _formData,
      bearerToken:
          SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    // debugger();
    if (response.data['status'] == 1) {
      // AppNavigation.showToast(message: response.data['message']);
    } else {
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }
  }

  Future<void> emptyCart() async {
    final FormData _formData = FormData.fromMap({});
    final Response response = await Network.instance.authPostRequest(
      endPoint: API.EMPTY_CART,
      formData: _formData,
      bearerToken:
          SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    if (response.data['status'] == 1) {
      final _message = response.data['message'];
      if (_message.trim() != 'success' && _message.trim() != 'Success') {
        AppNavigation.showToast(message: response.data['message']);
      }
    } else {
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }
  }
}
