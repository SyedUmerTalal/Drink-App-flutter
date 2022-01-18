import 'package:dio/dio.dart';
import 'package:drink/models/tables.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/network_utility.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TableRepository {
  Future<List<Tables>> getTables(int restaurantId) async {
    final Map<String, dynamic> _formData = {
      'restaurant_id': restaurantId,
    };
    final Response response = await Network.instance.getRequest(
      endPoint: API.TABLES,
      queryParameters: _formData,
    );
    if (response.data['status'] == 1) {
      final TableResponse _jsonResponse = TableResponse.fromJson(response.data);

      // AppNavigation.showToast(message: _jsonResponse.message);
      final List<Tables> tables = _jsonResponse.data;
      return tables;
    } else {
      throw PlatformException(
        code: '0',
        message: response.data['message'],
      );
    }

    // final placeDet = _validateResponse(response, () {
    //   final List<DPlaceDetails> placeDetails =
    //       _parsePlaceDetails(response.data['data']);
    //   return placeDetails;
    // });
    // return placeDet;
  }

  Future<String> reserveTable(
      int tableId, DateTime dateTime, int cardId) async {
    final FormData _formData = FormData.fromMap({
      'table_id': tableId,
      'date_time':
          DateFormat(AppStrings.API_RESERVATION_FORMAT).format(dateTime),
      'card_id': cardId,
    });
    // SharedPref.instance.sharedPreferences.setString(
    //     AppStrings.RESERVED_DATE + tableId.toString(),
    //     DateFormat(AppStrings.RESERVATION_FORMAT).format(dateTime));
    final Response response = await Network.instance.authPostRequest(
      endPoint: API.TABLE_RESERVE,
      formData: _formData,
      bearerToken:
          SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    final dynamic _jsonResponse = response.data;
    if (_jsonResponse['status'] == 1) {
      return _jsonResponse['message'];
    } else {
      throw PlatformException(
        code: '0',
        message: _jsonResponse['message'],
      );
    }
  }
}
