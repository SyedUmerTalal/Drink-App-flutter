import 'dart:io';

import 'package:drink/blocs/tips/tips_service.dart';
import 'package:drink/blocs/tips/tips_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TipsCubit extends Cubit<TipsState> {
  TipsCubit({this.tipsservice}) : super(TipsInitialState());
  final TipsService tipsservice;

  Future<void> postTips(int orderId,int amount) async {
    emit(TipsLoadingState());
    try {
      final response = await tipsservice.postTipAmount(orderId,amount);
      emit(TipsLoadedState(message: response.message));
    } on PlatformException catch (e) {
      emit(TipsFailedState(message: e.message));
    } on SocketException catch (e) {
      emit(TipsFailedState(message: e.message));
    } catch (e) {
      emit(TipsFailedState(message: e.toString()));
    }
  }
}
