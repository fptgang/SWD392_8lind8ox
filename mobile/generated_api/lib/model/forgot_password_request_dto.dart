//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ForgotPasswordRequestDto {
  /// Returns a new [ForgotPasswordRequestDto] instance.
  ForgotPasswordRequestDto({
    this.email,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? email;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ForgotPasswordRequestDto &&
    other.email == email;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (email == null ? 0 : email!.hashCode);

  @override
  String toString() => 'ForgotPasswordRequestDto[email=$email]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    return json;
  }

  /// Returns a new [ForgotPasswordRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ForgotPasswordRequestDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ForgotPasswordRequestDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ForgotPasswordRequestDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ForgotPasswordRequestDto(
        email: mapValueOfType<String>(json, r'email'),
      );
    }
    return null;
  }

  static List<ForgotPasswordRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ForgotPasswordRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ForgotPasswordRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ForgotPasswordRequestDto> mapFromJson(dynamic json) {
    final map = <String, ForgotPasswordRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ForgotPasswordRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ForgotPasswordRequestDto-objects as value to a dart map
  static Map<String, List<ForgotPasswordRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ForgotPasswordRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ForgotPasswordRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

