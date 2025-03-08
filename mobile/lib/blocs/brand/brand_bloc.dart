import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/brand/brand_event.dart';
import 'package:mobile/blocs/brand/brand_state.dart';
import 'package:mobile/data/models/brand_model.dart';
import 'package:mobile/data/repositories/brand_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _brandRepository;
  final PagingController<int, BrandModel> pagingController;

  BrandPaginationState _paginationState;
  BrandDataState _dataState;

  BrandBloc(this._brandRepository)
      : _paginationState = BrandPaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const BrandDataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(BrandLoadingState()) {
    on<GetBrands>(_onGetBrands);
    on<GetBrandById>(_onGetBrandById);
    // on<SelectBrand>(_onSelectBrand);
  }

  // void _onSelectBrand(
  //     SelectBrand event,
  //     Emitter<BrandState> emit,
  //     ) {
  //   _dataState = _dataState.copyWith(filter: event.brand);
  //   emit(_dataState);
  // }

  Future<void> _onGetBrands(
      GetBrands event,
      Emitter<BrandState> emit,
      ) async {
    emit(BrandLoadingState(isLoading: true));

    try {
      final pageable = Pageable(
          page: event.pageKey,
          size: 20,
          sort: ['desc']
      );

      final brands = await _brandRepository.getBrands(
          pageable,
          _dataState.filter ?? '',
          _dataState.search ?? ''
      );
      debugPrint('brand: $brands');

      final isLastPage = brands.content.length < pageable.size;

      if (isLastPage) {
        pagingController.appendLastPage(brands.content);
      } else {
        pagingController.appendPage(
            brands.content,
            event.pageKey + 1
        );
      }

      _paginationState = _paginationState.copyWith(
        pageable: pageable,
        hasReachedEnd: isLastPage,
      );

      _dataState = _dataState.copyWith(brands: brands);
      emit(_dataState);
    } catch (error) {
      pagingController.error = error;
      emit(BrandLoadingState(error: error.toString(), isLoading: false));
    }
  }

  Future<void> _onGetBrandById(
      GetBrandById event,
      Emitter<BrandState> emit,
      ) async {
    emit(BrandLoadingState(isLoading: true));

    try {
      final brand = await _brandRepository.getBrandById(event.id);
      _dataState = _dataState.copyWith(brand: brand);
      emit(_dataState);
    } catch (e) {
      emit(BrandLoadingState(error: e.toString()));
    }
  }
}