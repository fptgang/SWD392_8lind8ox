import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:openapi/api.dart';

abstract class ShippingInfoState {}

class ShippingInfoPaginationState implements ShippingInfoState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const ShippingInfoPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  ShippingInfoPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return ShippingInfoPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class ShippingInfoLoadingState implements ShippingInfoState {
  final bool isLoading;
  final String? error;

  const ShippingInfoLoadingState({
    this.isLoading = false,
    this.error,
  });

  ShippingInfoLoadingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ShippingInfoLoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ShippingInfoDataState implements ShippingInfoState {
  final PaginationResponseGeneric<ShippingInfoModel>? shippingInfoResponseModel;
  final ShippingInfoModel? shippingInfo;
  final ShippingInfoModel? selectedShippingInfo;
  final String? filter;
  final String? search;

  const ShippingInfoDataState({
    this.shippingInfoResponseModel,
    this.shippingInfo,
    this.selectedShippingInfo,
    this.filter,
    this.search,
  });

  ShippingInfoDataState copyWith({
    PaginationResponseGeneric<ShippingInfoModel>? shippingInfoResponseModel,
    ShippingInfoModel? shippingInfo,
    ShippingInfoModel? selectedShippingInfo,
    String? filter,
    String? search,
  }) {
    return ShippingInfoDataState(
      shippingInfoResponseModel: shippingInfoResponseModel ?? this.shippingInfoResponseModel,
      shippingInfo: shippingInfo ?? this.shippingInfo,
      selectedShippingInfo: selectedShippingInfo ?? this.selectedShippingInfo,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }

  List<ShippingInfoModel> get shippingInfos =>
      shippingInfoResponseModel?.content ?? [];

  bool get hasShippingInfos =>
      shippingInfoResponseModel != null && shippingInfoResponseModel!.content.isNotEmpty;
}