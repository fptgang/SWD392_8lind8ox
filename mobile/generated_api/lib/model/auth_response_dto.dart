//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthResponseDto {
  /// Returns a new [AuthResponseDto] instance.
  AuthResponseDto({
    this.token,
    this.refreshToken,
    this.email,
    this.accountResponseDTO,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? token;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? refreshToken;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? email;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  AccountDto? accountResponseDTO;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AuthResponseDto &&
    other.token == token &&
    other.refreshToken == refreshToken &&
    other.email == email &&
    other.accountResponseDTO == accountResponseDTO;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (token == null ? 0 : token!.hashCode) +
    (refreshToken == null ? 0 : refreshToken!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (accountResponseDTO == null ? 0 : accountResponseDTO!.hashCode);

  @override
  String toString() => 'AuthResponseDto[token=$token, refreshToken=$refreshToken, email=$email, accountResponseDTO=$accountResponseDTO]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.token != null) {
      json[r'token'] = this.token;
    } else {
      json[r'token'] = null;
    }
    if (this.refreshToken != null) {
      json[r'refreshToken'] = this.refreshToken;
    } else {
      json[r'refreshToken'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.accountResponseDTO != null) {
      json[r'accountResponseDTO'] = this.accountResponseDTO;
    } else {
      json[r'accountResponseDTO'] = null;
    }
    return json;
  }

  /// Returns a new [AuthResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AuthResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AuthResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AuthResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AuthResponseDto(
        token: mapValueOfType<String>(json, r'token'),
        refreshToken: mapValueOfType<String>(json, r'refreshToken'),
        email: mapValueOfType<String>(json, r'email'),
        accountResponseDTO: AccountDto.fromJson(json[r'accountResponseDTO']),
      );
    }
    return null;
  }

  static List<AuthResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AuthResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AuthResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AuthResponseDto> mapFromJson(dynamic json) {
    final map = <String, AuthResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AuthResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AuthResponseDto-objects as value to a dart map
  static Map<String, List<AuthResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AuthResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AuthResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

