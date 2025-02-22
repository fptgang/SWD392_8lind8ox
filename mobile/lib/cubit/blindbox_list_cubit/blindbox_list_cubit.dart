import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/cubit/blindbox_list_cubit/blindbox_list_state.dart';
import 'package:mobile/data/datasources/local/search_local_datasource.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:openapi/api.dart';

@injectable
class BlindBoxesCubit extends Cubit<BlindBoxesState> {
  final BlindBoxRepository _blindBoxRepository;
  final SearchLocalDatasource? _searchLocalDatasource;
  Timer? _debounceTimer;
  final PagingController<int, BlindBoxModel> pagingController = PagingController(firstPageKey: 1);

  // Track states internally
  PaginationState _paginationState;
  SearchState _searchState;

  BlindBoxesCubit(
      this._blindBoxRepository,
      [this._searchLocalDatasource]
      ) : _paginationState = PaginationState(pageable: Pageable(page: 1, size: 20)),
        _searchState = const SearchState(),
        super(LoadingState()) {
    pagingController.addPageRequestListener((pageKey) {
      getBlindBoxes(pageKey);
    });
  }

  Future<void> getBlindBoxes(int pageKey) async {
    emit(LoadingState(isLoading: true));

    try {
      final pageable = Pageable(
          page: pageKey,
          size: 20,
          sort: ['desc']
      );

      final blindBoxes = await _blindBoxRepository.getBlindBoxes(
          pageable,
          _searchState.filter ?? '',
          _searchState.query ?? ''
      );

      final isLastPage = blindBoxes.content.length < pageable.size;

      if (isLastPage) {
        pagingController.appendLastPage(blindBoxes.content);
      } else {
        pagingController.appendPage(
            blindBoxes.content,
            pageKey + 1
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

  Future<void> getNewReleaseBlindBoxes() async {
    emit(LoadingState(isLoading: true));

    try {
      final blindBoxes = await _blindBoxRepository.getBlindBoxes(
          _paginationState.pageable,
          _searchState.filter ?? '',
          _searchState.query ?? ''
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

  void updateFilter(String filter) {
    _searchState = _searchState.copyWith(filter: filter);
    _paginationState = _paginationState.copyWith(
      pageable: Pageable(page: 1, size: 20),
    );
    pagingController.refresh();
  }

  void updateSearch(String search) {
    _searchState = _searchState.copyWith(query: search);
    _paginationState = _paginationState.copyWith(
      pageable: Pageable(page: 1, size: 20),
    );
    pagingController.refresh();
  }

  void onSearchChanged(String search) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      updateSearch(search);
    });
  }

  void refresh() {
    pagingController.refresh();
    _paginationState = PaginationState(
        pageable: Pageable(page: 0, size: 20, sort: ['desc'])
    );
    _searchState = const SearchState();
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}