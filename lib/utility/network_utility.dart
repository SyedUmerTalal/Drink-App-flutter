import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/navigation.dart';
import 'package:drink/utility/strings.dart';
import 'package:flutter/services.dart';

class Network {
  Network._init();

  static Network _instance;

  static Network get instance {
    _instance ??= Network._init();
    return _instance;
  }

  Dio _dioInstance;

  Dio get _dio {
    _dioInstance ??= Dio();
    return _dioInstance;
  }

  CancelToken _token;
  CancelToken get _cancelToken {
    _token ??= CancelToken();
    return _token;
  }

  ////////////////// Get Request /////////////////////////
  Future<Response> getRequest(
      {String endPoint, Map<String, dynamic> queryParameters}) async {
    Response response;
    try {
      // CancelToken _cancelToken = CancelToken();
      // debugger();
      print('Method-GetRequest');
      response = await _dio.get(API.BASE_URL + endPoint,
          queryParameters: queryParameters,
          cancelToken: _cancelToken,
          options: Options(
            headers: {
              'Accept': API.ACCEPT,
              'Authorization':
                  'Bearer ${SharedPref.instance.sharedPreferences.getString('bearer_token')}'
            },
            sendTimeout: 20,
          ));
      print('response-:$response');
    } on TimeoutException {
      throw PlatformException(
        code: '0',
        message: AppStrings.TIME_OUT,
      );
    } on DioError {
      throw PlatformException(
        code: '0',
        message: AppStrings.DIO_ERROR,
      );
    }
    return response;
  }

////////////////// Post Request /////////////////////////
  Future<Response> postRequest({String endPoint, FormData formData}) async {
    Response response;
    try {
      // CancelToken _cancelToken = CancelToken();
      // debugger();
      print('Method-PostRequest');
      response = await _dio.post(API.BASE_URL + endPoint,
          data: formData,
          cancelToken: _cancelToken,
          options: Options(
            // headers: {'Accept': API.ACCEPT, 'Authentication': 'Bearer'},
            sendTimeout: 20,
          ));
      print('response-:$response');
    } on TimeoutException {
      throw PlatformException(
        code: '0',
        message: AppStrings.TIME_OUT,
      );
    } on DioError {
      throw PlatformException(
        code: '0',
        message: AppStrings.DIO_ERROR,
      );
    }
    return response;
  }

  Future<Response> authPostRequest(
      {String endPoint, FormData formData, String bearerToken}) async {
    Response response;
    try {
      // debugger();
      print('Method-authPostRequest');
      response = await _dio.post(API.BASE_URL + endPoint,
          data: formData,
          cancelToken: _cancelToken,
          options: Options(
            headers: {
              'Accept': API.ACCEPT,
              'Authorization': 'Bearer $bearerToken'
            },
            sendTimeout: 20,
          ));
      print('response-:$response');
    } on TimeoutException {
      throw PlatformException(
        code: '0',
        message: AppStrings.TIME_OUT,
      );
    } on DioError {
      throw PlatformException(
        code: '0',
        message: AppStrings.DIO_ERROR,
      );
    }
    return response;
  }

  // Future<Response> authGetRequest(
  //     {String endPoint, FormData formData, String bearer_token}) async {
  //   Response response;
  //   try {
  //     response = await _dio.get(API.BASE_URL + endPoint,
  //         data: formData,
  //         options: Options(
  //           headers: {
  //             'Accept': API.ACCEPT,
  //             'Authorization': 'Bearer $bearer_token'
  //           },
  //           sendTimeout: 20,
  //         ));
  //   } on TimeoutException catch (e) {
  //     AppNavigation.showToast(message: e.message);
  //     print('$endPoint TimeOut: ' + e.message);
  //   } on DioError catch (e) {
  //     AppNavigation.showToast(message: e.message);
  //     print('$endPoint Dio: ' + e.message);
  //   }
  //   return response;
  // }

////////////////// Delete Request /////////////////////////
  Future<Response> deleteRequest(
      {String endPoint, Map<String, dynamic> queryParameters}) async {
    Response response;
    try {
      // CancelToken _cancelToken = CancelToken();
      // debugger();
      print('Method-deleteRequest');
      response = await _dio.delete(API.BASE_URL + endPoint,
          queryParameters: queryParameters,
          cancelToken: _cancelToken,
          options: Options(
            headers: {
              'Accept': API.ACCEPT,
              'Authentication': '',
            },
            sendTimeout: 20,
          ));
      print('response-:$response');
    } on TimeoutException {
      throw PlatformException(
        code: '0',
        message: AppStrings.TIME_OUT,
      );
    } on DioError {
      throw PlatformException(
        code: '0',
        message: AppStrings.DIO_ERROR,
      );
    }

    return response;
  }

  ////////////////// Validate Response /////////////////////
  void validateResponse({
    Response response,
    var status,
    var message,
  }) {
    AppNavigation.showToast(message: message);

    if (response.statusCode == API.SUCCESS_CODE) {
      if (status != API.API_SUCCESS_STATUS) {
        throw Exception('Network Failure');
      } else if (status != AppStrings.UNAUTHENTICATED) {
        throw AuthException();
      }
    }
  }
}
