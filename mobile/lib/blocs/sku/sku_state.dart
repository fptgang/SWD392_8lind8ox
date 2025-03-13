import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:openapi/api.dart';


abstract class StockKeepingUnitsState {}

class SkuPaginationState implements StockKeepingUnitsState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const SkuPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  SkuPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return SkuPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class SkuLoadingState implements StockKeepingUnitsState{
  final bool isLoading;
  final String? error;

  const SkuLoadingState({
    this.isLoading = false,
    this.error,
  });

  SkuLoadingState copyWith({
    bool? isLoading,
    String? error,
    bool? isOutOfStock,
  }) {
    return SkuLoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SkuDataState implements StockKeepingUnitsState{
  final PaginationResponseGeneric<StockKeepingUnitModel>? skus;
  final String? imageUrl;
  final String? filter;

  const SkuDataState({
    this.skus,
    this.imageUrl,
    this.filter,
  });

  SkuDataState copyWith({
    PaginationResponseGeneric<StockKeepingUnitModel>? skus,
    String? imageUrl,
    String? filter
  }) {
    return SkuDataState(
      skus: skus ?? this.skus,
      imageUrl: imageUrl ?? this.imageUrl,
      filter: filter ?? this.filter,
    );
  }
}

