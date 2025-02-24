import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:openapi/api.dart';

class VoucherState {
  Pageable pageable;
  final String? filter;
  final String? search;
  final bool? isLoading;
  final PaginationResponseGeneric<GetVouchers200Response>? voucherResponseModel;
  final VoucherModel? voucher;
  final String? error;

  VoucherState({
    Pageable? pageable,
    this.filter,
    this.search,
    this.isLoading,
    this.voucherResponseModel,
    this.voucher,
    this.error,
  }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

  VoucherState copyWith({
    Pageable? pageable,
    String? filter,
    String? search,
    bool? isLoading,
    final PaginationResponseGeneric<GetVouchers200Response>? voucherResponseModel,
    VoucherModel? voucher,
    String? error,
  }) {
    return VoucherState(
      pageable: pageable ?? this.pageable,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      voucherResponseModel: voucherResponseModel ?? this.voucherResponseModel,
      voucher: voucher ?? this.voucher,
      error: error ?? this.error,
    );
  }
}
