import 'package:flutter/material.dart';
import 'package:mobile/data/models/location_model.dart';
import 'package:mobile/data/services/map_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapService _mapService;

  MapRepositoryImpl({MapService? mapService})
      : _mapService = mapService ?? MapService(apiKey: dotenv.env['GOONG_API_KEY'] ?? '');

  Future<List<Prediction>> searchPlaces(
      String query, {
        Coordinates? location,
        int radius = 50,
        int limit = 10,
      }) async {
    try {
      return await _mapService.searchPlaces(
        input: query,
        location: location,
        radius: radius,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to search places: $e');
    }
  }

  Future<PlaceDetail?> getPlaceDetails(String placeId) async {
    try {
      return await _mapService.getPlaceDetails(placeId);
    } catch (e) {
      throw Exception('Failed to get place details: $e');
    }
  }

  @override
  Future<AddressDetails?> reverseGeocode(double latitude, double longitude) async {
    try {
      return await _mapService.reverseGeocode(latitude, longitude);
    } catch (e, stackTrace) {
      debugPrint('Error in reverse geocoding: $e, $stackTrace');
      throw Exception('Failed to reverse geocode: $e');
    }
  }
}