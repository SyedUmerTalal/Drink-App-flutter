import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TipsState extends Equatable {
  @override
  List<Object> get props => [];
}

class TipsInitialState extends TipsState {}

class TipsLoadingState extends TipsState {}

class TipsLoadedState extends TipsState {
  TipsLoadedState({@required this.message});

  final String message;
}

class TipsFailedState extends TipsState {
  TipsFailedState({@required this.message});

  final String message;
}

class UnAuthenticated extends TipsState {}
