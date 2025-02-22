import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/brand/brand_event.dart';
import 'package:mobile/blocs/brand/brand_state.dart';
import 'package:mobile/data/repositories/brand_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _brandRepository;

  BrandBloc(this._brandRepository)
      : super(BrandState(pageable: Pageable(page: 1, size: 20))) {
    on<GetBrands>(_onGetBrands);
    on<GetBrandById>(_onGetBrandById);
  }

  Future<void> _onGetBrands(
    GetBrands event,
    Emitter<BrandState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final brands = await _brandRepository.getBrands(
          state.pageable, state.filter ?? '', state.search ?? '');
      debugPrint('brand: $brands');

      emit(state.copyWith(
        brands: brands,
        isLoading: false,
        pageable: Pageable(
          page: state.pageable.page,
          size: 20,
        ),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onGetBrandById(
    GetBrandById event,
    Emitter<BrandState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final brand = await _brandRepository.getBrandById(event.id);
      emit(state.copyWith(brand: brand, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
