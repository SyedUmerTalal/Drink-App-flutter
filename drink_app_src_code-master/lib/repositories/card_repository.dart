import 'package:dio/dio.dart';
import 'package:drink/models/credit_card.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/network_utility.dart';
import 'package:flutter/services.dart';

class CardsRepository {
  Future<List<CreditCard>> getAllCards() async {
    final FormData _formData = FormData.fromMap({});
    final Response response = await Network.instance.authPostRequest(
      endPoint: API.LIST_CARDS,
      formData: _formData,
      bearerToken:
          SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    if (response.data['status'] == 1) {
      final CreditCardResponse _jsonResponse =
          CreditCardResponse.fromJson(response.data);

      final _message = _jsonResponse.message;
      if (_message.trim() != 'success' && _message.trim() != 'Success') {
        AppNavigation.showToast(message: _message);
      }
      final List<CreditCard> orders = _jsonResponse.data;
      return orders;
    } else {
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }
  }

  Future<void> deleteCard(CreditCard creditCard) async {
    final FormData _formData = FormData.fromMap({'card_id': creditCard.id});

    final Response response = await Network.instance.authPostRequest(
      endPoint: API.DELETE_CARD,
      formData: _formData,
      bearerToken:
          SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    if (response.data['status'] == 1) {
      final _message = response.data['message'];
      if (_message.trim() != 'success' && _message.trim() != 'Success') {
        AppNavigation.showToast(message: _message);
      }
    } else {
      print(response.data['message']);
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }
  }

  Future<void> saveCard(String token) async {
    final FormData _formData = FormData.fromMap({'source_token': token});
    final Response response = await Network.instance.authPostRequest(
      endPoint: API.SAVE_CARD,
      formData: _formData,
      bearerToken:
          SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    if (response.data['status'] == 1) {
      final _message = response.data['message'];
      if (_message.trim() != 'success' && _message.trim() != 'Success') {
        AppNavigation.showToast(message: _message);
      }
    } else {
      print(response.data['message']);
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }
  }
}
