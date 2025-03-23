import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/models/location_model.dart';
import 'package:mobile/data/repositories/map_repository.dart';
import 'package:mobile/feature/shipping/blocs/map/map_event.dart';
import 'package:mobile/feature/shipping/blocs/map/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository _mapRepository;
  Timer? _debounceTimer;

  MapBloc({
    required MapRepository mapRepository,
    Coordinates? defaultLocation,
    int? defaultRadius,
    int? defaultLimit,
  }) : _mapRepository = mapRepository,
        super(MapState(
        currentLocation: defaultLocation,
        radius: defaultRadius ?? 50,
        limit: defaultLimit ?? 10,
      )) {
    on<SearchPlaces>(_onSearchPlaces);
    on<SelectPlace>(_onSelectPlace);
    on<UpdateLocation>(_onUpdateLocation);
    on<UpdateRadius>(_onUpdateRadius);
    on<UpdateLimit>(_onUpdateLimit);
  }

  Future<void> _onSearchPlaces(
      SearchPlaces event,
      Emitter<MapState> emit,
      ) async {
    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    // Update search term immediately
    emit(state.copyWith(searchTerm: event.searchTerm));

    // Return early if search term is empty
    if (event.searchTerm.isEmpty) {
      emit(state.copyWith(predictions: []));
      return;
    }

    // Set up debounce for actual search
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        emit(state.copyWith(status: MapStatus.loading));

        final predictions = await _mapRepository.searchPlaces(
          event.searchTerm,
          location: state.currentLocation,
          radius: state.radius,
          limit: state.limit,
        );

        emit(state.copyWith(
          predictions: predictions,
          status: MapStatus.loaded,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: MapStatus.error,
          errorMessage: e.toString(),
        ));
      }
    });
  }

  Future<void> _onSelectPlace(
      SelectPlace event,
      Emitter<MapState> emit,
      ) async {
    try {
      emit(state.copyWith(status: MapStatus.loading));

      final placeDetail = await _mapRepository.getPlaceDetails(event.placeId);

      if (placeDetail != null) {
        emit(state.copyWith(
          selectedPlace: placeDetail,
          currentLocation: placeDetail.location,
          status: MapStatus.loaded,
        ));
      } else {
        emit(state.copyWith(
          status: MapStatus.error,
          errorMessage: 'Failed to get place details',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: MapStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onUpdateLocation(
      UpdateLocation event,
      Emitter<MapState> emit,
      ) {
    final newLocation = Coordinates(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    emit(state.copyWith(currentLocation: newLocation));
  }

  void _onUpdateRadius(
      UpdateRadius event,
      Emitter<MapState> emit,
      ) {
    emit(state.copyWith(radius: event.radius));
  }

  void _onUpdateLimit(
      UpdateLimit event,
      Emitter<MapState> emit,
      ) {
    emit(state.copyWith(limit: event.limit));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}