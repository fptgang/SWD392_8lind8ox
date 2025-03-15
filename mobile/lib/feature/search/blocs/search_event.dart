abstract class SearchEvent {}

class InitializeSearch extends SearchEvent {}

class LoadRecentSearches extends SearchEvent {}

class SearchTextChanged extends SearchEvent {
  final String query;
  SearchTextChanged(this.query);
}

class SubmitSearch extends SearchEvent {
  final String query;
  SubmitSearch(this.query);
}

class ClearSearch extends SearchEvent {}

class AddRecentSearch extends SearchEvent {
  final String search;
  AddRecentSearch(this.search);
}

class RemoveRecentSearch extends SearchEvent {
  final String search;
  RemoveRecentSearch(this.search);
}

class ClearRecentSearches extends SearchEvent {}