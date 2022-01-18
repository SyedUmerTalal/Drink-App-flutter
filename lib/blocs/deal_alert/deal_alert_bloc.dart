import 'dart:developer';
import 'dart:io';

import 'package:drink/blocs/deal_alert/deal_alert_model.dart';
import 'package:drink/blocs/deal_alert/deal_alert_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'deal_alert_exception.dart';
import 'deal_alert_state.dart';
import 'deal_alert_event.dart';

class DealAlertBloc extends Bloc<DealAlertEvents, DealAlertState> {
  DealAlertBloc({this.dealAlertService}) : super(PostInitState());
  DealAlertService dealAlertService;
  List<DealAlertModel> dealAlertList;
  bool currentState = false;

  @override
  Stream<DealAlertState> mapEventToState(DealAlertEvents event) async* {
    // debugger();
    switch (event) {
      case DealAlertEvents.fetchDealAlert:
      // debugger();
        currentState = false;
        yield PostLoadingState();
        try {
          dealAlertList = await dealAlertService.getDealAlertList();
          // debugger();
          currentState = true;
          yield PostLoadedState(dealalert: dealAlertList);
        } on HttpException {
          currentState = false;
          yield PostListErrorState(
              error: NoServiceFoundException(message: 'No Service Found'));
        } on FormatException {
          yield PostListErrorState(
              error:
              InvalidFormatException(message: 'Invalid Response Format'));
        } catch (e) {
          yield PostListErrorState(
              error: UnknownException(message: 'UnknownException'));
        }
        break;
      case DealAlertEvents.againfetchDealAlert:
        // debugger();
        currentState = false;
        yield PostLoadingState(isagain: true);
        try {
          dealAlertList = await dealAlertService.getDealAlertList();
          // debugger();
          currentState = true;
          yield PostAgainLoadedState(dealalert: dealAlertList);
        } on HttpException {
          currentState = false;
          yield PostListErrorState(
              error: NoServiceFoundException(message: 'No Service Found'),isagain: true);
        } on FormatException {
          yield PostListErrorState(
              error:
                  InvalidFormatException(message: 'Invalid Response Format'),isagain: true);
        } catch (e) {
          yield PostListErrorState(
              error: UnknownException(message: 'UnknownException'),isagain: true);
        }
        break;
      case DealAlertEvents.readDealAlert:
        yield PostLoadingState();
        try {
          await dealAlertService.readDealAlertList();
          // debugger();
          yield PostReadState();
        } on HttpException {
          yield PostListErrorState(
              error: NoServiceFoundException(message: 'No Service Found'));
        } on FormatException {
          yield PostListErrorState(
              error:
                  InvalidFormatException(message: 'Invalid Response Format'));
        } catch (e) {
          yield PostListErrorState(
              error: UnknownException(message: 'UnknownException'));
        }
        break;
    }
  }
}
