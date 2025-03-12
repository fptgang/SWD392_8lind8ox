import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/blocs/blindbox_list/blindboxes_event.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class BlindBoxesBloc extends Bloc<BlindBoxEvent, BlindBoxesState> {
  final BlindBoxRepository _blindBoxRepository;
  Timer? _debounceTimer;
  final PagingController<int, BlindBoxModel> pagingController;

  PaginationState _paginationState;
  DataState _dataState;

  BlindBoxesBloc(
      this._blindBoxRepository,
      ) : _paginationState = PaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const DataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(LoadingState()) {
    pagingController.addPageRequestListener((pageKey) {
      add(GetBlindBoxes(pageKey));
    });

    on<GetBlindBoxes>(_onGetBlindBoxes);
    on<GetNewReleaseBlindBoxes>(_onGetNewReleaseBlindBoxes);
    on<UpdateFilter>(_onUpdateFilter);
    on<RefreshBlindBoxes>(_onRefresh);
  }


  Future<void> _onGetBlindBoxes(
      GetBlindBoxes event,
      Emitter<BlindBoxesState> emit,
      ) async {
    emit(LoadingState(isLoading: true));

    try {
      final pageable = Pageable(
          page: event.pageKey,
          size: 20,
          sort: ['desc']
      );

      final blindBoxes = await _blindBoxRepository.getBlindBoxes(
          pageable,
          _dataState.filter ?? '',
          ''
      );

      final isLastPage = blindBoxes.content.length < pageable.size;

      if (isLastPage) {
        pagingController.appendLastPage(blindBoxes.content);
      } else {
        pagingController.appendPage(
            blindBoxes.content,
            event.pageKey + 1
        );
      }

      _paginationState = _paginationState.copyWith(
        pageable: pageable,
        hasReachedEnd: isLastPage,
      );

      emit(DataState(blindBoxes: blindBoxes));

    } catch (error) {
      pagingController.error = error;
      emit(LoadingState(error: error.toString()));
    }
  }

  Future<void> _onGetNewReleaseBlindBoxes(
      GetNewReleaseBlindBoxes event,
      Emitter<BlindBoxesState> emit,
      ) async {
    emit(LoadingState(isLoading: true));

    try {
      final blindBoxes = await _blindBoxRepository.getBlindBoxes(
          _paginationState.pageable,
          _dataState.filter ?? '',
          ''
      );

      _paginationState = _paginationState.copyWith(
        pageable: Pageable(
          page: _paginationState.pageable.page,
          size: 10,
          sort: ['createdAt,desc'],
        ),
      );

      emit(DataState(blindBoxes: blindBoxes));
    } catch (e) {
      emit(LoadingState(error: e.toString()));
    }
  }

  void _onUpdateFilter(
      UpdateFilter event,
      Emitter<BlindBoxesState> emit,
      ) {
    _dataState = _dataState.copyWith(filter: event.filter);
    _paginationState = _paginationState.copyWith(
      pageable: Pageable(page: 1, size: 20),
    );
    pagingController.refresh();
  }

  void _onRefresh(
      RefreshBlindBoxes event,
      Emitter<BlindBoxesState> emit,
      ) {
    pagingController.refresh();
    _paginationState = PaginationState(
        pageable: Pageable(page: 0, size: 20, sort: ['desc'])
    );
  }

}