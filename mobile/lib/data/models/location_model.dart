class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['lat'] as double,
      longitude: json['lng'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
    };
  }
}

class StructuredFormatting {
  final String mainText;
  final String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String,
      secondaryText: json['secondary_text'] as String,
    );
  }
}

class Prediction {
  final String description;
  final String placeId;
  final StructuredFormatting structuredFormatting;

  Prediction({
    required this.description,
    required this.placeId,
    required this.structuredFormatting,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'] as String,
      placeId: json['place_id'] as String,
      structuredFormatting: StructuredFormatting.fromJson(
        json['structured_formatting'] as Map<String, dynamic>,
      ),
    );
  }
}

class PlaceDetail {
  final String placeId;
  final String formattedAddress;
  final Coordinates location;
  final String name;

  PlaceDetail({
    required this.placeId,
    required this.formattedAddress,
    required this.location,
    required this.name,
  });

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
    return PlaceDetail(
      placeId: json['place_id'] as String,
      formattedAddress: json['formatted_address'] as String,
      location: Coordinates.fromJson(
        json['geometry']['location'] as Map<String, dynamic>,
      ),
      name: json['name'] as String,
    );
  }
}

class AddressDetails {
  final String? streetAddress;
  final String? ward;
  final String? district;
  final String? city;
  final String? formattedAddress;
  final Coordinates? coordinates;

  AddressDetails({
    this.streetAddress,
    this.ward,
    this.district,
    this.city,
    this.formattedAddress,
    this.coordinates,
  });

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    // Parse address components based on the API response structure
    final List<dynamic> addressComponents = json['address_components'] ?? [];
    
    String? street;
    String? ward;
    String? district;
    String? city;
    
    for (var component in addressComponents) {
      final List<dynamic> types = component['types'] ?? [];
      final String longName = component['long_name'] ?? '';
      
      if (types.contains('street')) {
        street = longName;
      } else if (types.contains('administrative_area_level_3')) {
        ward = longName;
      } else if (types.contains('administrative_area_level_2')) {
        district = longName;
      } else if (types.contains('administrative_area_level_1')) {
        city = longName;
      }
    }
    
    return AddressDetails(
      streetAddress: street,
      ward: ward,
      district: district,
      city: city,
      formattedAddress: json['formatted_address'],
      coordinates: json['geometry'] != null && json['geometry']['location'] != null
          ? Coordinates.fromJson(json['geometry']['location'])
          : null,
    );
  }
}