import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:openapi/api.dart';

abstract class SearchState {}

class SearchPaginationState implements SearchState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const SearchPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  SearchPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return SearchPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class SearchQueryState implements SearchState {
  final String? query;
  final List<String> recentSearches;

  const SearchQueryState({
    this.query,
    this.recentSearches = const [],
  });

  SearchQueryState copyWith({
    String? query,
    List<String>? recentSearches,
  }) {
    return SearchQueryState(
      query: query ?? this.query,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

class SearchLoadingState implements SearchState {
  final bool isLoading;
  final String? error;

  const SearchLoadingState({
    this.isLoading = false,
    this.error,
  });

  SearchLoadingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return SearchLoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SearchDataState implements SearchState {
  final PaginationResponseGeneric<BlindBoxModel>? searchResults;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String? searchQuery;
  final String? filter;
  final String? error;

  const SearchDataState({
    this.searchResults,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.searchQuery,
    this.filter,
    this.error,
  });

  SearchDataState copyWith({
    PaginationResponseGeneric<BlindBoxModel>? searchResults,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    String? searchQuery,
    String? filter,
    String? error,
  }) {
    return SearchDataState(
      searchResults: searchResults ?? this.searchResults,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
      error: error ?? this.error,
    );
  }
}
