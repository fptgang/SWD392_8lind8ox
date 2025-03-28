import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/repositories/image_repository.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/data/repositories/sku_repository.dart';
import 'package:openapi/api.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/set_model.dart';

import 'set_event.dart';
import 'set_state.dart';

class SetBloc extends Bloc<SetEvent, SetState> {
  final SetRepository _setRepository;
  final SkuRepository skuRepository;
  final ImageRepository imageRepository;

  SetBloc(
    this._setRepository, {
    required this.skuRepository,
    required this.imageRepository,
  }) : super(const SetState()) {
    on<FetchSets>(_onFetchSets);
    on<RefreshSets>(_onRefreshSets);
    on<LoadMoreSets>(_onLoadMoreSets);
  }

  Future<void> _onFetchSets(
    FetchSets event,
    Emitter<SetState> emit,
  ) async {
    try {
      if (state.sets == null) {
        emit(state.copyWith(status: SetStatus.loading, isLoading: true));
      }

      final sets = await _setRepository.getSets(
        event.pageable,
        event.filter,
        event.search,
      );

      emit(state.copyWith(
        status: SetStatus.success,
        sets: sets,
        currentPage: event.pageable.page,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SetStatus.failure,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onRefreshSets(
    RefreshSets event,
    Emitter<SetState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SetStatus.loading, isLoading: true));

      final sets = await _setRepository.getSets(
        event.pageable,
        event.filter,
        event.search,
      );

      emit(state.copyWith(
        status: SetStatus.success,
        sets: sets,
        currentPage: event.pageable.page,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SetStatus.failure,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onLoadMoreSets(
    LoadMoreSets event,
    Emitter<SetState> emit,
  ) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final result = await _setRepository.getSets(
        event.pageable,
        event.filter,
        event.search,
      );

      // Merge old and new content
      final currentContent = state.sets?.content ?? [];
      final newContent = result.content;
      final combinedContent = [...currentContent, ...newContent];

      // Create updated pagination response
      final updatedResult = PaginationResponseGeneric<SetModel>(
        content: combinedContent,
        totalPages: result.totalPages,
        totalElements: result.totalElements,
        last: result.last,
        first: false, // Not the first page in combined results
        numberOfElements: combinedContent.length,
        empty: combinedContent.isEmpty,
      );

      emit(state.copyWith(
        status: SetStatus.success,
        sets: updatedResult,
        currentPage: event.pageable.page,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
