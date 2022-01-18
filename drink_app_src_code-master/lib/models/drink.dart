import 'dart:convert';
import 'package:drink/utility/strings.dart';
import 'package:equatable/equatable.dart';

// To parse this JSON data, do
//
//     final drinkResponse = drinkResponseFromJson(jsonString);

DrinkResponse drinkResponseFromJson(
  String str,
  int categoryID,
) =>
    DrinkResponse.fromJson(
      json.decode(str),
      categoryID,
    );

String drinkResponseToJson(DrinkResponse data) => json.encode(data.toJson());

class DrinkResponse {
  DrinkResponse({
    this.status,
    this.message,
    this.data,
  });
  factory DrinkResponse.fromJson(
    Map<String, dynamic> json,
    int categoryID,
  ) =>
      DrinkResponse(
        status: json['status'],
        message: json['message'],
        data: List<Drink>.from(
          json['data'].map(
            (x) => Drink.fromJson(x, categoryID),
          ),
        ),
      );

  int status;
  String message;
  List<Drink> data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Drink extends Equatable {
  Drink({
    this.id,
    this.name,
    this.price,
    this.picture,
    this.description,
    this.category,
  });

  int id;
  String name;
  String price;
  String picture;
  String description;
  final String category;

  factory Drink.fromJson(
    Map<String, dynamic> json,
    int categoryID,
  ) =>
      Drink(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        picture: json['picture'],
        description: json['description'],
        category: categoryID == 1 ? AppStrings.SMOOTHIE : AppStrings.SOFT_DRINK,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'picture': picture,
        'description': description,
      };

  @override
  List<Object> get props => [
        id,
        name,
        price,
        picture,
        description,
        category,
      ];
}
