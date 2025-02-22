import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/cubit/brand_cubit/brand_state.dart';
import 'package:mobile/cubit/promotion_cubit/promotion_state.dart';
import 'package:mobile/cubit/set_cubit/set_state.dart';
import 'package:mobile/data/repositories/brand_repository.dart';
import 'package:mobile/data/repositories/promotion_repository.dart';
import 'package:openapi/api.dart';

import '../../data/repositories/set_repository.dart';

@injectable
@lazySingleton
class PromotionCubit extends Cubit<PromotionState> {
  final PromotionRepository _promotionRepository;

  PromotionCubit(this._promotionRepository) : super(PromotionState(pageable: Pageable(page: 1, size: 20,)));

  void selectCategory(String promotion) {
    emit(state.copyWith(filter: promotion));
  }

  Future<void> getPromotions() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final promotions = await _promotionRepository.getPromotions(
          state.pageable, state.filter ?? '', state.search ?? '');
      debugPrint('brand: $promotions');

      emit(state.copyWith(
        promotionResponseModel: promotions, isLoading: false, pageable: Pageable(
        page: state.pageable.page,
        size: 20,
      ),));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> getPromotionById(int id) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final brand = await _promotionRepository.getPromotionById(id);
      emit(state.copyWith(promotion: brand, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

}
