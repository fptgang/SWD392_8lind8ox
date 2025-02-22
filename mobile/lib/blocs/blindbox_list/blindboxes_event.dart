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