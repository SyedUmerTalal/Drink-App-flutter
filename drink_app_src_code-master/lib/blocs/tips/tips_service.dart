import 'dart:convert';
import 'dart:developer';

import 'package:drink/blocs/deal_alert/deal_alert_model.dart';
import 'package:drink/utility/constants.dart';
import 'package:http/http.dart' as http;

abstract class TipsService {
  Future<BaseModel> postTipAmount(int orderId,int amount);

}
// https://webprojectmockup.com/drinkapp_mobile/api/tip?order_id=3&tip_amount=12
class TipsServiceImp implements TipsService {
  @override
  Future<BaseModel> postTipAmount(int orderId,int amount) async {
    final String currentUserId =
        SharedPref.instance.sharedPreferences.getString('currentUserId');
    // debugger();
    final http.Response response = await http.post(
        Uri.parse(API.BASE_URL + API.TIP + '?order_id=$orderId&tip_amount=$amount'),
        headers: {
          'content-type': 'application/json'
        }).timeout(Duration(seconds: 25));
    // debugger();
    final BaseModel _baseModel =
    BaseModel.fromJson(jsonDecode(response.body));
    return _baseModel;
  }

}


class BaseModel {

  BaseModel({
    int status,
    String message}){
    _status = status;
    _message = message;
  }


  BaseModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }


  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

  int _status;
  String _message;

  int get status => _status;
  String get message => _message;

}