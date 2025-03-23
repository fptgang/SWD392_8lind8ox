import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/location_model.dart';

enum MapStatus { initial, loading, loaded, error }

class MapState extends Equatable {
  final String searchTerm;
  final List<Prediction> predictions;
  final PlaceDetail? selectedPlace;
  final Coordinates? currentLocation;
  final int radius;
  final int limit;
  final MapStatus status;
  final String? errorMessage;

  const MapState({
    this.searchTerm = '',
    this.predictions = const [],
    this.selectedPlace,
    this.currentLocation,
    this.radius = 50,
    this.limit = 10,
    this.status = MapStatus.initial,
    this.errorMessage,
  });

  MapState copyWith({
    String? searchTerm,
    List<Prediction>? predictions,
    PlaceDetail? selectedPlace,
    Coordinates? currentLocation,
    int? radius,
    int? limit,
    MapStatus? status,
    String? errorMessage,
  }) {
    return MapState(
      searchTerm: searchTerm ?? this.searchTerm,
      predictions: predictions ?? this.predictions,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      currentLocation: currentLocation ?? this.currentLocation,
      radius: radius ?? this.radius,
      limit: limit ?? this.limit,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    searchTerm,
    predictions,
    selectedPlace,
    currentLocation,
    radius,
    limit,
    status,
    errorMessage,
  ];
}
