import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/enum/enum.dart';

class CheckoutState extends Equatable {
  final CartModel? cartModelToCheckout;
  final int? accountId;
  final bool? loading;
  final String? error;
  
  // Form state properties
  final PaymentMethod? selectedPaymentMethod;
  final PromotionModel? selectedVoucher;
  final bool termsAccepted;
  final bool isOrderCreated;

  const CheckoutState({
    this.cartModelToCheckout,
    this.accountId,
    this.loading, 
    this.error,
    this.selectedPaymentMethod = PaymentMethod.PAYPAL,
    this.selectedVoucher,
    this.termsAccepted = false,
    this.isOrderCreated = false,
  });

  CheckoutState copyWith({
    CartModel? cartModelToCheckout,
    int? accountId,
    bool? isLoading, 
    String? error,
    PaymentMethod? selectedPaymentMethod,
    PromotionModel? selectedVoucher,
    bool? termsAccepted,
    bool? isOrderCreated,
  }) {
    return CheckoutState(
      cartModelToCheckout: cartModelToCheckout ?? this.cartModelToCheckout,
      accountId: accountId ?? this.accountId,
      loading: isLoading ?? loading,
      error: error ?? this.error,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedVoucher: selectedVoucher ?? this.selectedVoucher,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isOrderCreated: isOrderCreated ?? this.isOrderCreated,
    );
  }

  @override
  List<Object?> get props => [
    cartModelToCheckout,
    accountId,
    loading, 
    error,
    selectedPaymentMethod,
    selectedVoucher,
    termsAccepted,
    isOrderCreated,
  ];
}
