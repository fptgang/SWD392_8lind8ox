import 'package:mobile/data/models/brand_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:openapi/api.dart';

abstract class BrandState {}

class BrandPaginationState implements BrandState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const BrandPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  BrandPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return BrandPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class BrandLoadingState implements BrandState {
  final bool isLoading;
  final String? error;

  const BrandLoadingState({
    this.isLoading = false,
    this.error,
  });

  BrandLoadingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return BrandLoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class BrandDataState implements BrandState {
  final PaginationResponseGeneric<BrandModel>? brands;
  final BrandModel? brand;
  final String? filter;
  final String? search;

  const BrandDataState({
    this.brands,
    this.brand,
    this.filter,
    this.search,
  });

  BrandDataState copyWith({
    PaginationResponseGeneric<BrandModel>? brands,
    BrandModel? brand,
    String? filter,
    String? search,
  }) {
    return BrandDataState(
      brands: brands ?? this.brands,
      brand: brand ?? this.brand,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}