import 'package:mobile/data/models/location_model.dart';

abstract class MapRepository {
  Future<List<Prediction>> searchPlaces(String query, {
    Coordinates? location,
    int radius = 50,
    int limit = 10,
  });

  Future<PlaceDetail?> getPlaceDetails(String placeId);
  
  /// Converts coordinates to address details using reverse geocoding
  Future<AddressDetails?> reverseGeocode(double latitude, double longitude);
}