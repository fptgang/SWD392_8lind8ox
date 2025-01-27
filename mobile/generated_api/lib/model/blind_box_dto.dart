//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BlindBoxDto {
  /// Returns a new [BlindBoxDto] instance.
  BlindBoxDto({
    this.blindBoxId,
    this.brandId,
    this.name,
    this.description,
    this.currentPrice,
    this.promotionalCampaignId,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
    this.images = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? blindBoxId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? brandId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? currentPrice;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? promotionalCampaignId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isVisible;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? updatedAt;

  List<ImageDto> images;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BlindBoxDto &&
    other.blindBoxId == blindBoxId &&
    other.brandId == brandId &&
    other.name == name &&
    other.description == description &&
    other.currentPrice == currentPrice &&
    other.promotionalCampaignId == promotionalCampaignId &&
    other.isVisible == isVisible &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    _deepEquality.equals(other.images, images);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (blindBoxId == null ? 0 : blindBoxId!.hashCode) +
    (brandId == null ? 0 : brandId!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (currentPrice == null ? 0 : currentPrice!.hashCode) +
    (promotionalCampaignId == null ? 0 : promotionalCampaignId!.hashCode) +
    (isVisible == null ? 0 : isVisible!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode) +
    (images.hashCode);

  @override
  String toString() => 'BlindBoxDto[blindBoxId=$blindBoxId, brandId=$brandId, name=$name, description=$description, currentPrice=$currentPrice, promotionalCampaignId=$promotionalCampaignId, isVisible=$isVisible, createdAt=$createdAt, updatedAt=$updatedAt, images=$images]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.blindBoxId != null) {
      json[r'blindBoxId'] = this.blindBoxId;
    } else {
      json[r'blindBoxId'] = null;
    }
    if (this.brandId != null) {
      json[r'brandId'] = this.brandId;
    } else {
      json[r'brandId'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.currentPrice != null) {
      json[r'currentPrice'] = this.currentPrice;
    } else {
      json[r'currentPrice'] = null;
    }
    if (this.promotionalCampaignId != null) {
      json[r'promotionalCampaignId'] = this.promotionalCampaignId;
    } else {
      json[r'promotionalCampaignId'] = null;
    }
    if (this.isVisible != null) {
      json[r'isVisible'] = this.isVisible;
    } else {
      json[r'isVisible'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'createdAt'] = null;
    }
    if (this.updatedAt != null) {
      json[r'updatedAt'] = this.updatedAt!.toUtc().toIso8601String();
    } else {
      json[r'updatedAt'] = null;
    }
      json[r'images'] = this.images;
    return json;
  }

  /// Returns a new [BlindBoxDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BlindBoxDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BlindBoxDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BlindBoxDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BlindBoxDto(
        blindBoxId: mapValueOfType<int>(json, r'blindBoxId'),
        brandId: mapValueOfType<int>(json, r'brandId'),
        name: mapValueOfType<String>(json, r'name'),
        description: mapValueOfType<String>(json, r'description'),
        currentPrice: mapValueOfType<double>(json, r'currentPrice'),
        promotionalCampaignId: mapValueOfType<int>(json, r'promotionalCampaignId'),
        isVisible: mapValueOfType<bool>(json, r'isVisible'),
        createdAt: mapDateTime(json, r'createdAt', r''),
        updatedAt: mapDateTime(json, r'updatedAt', r''),
        images: ImageDto.listFromJson(json[r'images']),
      );
    }
    return null;
  }

  static List<BlindBoxDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BlindBoxDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BlindBoxDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BlindBoxDto> mapFromJson(dynamic json) {
    final map = <String, BlindBoxDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BlindBoxDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BlindBoxDto-objects as value to a dart map
  static Map<String, List<BlindBoxDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BlindBoxDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BlindBoxDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

