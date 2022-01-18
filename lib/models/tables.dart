// To parse this JSON data, do
//
//     final TableResponse = tableResponseFromJson(jsonString);

import 'dart:convert';

TableResponse tableResponseFromJson(String str) =>
    TableResponse.fromJson(json.decode(str));

String tableResponseToJson(TableResponse data) => json.encode(data.toJson());

class TableResponse {
  const TableResponse({
    this.status,
    this.message,
    this.data,
  });
  factory TableResponse.fromJson(Map<String, dynamic> json) => TableResponse(
        status: json['status'],
        message: json['message'],
        data: List<Tables>.from(json['data'].map((x) => Tables.fromJson(x))),
      );
  final int status;
  final String message;
  final List<Tables> data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Tables {
  Tables({
    this.id,
    this.tableName,
    this.seatingCapacity,
    this.price,
    this.description,
    this.picture,
  });
  factory Tables.fromJson(Map<String, dynamic> json) => Tables(
        id: json['id'],
        tableName: json['table_name'],
        seatingCapacity: json['seating_capacity'],
        price: json['price'],
        description: json['description'],
        picture: json['picture'],
      );
  int id;
  String tableName;
  int seatingCapacity;
  int price;
  String description;
  String picture;

  Map<String, dynamic> toJson() => {
        'id': id,
        'table_name': tableName,
        'seating_capacity': seatingCapacity,
        'price': price,
        'description': description,
        'picture': picture,
      };
}
