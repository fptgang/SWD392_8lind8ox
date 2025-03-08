import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/models/voucher_model.dart';

class CheckoutState extends Equatable {
  final OrderModel? orders;
  final ShippingInfoModel? shippingInfo;
  final String? selectedPaymentMethod;
  final VoucherModel? selectedVoucher;
  final bool? loading;
  final String? error;

  const CheckoutState({this.orders, this.shippingInfo, this.selectedPaymentMethod, this.selectedVoucher,this.loading, this.error});

  CheckoutState copyWith({OrderModel? orders, ShippingInfoModel? shippingInfo, bool? isLoading, String? error, String? selectedPaymentMethod}) {
    return CheckoutState(
      orders: orders ?? this.orders,
      shippingInfo: shippingInfo ?? shippingInfo,
      selectedPaymentMethod: selectedPaymentMethod ?? selectedPaymentMethod,
      selectedVoucher: selectedVoucher ?? selectedVoucher,
      loading: loading ?? loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [orders, shippingInfo, selectedPaymentMethod,selectedVoucher,loading, error];
}
