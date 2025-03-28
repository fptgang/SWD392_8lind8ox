import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/datasources/local/search_local_datasource.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:mobile/feature/search/blocs/search_event.dart';
import 'package:mobile/feature/search/blocs/search_state.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BlindBoxRepository _blindBoxRepository;
  final SearchLocalDatasource _searchLocalDatasource;
  Timer? _debounceTimer;

  // Default page size for pagination
  static const int _pageSize = 20;

  SearchBloc(
    this._blindBoxRepository,
    this._searchLocalDatasource,
  ) : super(const SearchQueryState()) {
    on<InitializeSearch>(_onInitializeSearch);
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<SubmitSearch>(_onSubmitSearch);
    on<ClearSearch>(_onClearSearch);
    on<AddRecentSearch>(_onAddRecentSearch);
    on<RemoveRecentSearch>(_onRemoveRecentSearch);
    on<ClearRecentSearches>(_onClearRecentSearches);
    on<LoadMoreResults>(_onLoadMoreResults);
    on<ApplySearchFilter>(_onApplySearchFilter);
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
      emit(
          (state as SearchQueryState).copyWith(recentSearches: recentSearches));
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
      if (event.query.length >= 2) {
        _performSearch(event.query, emit, 1);
      }
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
    await _performSearch(event.query, emit, 1);
  }

  Future<void> _onLoadMoreResults(
    LoadMoreResults event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchDataState) {
      final currentState = state as SearchDataState;
      final currentQuery = currentState.searchQuery;
      final currentFilter = currentState.filter;

      if (currentState.isLoadingMore || currentState.hasReachedEnd) {
        return;
      }

      // Calculate next page based on the current page number
      final nextPage =
          (currentState.searchResults?.numberOfElements ?? 0) ~/ _pageSize + 1;

      emit(currentState.copyWith(isLoadingMore: true));

      // Use the non-null assertion operator with the null-coalescing operator
      final query = currentQuery ?? '';
      await _performSearch(query, emit, nextPage,
          filter: currentFilter, isLoadMore: true);
    }
  }

  Future<void> _onApplySearchFilter(
    ApplySearchFilter event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchDataState) {
      final currentState = state as SearchDataState;
      final currentQuery = currentState.searchQuery;

      // Use the non-null assertion operator with the null-coalescing operator
      final query = currentQuery ?? '';
      await _performSearch(query, emit, 1, filter: event.filter);
    }
  }

  Future<void> _performSearch(
    String query,
    Emitter<SearchState> emit,
    int page, {
    String? filter = '',
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      emit(const SearchLoadingState(isLoading: true));
    }

    try {
      final pageable = Pageable(
        page: page,
        size: _pageSize,
        sort: filter != null && filter.isNotEmpty ? [filter] : [],
      );

      // Clean up filter for the API call - only pass sort directions in pageable,
      // not as a separate filter parameter
      final apiFilter = '';

      final results = await _blindBoxRepository.getBlindBoxes(
        pageable,
        apiFilter,
        query,
      );

      debugPrint(
          'Search query: $query, page: ${pageable.page}, size: ${pageable.size}, sort: ${pageable.sort}');

      // Check if we've reached the end based on total pages
      final hasReachedEnd =
          results.content.isEmpty || (page >= results.totalPages - 1);

      if (isLoadMore && state is SearchDataState) {
        final currentState = state as SearchDataState;
        final currentResults = currentState.searchResults;

        if (currentResults != null) {
          // Merge results - keep existing content and add new items
          final updatedContent = [
            ...currentResults.content,
            ...results.content
          ];

          // Create a new merged result instead of using copyWith
          final mergedResults = PaginationResponseGeneric<BlindBoxModel>(
            content: updatedContent.cast<BlindBoxModel>(),
            totalElements: results.totalElements,
            totalPages: results.totalPages,
            last: results.last,
            first: false, // Not the first page anymore
            numberOfElements: updatedContent.length,
            empty: updatedContent.isEmpty,
          );

          emit(currentState.copyWith(
            searchResults: mergedResults,
            isLoadingMore: false,
            hasReachedEnd: hasReachedEnd,
            searchQuery: query,
            filter: filter,
          ));
        } else {
          emit(SearchDataState(
            searchResults: results,
            isLoadingMore: false,
            hasReachedEnd: hasReachedEnd,
            searchQuery: query,
            filter: filter,
          ));
        }
      } else {
        emit(SearchDataState(
          searchResults: results,
          isLoadingMore: false,
          hasReachedEnd: hasReachedEnd,
          searchQuery: query,
          filter: filter,
        ));
      }
    } catch (e) {
      debugPrint('Search error: $e');
      if (isLoadMore && state is SearchDataState) {
        emit((state as SearchDataState)
            .copyWith(isLoadingMore: false, error: e.toString()));
      } else {
        emit(SearchLoadingState(error: e.toString()));
      }
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
    final query = event.search.trim();
    if (query.isEmpty) return;

    final currentSearches = _searchLocalDatasource.getRecentSearches();

    // Remove the search if it already exists to avoid duplicates
    final dedupedList = currentSearches.where((s) => s != query).toList();

    // Add the new search at the beginning and limit to 10 items
    final updatedSearches = [query, ...dedupedList].take(10).toList();

    await _searchLocalDatasource.saveRecentSearches(updatedSearches);

    if (state is SearchQueryState) {
      emit((state as SearchQueryState)
          .copyWith(recentSearches: updatedSearches));
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
      emit((state as SearchQueryState)
          .copyWith(recentSearches: updatedSearches));
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
