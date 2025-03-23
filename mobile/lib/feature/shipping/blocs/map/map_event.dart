abstract class MapEvent {}

class SearchPlaces extends MapEvent {
  final String searchTerm;

  SearchPlaces(this.searchTerm);
}

class SelectPlace extends MapEvent {
  final String placeId;

  SelectPlace(this.placeId);
}

class UpdateLocation extends MapEvent {
  final double latitude;
  final double longitude;

  UpdateLocation(this.latitude, this.longitude);
}

class UpdateRadius extends MapEvent {
  final int radius;

  UpdateRadius(this.radius);
}

class UpdateLimit extends MapEvent {
  final int limit;

  UpdateLimit(this.limit);
}