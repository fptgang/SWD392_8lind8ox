import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/promotion/promotion_event.dart';
import 'package:mobile/blocs/promotion/promotion_state.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/repositories/promotion_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final PromotionRepository _promotionRepository;
  final PagingController<int, PromotionModel> pagingController;

  PromotionPaginationState _paginationState;
  PromotionDataState _dataState;

  PromotionBloc(this._promotionRepository)
      : _paginationState = PromotionPaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const PromotionDataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(PromotionLoadingState()) {
    on<GetPromotions>(_onGetPromotions);
    on<GetPromotionById>(_onGetPromotionById);
    on<SelectPromotion>(_onSelectPromotion);
  }

  void _onSelectPromotion(
      SelectPromotion event,
      Emitter<PromotionState> emit,
      ) {
    _dataState = _dataState.copyWith(filter: event.promotion);
    emit(_dataState);
  }

  Future<void> _onGetPromotions(
      GetPromotions event,
      Emitter<PromotionState> emit,
      ) async {
    emit(PromotionLoadingState(isLoading: true));

    try {
      final pageable = Pageable(
          page: event.pageKey,
          size: 20,
          sort: ['desc']
      );

      final promotions = await _promotionRepository.getPromotions(
          pageable,
          _dataState.filter ?? '',
          _dataState.search ?? ''
      );
      debugPrint('promotion: $promotions');

      final isLastPage = promotions.content.length < pageable.size;

      if (isLastPage) {
        pagingController.appendLastPage(promotions.content);
      } else {
        pagingController.appendPage(
            promotions.content,
            event.pageKey + 1
        );
      }

      _paginationState = _paginationState.copyWith(
        pageable: pageable,
        hasReachedEnd: isLastPage,
      );

      _dataState = _dataState.copyWith(promotionResponseModel: promotions);
      emit(_dataState);
    } catch (error) {
      pagingController.error = error;
      emit(PromotionLoadingState(error: error.toString(), isLoading: false));
    }
  }

  Future<void> _onGetPromotionById(
      GetPromotionById event,
      Emitter<PromotionState> emit,
      ) async {
    emit(PromotionLoadingState(isLoading: true));

    try {
      final promotion = await _promotionRepository.getPromotionById(event.id);
      _dataState = _dataState.copyWith(promotion: promotion);
      emit(_dataState);
    } catch (e) {
      emit(PromotionLoadingState(error: e.toString()));
    }
  }
}