import 'package:drink/blocs/deal_alert/deal_alert_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DealAlertState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostInitState extends DealAlertState {
}

class PostLoadingState extends DealAlertState {
  PostLoadingState({this.isagain});
  bool isagain = false;
}

class PostReadState extends DealAlertState {

}

class PostLoadedState extends DealAlertState {
  PostLoadedState({@required this.dealalert,this.isagain});

  final List<DealAlertModel> dealalert;
  bool isagain = false;
}

class PostAgainLoadedState extends DealAlertState {
  PostAgainLoadedState({@required this.dealalert});

  final List<DealAlertModel> dealalert;

}

class PostListErrorState extends DealAlertState {
  PostListErrorState({this.error,this.isagain});
  bool isagain = false;
  final error;
}
