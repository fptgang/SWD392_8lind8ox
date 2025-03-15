import '../../../data/models/cart_model.dart';

class CartState {
  final List<CartDisplayItem> items;
  final List<int> selectedItemIds;
  final bool isLoading;
  final String? error;
  final String? isEmpty;

  const CartState({
    this.items = const [],
    this.selectedItemIds = const [],
    this.isLoading = false,
    this.error,
    this.isEmpty,
  });

  CartState copyWith({
    List<CartDisplayItem>? items,
    List<int>? selectedItemIds,
    bool? isLoading,
    String? error,
    String? isEmpty,
  }) {
    return CartState(
      items: items ?? this.items,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  // Helper to get total price
  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  // Helper to get total items considering quantities
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
