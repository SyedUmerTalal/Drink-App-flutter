import 'dart:convert';

import 'package:equatable/equatable.dart';

CreditCardResponse creditCardResponseFromJson(String str) =>
    CreditCardResponse.fromJson(json.decode(str));

String creditCardResponseToJson(CreditCardResponse data) =>
    json.encode(data.toJson());

class CreditCardResponse {
  CreditCardResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreditCardResponse.fromJson(Map<String, dynamic> json) =>
      CreditCardResponse(
        status: json['status'],
        message: json['message'],
        data: List<CreditCard>.from(
            json['data'].map((x) => CreditCard.fromJson(x))),
      );
  int status;
  String message;
  List<CreditCard> data;

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CreditCard extends Equatable {
  const CreditCard({
    this.id,
    this.brand,
    this.expMonth,
    this.expYear,
    this.lastFour,
  });
  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
        id: json['id'],
        brand: json['brand'],
        expMonth: json['exp_month'],
        expYear: json['exp_year'],
        lastFour: json['last_four'],
      );
  final int id;
  final String brand;
  final int expMonth;
  final int expYear;
  final int lastFour;

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'exp_month': expMonth,
        'exp_year': expYear,
        'last_four': lastFour,
      };

  @override
  List<Object> get props => [id, brand, expMonth, expYear, lastFour];
}
