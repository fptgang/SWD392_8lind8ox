import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/cubit/brand_cubit/brand_state.dart';
import 'package:mobile/cubit/set_cubit/set_state.dart';
import 'package:mobile/data/repositories/brand_repository.dart';
import 'package:openapi/api.dart';

import '../../data/repositories/set_repository.dart';

@injectable
@lazySingleton
class BrandCubit extends Cubit<BrandState> {
  final BrandRepository _brandRepository;

  BrandCubit(this._brandRepository) : super(BrandState(pageable: Pageable(page: 1, size: 20,)));

  void selectCategory(String category) {
    emit(state.copyWith(filter: category));
  }

  Future<void> getBrands() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final brands = await _brandRepository.getBrands(
          state.pageable, state.filter ?? '', state.search ?? '');
      debugPrint('brand: $brands');

      emit(state.copyWith(
        brands: brands, isLoading: false, pageable: Pageable(
        page: state.pageable.page,
        size: 20,
      ),));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> getBrandById(int id) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final brand = await _brandRepository.getBrandById(id);
      emit(state.copyWith(
          brand: brand, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

}
