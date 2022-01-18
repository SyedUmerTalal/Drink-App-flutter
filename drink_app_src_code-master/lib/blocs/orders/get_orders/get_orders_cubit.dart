import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:drink/models/order.dart';
import 'package:drink/repositories/orders_repository.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'get_orders_state.dart';

class GetOrdersCubit extends Cubit<GetOrdersState> {
  GetOrdersCubit({this.ordersRepository}) : super(GetOrdersInitial());

  final OrdersRepository ordersRepository;

  Future<void> getAllOrders() async {
    emit(GetOrdersLoading());
    try {
      // debugger();
      final List<Order> allOrders = await ordersRepository.getOrders();
      // debugger();
      emit(GetOrdersLoaded(allOrders));
    } on PlatformException catch (e) {
      // debugger();
      // if (e.message == 'Unauthenticated.') {
      //   emit(UnAuthenticated());
      // } else {
      emit(GetOrdersFailed(message: e.message));
      // }
    } on SocketException catch (e) {
      emit(GetOrdersFailed(message: e.message));
    } on AuthException {
      // debugger();
      emit(UnAuthenticated());
    } catch (e) {
      // debugger();
      emit(GetOrdersFailed(message: e.toString()));
    }
  }

  ///ARK Changes
  Future<void> getAllOrdersForDetail(String id) async {
    emit(GetOrdersLoading());
    try {
      // debugger();
      final List<Order> allOrders = await ordersRepository.getOrders();
      // debugger();
      final Order _order = allOrders.firstWhere(
          (element) => element.receipt.id == id,
          orElse: () => Order());
      if (_order != null) {
        emit(GetOrdersLoadedForDetails(_order));
      } else {
        emit(GetOrdersFailed(message: 'No order found.'));
      }
    } on PlatformException catch (e) {
      ///ARK Changes
      // debugger();
      // if (e.message == 'Unauthenticated.') {
      //   emit(UnAuthenticated());
      // } else {
      emit(GetOrdersFailed(message: e.message));
      // }
    } on SocketException catch (e) {
      emit(GetOrdersFailed(message: e.message));
    } on AuthException {
      // debugger();
      emit(UnAuthenticated());
    } catch (e) {
      // debugger();
      emit(GetOrdersFailed(message: e.toString()));
    }
  }
}
