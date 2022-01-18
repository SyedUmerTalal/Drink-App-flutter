import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:drink/models/cart_model.dart';
import 'package:drink/models/checkout_model.dart';
import 'package:drink/repositories/checkout_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(
    this.checkoutRepository,
  ) : super(CheckoutInitial());
  final CheckoutRepository checkoutRepository;
  bool _isTableReservation = false;
  set isTableReservation(bool isTableReservation) {
    _isTableReservation = isTableReservation;
  }

  Future<void> placeOrder(int cardID) async {
    try {
      // debugger();
      emit(CheckoutLoading());
      // debugger();
      if (!_isTableReservation) {
        final CheckoutModel checkoutModel =
            await checkoutRepository.placeOrder(cardID);
        // debugger();
        emit(
          CheckoutLoaded(checkoutModel: checkoutModel),
        );
      } else {}
      // debugger();
    } on PlatformException catch (e) {
      // debugger();
      emit(CheckoutFailed(message: e.message));
    } on SocketException catch (e) {
      // debugger();
      emit(CheckoutFailed(message: e.toString() + ' Socket Exception'));
    } on NoSuchMethodError catch (e) {
      // debugger();
      emit(CheckoutFailed(message: e.toString() + ' NoSuchMethodError'));
    } on FormatException catch (e) {
      // debugger();
      emit(CheckoutFailed(message: e.toString() + ' Format Exception'));
    } on AuthException {
      // debugger();
      emit(UnAuthenticated());
    } catch (e) {
      // debugger();
      print(e.toString());
      emit(CheckoutFailed(message: e.toString() + ' Unknown Error'));
    }
  }
}
