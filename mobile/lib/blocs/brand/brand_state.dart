import 'package:mobile/data/models/brand_model.dart';
import 'package:mobile/data/models/brands_response_model.dart';
import 'package:openapi/api.dart';

class BrandState {
  Pageable pageable;
  final String? filter;
  final String? search;
  final bool? isLoading;
  final BrandsResponseModel? brands;
  final BrandModel? brand;
  final String? error;

  BrandState({
    Pageable? pageable,
    this.filter,
    this.search,
    this.isLoading,
    this.brands,
    this.brand,
    this.error,
  }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

  BrandState copyWith({
    Pageable? pageable,
    String? filter,
    String? search,
    bool? isLoading,
    BrandsResponseModel? brands,
    BrandModel? brand,
    String? error,
  }) {
    return BrandState(
      pageable: pageable ?? this.pageable,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      brands: brands ?? this.brands,
      brand: brand ?? this.brand,
      error: error ?? this.error,
    );
  }
}
