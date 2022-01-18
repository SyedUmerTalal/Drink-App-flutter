part of 'get_orders_cubit.dart';

abstract class GetOrdersState extends Equatable {
  const GetOrdersState();

  @override
  List<Object> get props => [];
}

class GetOrdersInitial extends GetOrdersState {}

class GetOrdersLoading extends GetOrdersState {}

class GetOrdersLoaded extends GetOrdersState {
  const GetOrdersLoaded(this.allOrders);

  final List<Order> allOrders;
}

///ARK Changes
class GetOrdersLoadedForDetails extends GetOrdersState {
  const GetOrdersLoadedForDetails(this.order);

  final Order order;
}

class GetOrdersFailed extends GetOrdersState {
  const GetOrdersFailed({this.message});

  final String message;
}

class UnAuthenticated extends GetOrdersState {}
