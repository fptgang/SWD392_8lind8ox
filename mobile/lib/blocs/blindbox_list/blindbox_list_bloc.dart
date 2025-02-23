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
class BlindBoxesBloc extends Bloc<BlindBoxEvent, BlindBoxesState> {
  final BlindBoxRepository _blindBoxRepository;
  final SearchLocalDatasource? _searchLocalDatasource;
  Timer? _debounceTimer;
  final PagingController<int, BlindBoxModel> pagingController;

  // Track states internally
  PaginationState _paginationState;
  SearchState _searchState;

  BlindBoxesBloc(
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
    on<InitializeSearch>(_onInitializeSearch);
    on<SubmitSearch>(_onSubmitSearch);
    on<ClearSearch>(_onClearSearch);
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<AddRecentSearch>(_onAddRecentSearch);
    on<RemoveRecentSearch>(_onRemoveRecentSearch);
    on<ClearRecentSearches>(_onClearRecentSearches);
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

  Future<void> _onInitializeSearch(
      InitializeSearch event,
      Emitter<BlindBoxesState> emit,
      ) async {
    final recentSearches = _searchLocalDatasource?.getRecentSearches();
    _searchState = _searchState.copyWith(recentSearches: recentSearches);
    emit(LoadingState(isLoading: true));
  }

  Future<void> _onSubmitSearch(
      SubmitSearch event,
      Emitter<BlindBoxesState> emit,
      ) async {
    if (event.query.trim().isEmpty) return;

    // Add to recent searches
    add(AddRecentSearch(event.query));

    // Reset pagination and perform search
    _paginationState = PaginationState(pageable: Pageable(page: 1, size: 20));
    add(UpdateSearch(event.query));
  }

  Future<void> _onAddRecentSearch(
      AddRecentSearch event,
      Emitter<BlindBoxesState> emit,
      ) async {
    var searches = _searchState.recentSearches.toList();
    searches.remove(event.search); // Remove if exists
    searches.insert(0, event.search); // Add to front
    if (searches.length > 10) searches = searches.take(10).toList(); // Keep last 10

    await _searchLocalDatasource?.saveRecentSearches(searches);
    _searchState = _searchState.copyWith(recentSearches: searches);
    emit(LoadingState(isLoading: true));
  }

  Future<void> _onRemoveRecentSearch(
      RemoveRecentSearch event,
      Emitter<BlindBoxesState> emit,
      ) async {
    await _searchLocalDatasource?.removeRecentSearch(event.search);
    final searches = _searchState.recentSearches.where((s) => s != event.search).toList();
    _searchState = _searchState.copyWith(recentSearches: searches);
    emit(LoadingState(isLoading: true));
  }

  Future<void> _onClearRecentSearches(
      ClearRecentSearches event,
      Emitter<BlindBoxesState> emit,
      ) async {
    await _searchLocalDatasource?.clearRecentSearches();
    _searchState = _searchState.copyWith(recentSearches: []);
    emit(LoadingState(isLoading: true));
  }

  Future<void> _onLoadRecentSearches(
      LoadRecentSearches event,
      Emitter<BlindBoxesState> emit,
      ) async {
    final searches = _searchLocalDatasource?.getRecentSearches();
    _searchState = _searchState.copyWith(recentSearches: searches);
    emit(LoadingState(isLoading: true));
  }

  Future<void> _onClearSearch(
      ClearSearch event,
      Emitter<BlindBoxesState> emit,
      ) async {
    _searchState = _searchState.copyWith(query: '');
    add(RefreshBlindBoxes());
  }


  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    pagingController.dispose();
    return super.close();
  }
}