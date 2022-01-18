part of 'cart_cubit.dart';

///ARK Changes
class CartState extends Equatable {
  ///ARK Changes
  const CartState(
      {this.products,
      this.total,
      this.isLoading,
      this.isLoaded,
      this.isFailed,
      this.isUnAuthenticated,
      this.message,
      this.moveToProduct,
      this.pid});

  factory CartState.initial() {
    return CartState(
        products: const [],
        total: 0.0,
        isLoading: false,
        isLoaded: false,
        isFailed: false,
        message: '',
        moveToProduct: false,
        pid: '0');
  }

  ///ARK Changes
  factory CartState.afterinitial(String id) {
    return CartState(
        products: const [],
        total: 0.0,
        isLoading: false,
        isLoaded: false,
        isFailed: false,
        message: '',
        moveToProduct: true,
        pid: id);
  }

  factory CartState.updateQuantity(
      {List<CartModel> myproducts, double quantity}) {
    return CartState(
      products: myproducts,
      total: quantity,
      isLoaded: false,
      isLoading: false,
      isFailed: false,
      message: '',
      moveToProduct: false,
      pid: '0'
    );
  }

  CartState copyWith(
      {bool isLoading,
      bool isLoaded,
      bool isFailed,
      bool isUnAuthenticated,
      String message}) {
    return CartState(
      products: products,
      total: total,
      isLoaded: isLoaded ?? this.isLoaded,
      isLoading: isLoading ?? this.isLoading,
      isFailed: isFailed ?? this.isFailed,
      isUnAuthenticated: isUnAuthenticated ?? this.isUnAuthenticated,
      message: message ?? this.message,
    );
  }

  final List<CartModel> products;
  final double total;
  final bool isLoading;
  final bool isLoaded;
  final bool isFailed;
  final bool isUnAuthenticated;
  ///ARK Changes
  final String message;
  final bool moveToProduct;

  final String pid;

  @override
  List<Object> get props => [
        products,
        total,
        isLoading,
        isLoaded,
        isFailed,
      ];
}
