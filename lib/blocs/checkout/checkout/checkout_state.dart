part of 'checkout_cubit.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  const CheckoutLoaded({this.checkoutModel});
  final CheckoutModel checkoutModel;
  @override
  List<Object> get props => [checkoutModel];
}

class CheckoutFailed extends CheckoutState {
  const CheckoutFailed({this.message});

  final String message;
  @override
  List<Object> get props => [message];
}

class UnAuthenticated extends CheckoutState {}
