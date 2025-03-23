import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:openapi/api.dart';

abstract class VoucherState {}

class VoucherPaginationState implements VoucherState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const VoucherPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  VoucherPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return VoucherPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class VoucherLoadingState implements VoucherState {
  final bool isLoading;
  final String? error;

  const VoucherLoadingState({
    this.isLoading = false,
    this.error,
  });

  VoucherLoadingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return VoucherLoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class VoucherDataState implements VoucherState {
  final PaginationResponseGeneric<VoucherModel>? voucherResponseModel;
  final VoucherModel? voucher;
  final String? filter;
  final String? search;

  const VoucherDataState({
    this.voucherResponseModel,
    this.voucher,
    this.filter,
    this.search,
  });

  VoucherDataState copyWith({
    PaginationResponseGeneric<VoucherModel>? voucherResponseModel,
    VoucherModel? voucher,
    String? filter,
    String? search,
  }) {
    return VoucherDataState(
      voucherResponseModel: voucherResponseModel ?? this.voucherResponseModel,
      voucher: voucher ?? this.voucher,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}