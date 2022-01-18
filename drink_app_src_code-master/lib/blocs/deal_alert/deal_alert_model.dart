/// status : 1
/// message : "success"
/// data : [{"id":3,"title":"$1 Hard Shell Tacos","description":"$1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos","type":"Local Happy Hour","status":1,"created_by":null,"created_at":"2021-09-30 05:13:47","updated_at":"2021-09-30 09:50:18"},{"id":2,"title":"$6.99 Boneless Wings from Monday To Saturday","description":"$6.99 Boneless Wings from Monday To Saturday $6.99 Boneless Wings from Monday To Saturday $6.99 Boneless Wings from Monday To Saturday","type":"Local Happy Hour","status":1,"created_by":null,"created_at":"2021-09-30 05:10:34","updated_at":"2021-09-30 10:38:16"},{"id":1,"title":"Now Get All Coke Starting at $10 Only","description":"Now Get All Coke Starting at $10 Only Now Get All Coke Starting at $10 Only Now Get All Coke Starting at $10 Only","type":"Restaurant Happy Hour","status":1,"created_by":"Admin","created_at":"2021-09-30 05:10:34","updated_at":"2021-09-30 10:37:56"}]

class BaseResponseDealAlertModel {
  int _status;
  String _message;
  List<DealAlertModel> _data;

  int get status => _status;

  String get message => _message;

  List<DealAlertModel> get data => _data;

  BaseResponseDealAlertModel(
      {int status, String message, List<DealAlertModel> data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  /*{
        "id": 1,
        "title": "Now Get All Coke Starting at $10 Only",
        "description": "Now Get All Coke Starting at $10 Only Now Get All Coke Starting at $10 Only Now Get All Coke Starting at $10 Only",
        "is_read": 1
    }*/

  BaseResponseDealAlertModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(DealAlertModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 3
/// title : "$1 Hard Shell Tacos"
/// description : "$1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos $1 Hard Shell Tacos"
/// type : "Local Happy Hour"
/// status : 1
/// created_by : null
/// created_at : "2021-09-30 05:13:47"
/// updated_at : "2021-09-30 09:50:18"

class DealAlertModel {
  int _id;
  String _title;
  String _description;
  int _is_read;

  int get id => _id;

  String get title => _title;

  String get description => _description;

  int get is_read => _is_read;

  DealAlertModel({int id, String title, String description, int is_read}) {
    _id = id;
    _title = title;
    _description = description;
    _is_read = is_read;
  }

  DealAlertModel.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _description = json["description"];
    _is_read = json["is_read"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["description"] = _description;
    map["is_read"] = _is_read;
    return map;
  }

  static List<DealAlertModel> parseList(dynamic data) {
    List<DealAlertModel> _li = [];
    data.forEach((each) {
      _li.add(DealAlertModel.fromJson(each));
    });
    return _li;
  }
}
