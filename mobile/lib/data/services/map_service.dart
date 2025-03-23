import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/data/models/location_model.dart';

class MapService {
  final String apiKey;
  final String sessionToken;

  MapService({required this.apiKey}) : sessionToken = _generateSessionToken();

  static String _generateSessionToken() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replaceAllMapped(
      RegExp(r'[xy]'),
          (match) {
        final r = (DateTime.now().millisecondsSinceEpoch + match.start) % 16;
        final v = match.group(0) == 'x' ? r : (r & 0x3 | 0x8);
        return v.toRadixString(16);
      },
    );
  }

  Future<List<Prediction>> searchPlaces({
    required String input,
    Coordinates? location,
    int radius = 50,
    int limit = 10,
    bool moreCompound = false,
  }) async {
    if (input.trim().isEmpty) {
      return [];
    }

    try {
      final locationParam = location != null
          ? '&location=${location.latitude},${location.longitude}'
          : '';

      final url = 'https://rsapi.goong.io/Place/AutoComplete'
          '?api_key=$apiKey'
          '&input=${Uri.encodeComponent(input)}'
          '$locationParam'
          '&limit=$limit'
          '&radius=$radius'
          '&sessiontoken=$sessionToken'
          '&more_compound=${moreCompound ? 'true' : 'false'}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('API error: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final List<dynamic> predictions = data['predictions'];
        return predictions
            .map((prediction) => Prediction.fromJson(prediction))
            .toList();
      } else {
        throw Exception('API status: ${data['status']}');
      }
    } catch (e) {
      throw Exception('Failed to search places: $e');
    }
  }

  Future<PlaceDetail?> getPlaceDetails(String placeId) async {
    try {
      final url = 'https://rsapi.goong.io/Place/Detail'
          '?api_key=$apiKey'
          '&place_id=${Uri.encodeComponent(placeId)}'
          '&sessiontoken=$sessionToken';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('API error: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        return PlaceDetail.fromJson(data['result']);
      } else {
        throw Exception('API status: ${data['status']}');
      }
    } catch (e) {
      throw Exception('Failed to get place details: $e');
    }
  }

  Future<AddressDetails?> reverseGeocode(double latitude, double longitude) async {
    try {
      final url = 'https://rsapi.goong.io/Geocode'
          '?api_key=$apiKey'
          '&latlng=$latitude,$longitude'
          '&sessiontoken=$sessionToken';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('API error: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
        return AddressDetails.fromJson(data['results'][0]);
      } else {
        throw Exception('API status: ${data['status']}');
      }
    } catch (e) {
      throw Exception('Failed to reverse geocode: $e');
    }
  }
}