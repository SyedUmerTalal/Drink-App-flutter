import 'dart:developer';

import 'package:drink/models/order.dart';
import 'package:dio/dio.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/network_utility.dart';
import 'package:drink/utility/navigation.dart';
import 'package:flutter/services.dart';

class OrdersRepository {
  Future<List<Order>> getOrders() async {
    final Map<String, dynamic> _formData = {};
    final Response response = await Network.instance.getRequest(
      endPoint: API.ORDERS,
      queryParameters: _formData,
    );
    // debugger();
    if (response.data['status'] == 1) {
      final OrdersResponse _jsonResponse =
          OrdersResponse.fromJson(response.data);

      // AppNavigation.showToast(message: _jsonResponse.message);
      final List<Order> orders = _jsonResponse.data;
      return orders;
    } else {
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }
  }
}
