// cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/models/voucher_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  final Set<int> selectedItemIds; // Set of selected item IDs
  final double total;
  final double originalTotal;
  final bool isLoading;
  final String? error;
  final VoucherModel? voucher;
  final ShippingInfoModel? shippingInfo;
  final int? accountId;

  const CartState({
    this.items = const [],
    this.selectedItemIds = const {}, // Default as empty set
    this.total = 0.0,
    this.originalTotal = 0.0,
    this.isLoading = false,
    this.error,
    this.voucher,
    this.shippingInfo,
    this.accountId,
  });

  CartState copyWith({
    List<CartItemModel>? items,
    Set<int>? selectedItemIds,
    double? total,
    double? originalTotal,
    bool? isLoading,
    String? error,
    VoucherModel? voucher,
    ShippingInfoModel? shippingInfo,
    int? accountId,
    bool clearError = false,
    bool clearVoucher = false,
    bool clearShippingInfo = false,
    bool clearSelectedItems = false,
  }) {
    return CartState(
      items: items ?? this.items,
      selectedItemIds: clearSelectedItems ? {} : (selectedItemIds ?? this.selectedItemIds),
      total: total ?? this.total,
      originalTotal: originalTotal ?? this.originalTotal,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      voucher: clearVoucher ? null : (voucher ?? this.voucher),
      shippingInfo:
          clearShippingInfo ? null : (shippingInfo ?? this.shippingInfo),
      accountId: accountId ?? this.accountId,
    );
  }

  // Helper getters
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  
  // Selected items getters
  List<CartItemModel> get selectedItems => 
      items.where((item) => selectedItemIds.contains(item.id)).toList();
      
  int get selectedItemCount => 
      selectedItems.fold(0, (sum, item) => sum + item.quantity);
      
  bool get hasSelectedItems => selectedItemIds.isNotEmpty;
  
  bool isItemSelected(int itemId) => selectedItemIds.contains(itemId);
  
  // Calculate totals based on selected items only
  double get selectedItemsTotal => 
      selectedItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
      
  double get selectedItemsOriginalTotal => 
      selectedItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  double get savings => originalTotal - total;

  double get voucherDiscount => voucher != null
      ? (voucher!.discountRate ?? 0) > 0
          ? _calculateVoucherDiscount()
          : 0
      : 0;
      
  double get selectedItemsVoucherDiscount => voucher != null 
      ? (voucher!.discountRate ?? 0) > 0 && hasSelectedItems
          ? calculateVoucherDiscountOnSelected()
          : 0
      : 0;

  double get finalTotal => hasSelectedItems 
      ? selectedItemsTotal - (hasSelectedItems ? calculateVoucherDiscountOnSelected() : 0)
      : total - voucherDiscount;

  double _calculateVoucherDiscount() {
    if (voucher == null) return 0;

    final discountAmount = total * ((voucher!.discountRate ?? 0) / 100);
    final maxDiscount = voucher!.limitAmount ?? double.infinity;

    return discountAmount > maxDiscount ? maxDiscount : discountAmount;
  }
  
  // Calculate voucher discount based on selected items only
  double calculateVoucherDiscountOnSelected() {
    if (voucher == null || !hasSelectedItems) return 0;

    final discountAmount = selectedItemsTotal * ((voucher!.discountRate ?? 0) / 100);
    final maxDiscount = voucher!.limitAmount ?? double.infinity;

    return discountAmount > maxDiscount ? maxDiscount : discountAmount;
  }

  @override
  List<Object?> get props => [
        items,
        selectedItemIds,
        total,
        originalTotal,
        isLoading,
        error,
        voucher,
        shippingInfo,
        accountId,
      ];
}
