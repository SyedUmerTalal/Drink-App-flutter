import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:drink/models/place_details.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/network_utility.dart';
import 'package:flutter/services.dart';

typedef ReturnPlaceDetails = List<DPlaceDetails> Function();

class MapRepository {
  Future<List<DPlaceDetails>> getSpecificPoints(
      double lat, double lng, double radius) async {
    final FormData _formData = FormData.fromMap({
      'lat': lat,
      'long': lng,
      'radius': radius,
    });
    final Response response = await Network.instance.authPostRequest(
      endPoint: API.HOME,
      formData: _formData,
      bearerToken:
          SharedPref.instance.sharedPreferences.getString('bearer_token'),
    );
    final dynamic _jsonResponse = response.data;
    // debugger();
    if (_jsonResponse['status'] == 1) {
      // AppNavigation.showToast(message: _jsonResponse['message']);
      final List<DPlaceDetails> placeDet = List<DPlaceDetails>.from(
          _jsonResponse['data'].map((x) => DPlaceDetails.fromJson(x)));

      return placeDet;
    } else {
      throw PlatformException(
        code: '0',
        message: _jsonResponse['message'],
      );
    }

    // final placeDet = _validateResponse(response, () {
    //   final List<DPlaceDetails> placeDetails =
    //       _parsePlaceDetails(response.data['data']);
    //   return placeDetails;
    // });
    // return placeDet;
  }
}
