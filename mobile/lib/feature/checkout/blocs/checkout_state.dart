import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/utils/enum/enum.dart';

class CheckoutState extends Equatable {
  final CartModel? cartModelToCheckout;
  final bool? loading;
  final String? error;

  // Form state properties
  final PaymentMethod? selectedPaymentMethod;
  final VoucherModel? selectedVoucher;
  final bool termsAccepted;
  final bool isOrderCreated;
  final String? redirectUrl;

  const CheckoutState({
    this.cartModelToCheckout,
    this.loading,
    this.error,
    this.selectedPaymentMethod,
    this.selectedVoucher,
    this.termsAccepted = false,
    this.isOrderCreated = false,
    this.redirectUrl,
  });

  CheckoutState copyWith({
    CartModel? cartModelToCheckout,
    bool? isLoading,
    String? error,
    PaymentMethod? selectedPaymentMethod,
    VoucherModel? selectedVoucher,
    bool? termsAccepted,
    bool? isOrderCreated,
    String? redirectUrl,
  }) {
    return CheckoutState(
      cartModelToCheckout: cartModelToCheckout ?? this.cartModelToCheckout,
      loading: isLoading ?? loading,
      error: error,  // Allow setting to null for clearing errors
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedVoucher: selectedVoucher ?? this.selectedVoucher,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isOrderCreated: isOrderCreated ?? this.isOrderCreated,
      redirectUrl: redirectUrl ?? this.redirectUrl,
    );
  }

  @override
  List<Object?> get props => [
    cartModelToCheckout,
    loading,
    error,
    selectedPaymentMethod,
    selectedVoucher,
    termsAccepted,
    isOrderCreated,
    redirectUrl,
  ];
}