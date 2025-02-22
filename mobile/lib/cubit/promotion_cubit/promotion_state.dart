import 'package:mobile/data/models/brands_response_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:openapi/api.dart';

class PromotionState {
  Pageable pageable;
  final String? filter;
  final String? search;
  final bool? isLoading;
  final PaginationResponseGeneric<GetPromotionalCampaigns200Response>? promotionResponseModel;
  final PromotionModel? promotion;
  final String? error;

  PromotionState({
    Pageable? pageable,
    this.filter,
    this.search,
    this.isLoading,
    this.promotionResponseModel,
    this.promotion,
    this.error,
  }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

  PromotionState copyWith({
    Pageable? pageable,
    String? filter,
    String? search,
    bool? isLoading,
    final PaginationResponseGeneric<GetPromotionalCampaigns200Response>? promotionResponseModel,
    PromotionModel? promotion,
    String? error,
  }) {
    return PromotionState(
      pageable: pageable ?? this.pageable,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      promotionResponseModel: promotionResponseModel ?? this.promotionResponseModel,
      promotion: promotion ?? this.promotion,
      error: error ?? this.error,
    );
  }
}
