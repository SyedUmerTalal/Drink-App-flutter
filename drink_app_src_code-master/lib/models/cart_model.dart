import 'package:drink/models/drink.dart';
import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  const CartModel({
    this.drink,
    this.qty,
  });
  final Drink drink;
  final int qty;

  @override
  List<Object> get props => [drink, qty];
}
