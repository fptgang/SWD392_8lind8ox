//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ToyDto {
  /// Returns a new [ToyDto] instance.
  ToyDto({
    this.toyId,
    this.name,
    this.description,
    this.rarity,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? toyId;

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

  ToyDtoRarityEnum? rarity;

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

  @override
  bool operator ==(Object other) => identical(this, other) || other is ToyDto &&
    other.toyId == toyId &&
    other.name == name &&
    other.description == description &&
    other.rarity == rarity &&
    other.isVisible == isVisible &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (toyId == null ? 0 : toyId!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (rarity == null ? 0 : rarity!.hashCode) +
    (isVisible == null ? 0 : isVisible!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode);

  @override
  String toString() => 'ToyDto[toyId=$toyId, name=$name, description=$description, rarity=$rarity, isVisible=$isVisible, createdAt=$createdAt, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.toyId != null) {
      json[r'toyId'] = this.toyId;
    } else {
      json[r'toyId'] = null;
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
    if (this.rarity != null) {
      json[r'rarity'] = this.rarity;
    } else {
      json[r'rarity'] = null;
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
    return json;
  }

  /// Returns a new [ToyDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ToyDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ToyDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ToyDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ToyDto(
        toyId: mapValueOfType<int>(json, r'toyId'),
        name: mapValueOfType<String>(json, r'name'),
        description: mapValueOfType<String>(json, r'description'),
        rarity: ToyDtoRarityEnum.fromJson(json[r'rarity']),
        isVisible: mapValueOfType<bool>(json, r'isVisible'),
        createdAt: mapDateTime(json, r'createdAt', r''),
        updatedAt: mapDateTime(json, r'updatedAt', r''),
      );
    }
    return null;
  }

  static List<ToyDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ToyDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ToyDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ToyDto> mapFromJson(dynamic json) {
    final map = <String, ToyDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ToyDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ToyDto-objects as value to a dart map
  static Map<String, List<ToyDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ToyDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ToyDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class ToyDtoRarityEnum {
  /// Instantiate a new enum with the provided [value].
  const ToyDtoRarityEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const REGULAR = ToyDtoRarityEnum._(r'REGULAR');
  static const SECRET = ToyDtoRarityEnum._(r'SECRET');

  /// List of all possible values in this [enum][ToyDtoRarityEnum].
  static const values = <ToyDtoRarityEnum>[
    REGULAR,
    SECRET,
  ];

  static ToyDtoRarityEnum? fromJson(dynamic value) => ToyDtoRarityEnumTypeTransformer().decode(value);

  static List<ToyDtoRarityEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ToyDtoRarityEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ToyDtoRarityEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ToyDtoRarityEnum] to String,
/// and [decode] dynamic data back to [ToyDtoRarityEnum].
class ToyDtoRarityEnumTypeTransformer {
  factory ToyDtoRarityEnumTypeTransformer() => _instance ??= const ToyDtoRarityEnumTypeTransformer._();

  const ToyDtoRarityEnumTypeTransformer._();

  String encode(ToyDtoRarityEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ToyDtoRarityEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ToyDtoRarityEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'REGULAR': return ToyDtoRarityEnum.REGULAR;
        case r'SECRET': return ToyDtoRarityEnum.SECRET;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ToyDtoRarityEnumTypeTransformer] instance.
  static ToyDtoRarityEnumTypeTransformer? _instance;
}


