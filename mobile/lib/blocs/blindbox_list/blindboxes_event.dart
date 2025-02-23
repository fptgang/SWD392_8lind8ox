abstract class BlindBoxEvent {}

class GetBlindBoxes extends BlindBoxEvent {
  final int pageKey;

  GetBlindBoxes(this.pageKey);
}

class GetNewReleaseBlindBoxes extends BlindBoxEvent {}

class UpdateFilter extends BlindBoxEvent {
  final String filter;

  UpdateFilter(this.filter);
}

class UpdateSearch extends BlindBoxEvent {
  final String search;

  UpdateSearch(this.search);
}

class SearchChanged extends BlindBoxEvent {
  final String search;

  SearchChanged(this.search);
}

class RefreshBlindBoxes extends BlindBoxEvent {}

class InitializeSearch extends BlindBoxEvent {}

class SubmitSearch extends BlindBoxEvent {
  final String query;
  SubmitSearch(this.query);
}

class ClearSearch extends BlindBoxEvent {}

class LoadRecentSearches extends BlindBoxEvent {}

class AddRecentSearch extends BlindBoxEvent {
  final String search;
  AddRecentSearch(this.search);
}

class RemoveRecentSearch extends BlindBoxEvent {
  final String search;
  RemoveRecentSearch(this.search);
}

class ClearRecentSearches extends BlindBoxEvent {}