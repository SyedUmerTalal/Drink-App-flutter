import 'dart:convert';

import 'package:drink/blocs/deal_alert/deal_alert_model.dart';
import 'package:drink/utility/constants.dart';
import 'package:http/http.dart' as http;

abstract class DealAlertService {
  Future<List<DealAlertModel>> getDealAlertList();

  Future<List<DealAlertModel>> readDealAlertList();
}

class DealAlertServiceImp implements DealAlertService {
  @override
  Future<List<DealAlertModel>> getDealAlertList() async {
    final String currentUserId =
        SharedPref.instance.sharedPreferences.getString('currentUserId');

    final http.Response response = await http.post(
        Uri.parse(API.BASE_URL + API.DEAL_ALERT + '?user_id=$currentUserId'),
        headers: {
          'content-type': 'application/json'
        }).timeout(Duration(seconds: 25));
    // debugger();
    final BaseResponseDealAlertModel _baseResponseDealAlertModel =
        BaseResponseDealAlertModel.fromJson(jsonDecode(response.body));
    return _baseResponseDealAlertModel.data;
  }

  @override
  Future<List<DealAlertModel>> readDealAlertList() async {
    final String currentUserId =
        SharedPref.instance.sharedPreferences.getString('currentUserId');
    final http.Response response = await http.post(
        Uri.parse(
            API.BASE_URL + API.READ_DEAL_ALERT + '?user_id=$currentUserId'),
        headers: {
          'content-type': 'application/json'
        }).timeout(Duration(seconds: 25));
    // debugger();
    final BaseResponseDealAlertModel _baseResponseDealAlertModel =
        BaseResponseDealAlertModel.fromJson(jsonDecode(response.body));
    return _baseResponseDealAlertModel.data;
  }
}
