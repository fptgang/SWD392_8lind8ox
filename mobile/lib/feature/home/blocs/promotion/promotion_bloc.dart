import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/repositories/promotion_repository.dart';
import 'package:openapi/api.dart';

import 'promotion_event.dart';
import 'promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final PromotionRepository _promotionRepository;

  PromotionBloc(this._promotionRepository) : super(const PromotionState()) {
    on<FetchPromotions>(_onFetchPromotions);
    on<RefreshPromotions>(_onRefreshPromotions);
  }

  Future<void> _onFetchPromotions(
    FetchPromotions event,
    Emitter<PromotionState> emit,
  ) async {
    emit(state.copyWith(status: PromotionStatus.loading));
    try {
      final promotions = await _promotionRepository.getPromotions(
        event.pageable,
        event.filter,
        event.search,
      );
      emit(state.copyWith(
        status: PromotionStatus.success,
        promotions: promotions,
      ));
    } catch (e) {
      debugPrint('Error fetching promotions: $e');
      emit(state.copyWith(
        status: PromotionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshPromotions(
    RefreshPromotions event,
    Emitter<PromotionState> emit,
  ) async {
    try {
      final promotions = await _promotionRepository.getPromotions(
        event.pageable,
        event.filter,
        event.search,
      );
      emit(state.copyWith(
        status: PromotionStatus.success,
        promotions: promotions,
      ));
    } catch (e) {
      debugPrint('Error refreshing promotions: $e');
      emit(state.copyWith(
        status: PromotionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
