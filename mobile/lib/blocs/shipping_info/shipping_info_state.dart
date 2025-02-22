import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:openapi/api.dart';

class ShippingInfoState {
  Pageable pageable;
  final String? filter;
  final String? search;
  final bool? isLoading;
  final PaginationResponseGeneric<GetShippingInfos200Response>? shippingInfoResponseModel;
  final ShippingInfoModel? shippingInfo;
  final String? error;

  ShippingInfoState({
    Pageable? pageable,
    this.filter,
    this.search,
    this.isLoading,
    this.shippingInfoResponseModel,
    this.shippingInfo,
    this.error,
  }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

  ShippingInfoState copyWith({
    Pageable? pageable,
    String? filter,
    String? search,
    bool? isLoading,
    final PaginationResponseGeneric<GetShippingInfos200Response>? shippingInfoResponseModel,
    ShippingInfoModel? shippingInfo,
    String? error,
  }) {
    return ShippingInfoState(
      pageable: pageable ?? this.pageable,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      shippingInfoResponseModel: shippingInfoResponseModel ?? this.shippingInfoResponseModel,
      shippingInfo: shippingInfo ?? this.shippingInfo,
      error: error ?? this.error,
    );
  }
}
