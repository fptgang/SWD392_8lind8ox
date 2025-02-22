import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/promotion/promotion_event.dart';
import 'package:mobile/blocs/promotion/promotion_state.dart';
import 'package:mobile/data/repositories/promotion_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final PromotionRepository _promotionRepository;

  PromotionBloc(this._promotionRepository)
      : super(PromotionState(pageable: Pageable(page: 1, size: 20))) {
    on<GetPromotions>(_onGetPromotions);
    on<GetPromotionById>(_onGetPromotionById);
  }

  Future<void> _onGetPromotions(
      GetPromotions event,
      Emitter<PromotionState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final promotions = await _promotionRepository.getPromotions(
          state.pageable,
          state.filter ?? '',
          state.search ?? ''
      );
      debugPrint('promotion: $promotions');

      emit(state.copyWith(
        promotionResponseModel: promotions,
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

  Future<void> _onGetPromotionById(
      GetPromotionById event,
      Emitter<PromotionState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final promotion = await _promotionRepository.getPromotionById(event.id);
      emit(state.copyWith(
          promotion: promotion,
          isLoading: false
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}