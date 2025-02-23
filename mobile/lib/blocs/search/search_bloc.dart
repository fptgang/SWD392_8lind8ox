import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/blocs/search/search_event.dart';
import 'package:mobile/blocs/search/search_state.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:mobile/data/datasources/local/search_local_datasource.dart';
import 'package:openapi/api.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BlindBoxRepository _blindBoxRepository;
  final SearchLocalDatasource _searchLocalDatasource;
  Timer? _debounceTimer;

  SearchBloc(
      this._blindBoxRepository,
      this._searchLocalDatasource,
      ) : super(const SearchLoadingState()) {
    on<InitializeSearch>(_onInitializeSearch);
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<SubmitSearch>(_onSubmitSearch);
    on<ClearSearch>(_onClearSearch);
    on<AddRecentSearch>(_onAddRecentSearch);
    on<RemoveRecentSearch>(_onRemoveRecentSearch);
    on<ClearRecentSearches>(_onClearRecentSearches);
  }

  Future<void> _onInitializeSearch(
      InitializeSearch event,
      Emitter<SearchState> emit,
      ) async {
    final recentSearches = _searchLocalDatasource.getRecentSearches();
    emit(SearchQueryState(recentSearches: recentSearches));
  }

  Future<void> _onLoadRecentSearches(
      LoadRecentSearches event,
      Emitter<SearchState> emit,
      ) async {
    final recentSearches = _searchLocalDatasource.getRecentSearches();
    if (state is SearchQueryState) {
      emit((state as SearchQueryState).copyWith(recentSearches: recentSearches));
    } else {
      emit(SearchQueryState(recentSearches: recentSearches));
    }
  }

  void _onSearchTextChanged(
      SearchTextChanged event,
      Emitter<SearchState> emit,
      ) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(event.query, emit);
    });

    if (state is SearchQueryState) {
      emit((state as SearchQueryState).copyWith(query: event.query));
    } else {
      emit(SearchQueryState(query: event.query));
    }
  }

  Future<void> _onSubmitSearch(
      SubmitSearch event,
      Emitter<SearchState> emit,
      ) async {
    if (event.query.trim().isEmpty) return;

    add(AddRecentSearch(event.query));
    await _performSearch(event.query, emit);
  }

  Future<void> _performSearch(String query, Emitter<SearchState> emit) async {
    emit(const SearchLoadingState(isLoading: true));

    try {
      final pageable = Pageable(page: 1, size: 20);
      final results = await _blindBoxRepository.getBlindBoxes(
        pageable,
        '',  // filter
        query,
      );

      emit(SearchDataState(searchResults: results));
    } catch (e) {
      emit(SearchLoadingState(error: e.toString()));
    }
  }

  void _onClearSearch(
      ClearSearch event,
      Emitter<SearchState> emit,
      ) {
    _debounceTimer?.cancel();
    emit(const SearchQueryState());
  }

  Future<void> _onAddRecentSearch(
      AddRecentSearch event,
      Emitter<SearchState> emit,
      ) async {
    final currentSearches = _searchLocalDatasource.getRecentSearches();
    final updatedSearches = {event.search, ...currentSearches}.take(10).toList();

    await _searchLocalDatasource.saveRecentSearches(updatedSearches);

    if (state is SearchQueryState) {
      emit((state as SearchQueryState).copyWith(recentSearches: updatedSearches));
    } else {
      emit(SearchQueryState(recentSearches: updatedSearches));
    }
  }

  Future<void> _onRemoveRecentSearch(
      RemoveRecentSearch event,
      Emitter<SearchState> emit,
      ) async {
    await _searchLocalDatasource.removeRecentSearch(event.search);
    final updatedSearches = _searchLocalDatasource.getRecentSearches();

    if (state is SearchQueryState) {
      emit((state as SearchQueryState).copyWith(recentSearches: updatedSearches));
    } else {
      emit(SearchQueryState(recentSearches: updatedSearches));
    }
  }

  Future<void> _onClearRecentSearches(
      ClearRecentSearches event,
      Emitter<SearchState> emit,
      ) async {
    await _searchLocalDatasource.clearRecentSearches();

    if (state is SearchQueryState) {
      emit((state as SearchQueryState).copyWith(recentSearches: []));
    } else {
      emit(const SearchQueryState(recentSearches: []));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}