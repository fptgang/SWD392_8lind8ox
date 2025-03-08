import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:openapi/api.dart';

abstract class PromotionState {}

class PromotionPaginationState implements PromotionState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const PromotionPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  PromotionPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return PromotionPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class PromotionLoadingState implements PromotionState {
  final bool isLoading;
  final String? error;

  const PromotionLoadingState({
    this.isLoading = false,
    this.error,
  });

  PromotionLoadingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return PromotionLoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PromotionDataState implements PromotionState {
  final PaginationResponseGeneric<PromotionModel>? promotionResponseModel;
  final PromotionModel? promotion;
  final String? filter;
  final String? search;

  const PromotionDataState({
    this.promotionResponseModel,
    this.promotion,
    this.filter,
    this.search,
  });

  PromotionDataState copyWith({
    PaginationResponseGeneric<PromotionModel>? promotionResponseModel,
    PromotionModel? promotion,
    String? filter,
    String? search,
  }) {
    return PromotionDataState(
      promotionResponseModel: promotionResponseModel ?? this.promotionResponseModel,
      promotion: promotion ?? this.promotion,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}