import 'package:dio/dio.dart';
import 'package:drink/models/drink.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/network_utility.dart';
import 'package:flutter/services.dart';

class PlaceRepository {
  Future<List<Drink>> getBites(int restaurantId, int categoryId) async {
    print(restaurantId.toString() + ' ID');
    final Map<String, dynamic> _formData = {
      'restaurant_id': restaurantId,
      'category_id': categoryId,
    };
    final Response response = await Network.instance.getRequest(
      endPoint: API.PRODUCTS,
      queryParameters: _formData,
    );
    if (response.data['status'] == 1) {
      final _jsonResponse = List<Drink>.from(
          response.data['data'].map((x) => Drink.fromJson(x, categoryId)));

      // AppNavigation.showToast(message: response.data['message']);

      final _message = response.data['message'];
      if (_message.trim() != 'success' && _message.trim() != 'Success') {
        AppNavigation.showToast(message: response.data['message']);
      }
      final List<Drink> placeDet = _jsonResponse;
      return placeDet;
    } else {
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }
  }

  Future<List<Drink>> getDrinks(int restaurantId, int categoryId) async {
    final Map<String, dynamic> _formData = {
      'restaurant_id': restaurantId,
      'category_id': categoryId,
    };
    final Response response = await Network.instance.getRequest(
      endPoint: API.PRODUCTS,
      queryParameters: _formData,
    );
    if (response.data['status'] == 1) {
      final DrinkResponse _jsonResponse =
          DrinkResponse.fromJson(response.data, categoryId);
      final _message = _jsonResponse.message;
      if (_message.trim() != 'success' && _message.trim() != 'Success') {
        AppNavigation.showToast(message: _jsonResponse.message);
      }

      final List<Drink> placeDet = _jsonResponse.data;
      return placeDet;
    } else {
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }
  }
}
