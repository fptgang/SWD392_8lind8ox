import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/utils/enum/enum.dart';

class CheckoutState extends Equatable {
  final CartModel? cartModelToCheckout;
  final bool? loading;
  final String? error;

  // Form state properties
  final PaymentMethod? selectedPaymentMethod;
  final PromotionModel? selectedVoucher;
  final bool termsAccepted;
  final bool isOrderCreated;

  const CheckoutState({
    this.cartModelToCheckout,
    this.loading,
    this.error,
    this.selectedPaymentMethod = PaymentMethod.PAYPAL,
    this.selectedVoucher,
    this.termsAccepted = false,
    this.isOrderCreated = false,
  });

  CheckoutState copyWith({
    CartModel? cartModelToCheckout,
    bool? isLoading,
    String? error,
    PaymentMethod? selectedPaymentMethod,
    PromotionModel? selectedVoucher,
    bool? termsAccepted,
    bool? isOrderCreated,
  }) {
    return CheckoutState(
      cartModelToCheckout: cartModelToCheckout ?? this.cartModelToCheckout,
      loading: isLoading ?? loading,
      error: error ?? this.error,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      selectedVoucher: selectedVoucher ?? this.selectedVoucher,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isOrderCreated: isOrderCreated ?? this.isOrderCreated,
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
      ];
}
