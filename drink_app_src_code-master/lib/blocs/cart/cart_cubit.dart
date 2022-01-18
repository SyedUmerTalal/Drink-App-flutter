import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:drink/models/cart_model.dart';
import 'package:drink/models/drink.dart';
import 'package:drink/repositories/cart_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this.cartRepository) : super(CartState.initial());
  final CartRepository cartRepository;
  void addProduct(Drink product) {
    final List<CartModel> products = [];
    products.addAll(state.products);
    if (products.any((item) => item.drink == product)) {
      final CartModel update =
          products.firstWhere((item) => item.drink == product);
      final int quantity = update.qty + 1;
      final int index = products.indexOf(update);

      products[index] = CartModel(drink: product, qty: quantity);
      emit(CartState.updateQuantity(
          myproducts: products,
          quantity: state.total + double.parse(product.price)));
    } else {
      products.add(CartModel(drink: product, qty: 1));
      emit(CartState.updateQuantity(
          myproducts: products,
          quantity: state.total + double.parse(product.price)));
    }
  }

  Future<void> emptyCart() async {
    if (state.products.isNotEmpty) {
      cartRepository.emptyCart();
    }
    emit(CartState.initial());
  }

  ///ARK Changes
  Future<void> emptyCart1(String id) async {
    if (state.products.isNotEmpty) {
      cartRepository.emptyCart();
    }
    emit(CartState.afterinitial(id));
  }

  Future<void> updateInAPI() async {
    try {
      emit(state.copyWith(isLoading: true));
      // debugger();
      await cartRepository.addAllProductsToAPI(state.products);
      // debugger();
      emit(state.copyWith(
        isLoading: false,
        isLoaded: true,
      ));
    } on PlatformException catch (e) {
      emit(
          state.copyWith(isLoading: false, isFailed: true, message: e.message));
    } on SocketException catch (e) {
      emit(
          state.copyWith(isLoading: false, isFailed: true, message: e.message));
    } on AuthException {
      emit(state.copyWith(isUnAuthenticated: true));
    } catch (e) {
      emit(
          state.copyWith(isLoading: false, isFailed: true, message: e.message));
    }
  }

  void removeProduct(Drink product) {
    final List<CartModel> products = [];
    products.addAll(state.products);
    final CartModel update =
        products.firstWhere((item) => item.drink == product);
    if (update.qty == 1) {
      products.remove(update);
    } else {
      final int quantity = update.qty - 1;
      final int index = products.indexOf(update);

      products[index] = CartModel(drink: product, qty: quantity);
    }
    emit(CartState.updateQuantity(
        myproducts: products,
        quantity: state.total - double.parse(product.price)));
  }
}
