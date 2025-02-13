import '../../data/models/cart_model.dart';

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;
  final String? isEmpty;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.isEmpty,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
    String? isEmpty,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}