// cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/models/voucher_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  final double total;
  final double originalTotal;
  final bool isLoading;
  final String? error;
  final VoucherModel? voucher;
  final ShippingInfoModel? shippingInfo;
  final int? accountId;

  const CartState({
    this.items = const [],
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
  }) {
    return CartState(
      items: items ?? this.items,
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

  double get savings => originalTotal - total;

  double get voucherDiscount => voucher != null
      ? (voucher!.discountRate ?? 0) > 0
          ? _calculateVoucherDiscount()
          : 0
      : 0;

  double get finalTotal => total - voucherDiscount;

  double _calculateVoucherDiscount() {
    if (voucher == null) return 0;

    final discountAmount = total * ((voucher!.discountRate ?? 0) / 100);
    final maxDiscount = voucher!.limitAmount ?? double.infinity;

    return discountAmount > maxDiscount ? maxDiscount : discountAmount;
  }

  @override
  List<Object?> get props => [
        items,
        total,
        originalTotal,
        isLoading,
        error,
        voucher,
        shippingInfo,
        accountId,
      ];
}
