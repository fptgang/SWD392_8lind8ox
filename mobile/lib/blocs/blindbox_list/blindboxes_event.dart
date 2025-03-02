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

class RefreshBlindBoxes extends BlindBoxEvent {}
