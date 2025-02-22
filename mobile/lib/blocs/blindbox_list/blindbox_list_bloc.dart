import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/blocs/blindbox_list/blindboxes_event.dart';
import 'package:mobile/data/datasources/local/search_local_datasource.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:openapi/api.dart';

@injectable
class BlindBoxBloc extends Bloc<BlindBoxEvent, BlindBoxesState> {
  final BlindBoxRepository _blindBoxRepository;
  final SearchLocalDatasource? _searchLocalDatasource;
  Timer? _debounceTimer;
  final PagingController<int, BlindBoxModel> pagingController;

  // Track states internally
  PaginationState _paginationState;
  SearchState _searchState;

  BlindBoxBloc(
      this._blindBoxRepository,
      [this._searchLocalDatasource]
      ) : _paginationState = PaginationState(pageable: Pageable(page: 1, size: 20)),
        _searchState = const SearchState(),
        pagingController = PagingController(firstPageKey: 1),
        super(LoadingState()) {
    pagingController.addPageRequestListener((pageKey) {
      add(GetBlindBoxes(pageKey));
    });

    on<GetBlindBoxes>(_onGetBlindBoxes);
    on<GetNewReleaseBlindBoxes>(_onGetNewReleaseBlindBoxes);
    on<UpdateFilter>(_onUpdateFilter);
    on<UpdateSearch>(_onUpdateSearch);
    on<SearchChanged>(_onSearchChanged);
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
          _searchState.filter ?? '',
          _searchState.query ?? ''
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

  void _onUpdateFilter(
      UpdateFilter event,
      Emitter<BlindBoxesState> emit,
      ) {
    _searchState = _searchState.copyWith(filter: event.filter);
    _paginationState = _paginationState.copyWith(
      pageable: Pageable(page: 1, size: 20),
    );
    pagingController.refresh();
  }

  void _onUpdateSearch(
      UpdateSearch event,
      Emitter<BlindBoxesState> emit,
      ) {
    _searchState = _searchState.copyWith(query: event.search);
    _paginationState = _paginationState.copyWith(
      pageable: Pageable(page: 1, size: 20),
    );
    pagingController.refresh();
  }

  void _onSearchChanged(
      SearchChanged event,
      Emitter<BlindBoxesState> emit,
      ) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      add(UpdateSearch(event.search));
    });
  }

  void _onRefresh(
      RefreshBlindBoxes event,
      Emitter<BlindBoxesState> emit,
      ) {
    pagingController.refresh();
    _paginationState = PaginationState(
        pageable: Pageable(page: 0, size: 20, sort: ['desc'])
    );
    _searchState = const SearchState();
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    pagingController.dispose();
    return super.close();
  }
}