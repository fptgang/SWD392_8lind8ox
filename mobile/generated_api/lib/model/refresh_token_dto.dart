//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RefreshTokenDto {
  /// Returns a new [RefreshTokenDto] instance.
  RefreshTokenDto({
    this.refreshTokenId,
    this.accountId,
    this.token,
    this.ipAddress,
    this.sessionId,
    this.clientInfo,
    this.createdAt,
    this.expiryDate,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? refreshTokenId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? accountId;

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
  String? ipAddress;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sessionId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? clientInfo;

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
  DateTime? expiryDate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RefreshTokenDto &&
    other.refreshTokenId == refreshTokenId &&
    other.accountId == accountId &&
    other.token == token &&
    other.ipAddress == ipAddress &&
    other.sessionId == sessionId &&
    other.clientInfo == clientInfo &&
    other.createdAt == createdAt &&
    other.expiryDate == expiryDate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (refreshTokenId == null ? 0 : refreshTokenId!.hashCode) +
    (accountId == null ? 0 : accountId!.hashCode) +
    (token == null ? 0 : token!.hashCode) +
    (ipAddress == null ? 0 : ipAddress!.hashCode) +
    (sessionId == null ? 0 : sessionId!.hashCode) +
    (clientInfo == null ? 0 : clientInfo!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (expiryDate == null ? 0 : expiryDate!.hashCode);

  @override
  String toString() => 'RefreshTokenDto[refreshTokenId=$refreshTokenId, accountId=$accountId, token=$token, ipAddress=$ipAddress, sessionId=$sessionId, clientInfo=$clientInfo, createdAt=$createdAt, expiryDate=$expiryDate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.refreshTokenId != null) {
      json[r'refreshTokenId'] = this.refreshTokenId;
    } else {
      json[r'refreshTokenId'] = null;
    }
    if (this.accountId != null) {
      json[r'accountId'] = this.accountId;
    } else {
      json[r'accountId'] = null;
    }
    if (this.token != null) {
      json[r'token'] = this.token;
    } else {
      json[r'token'] = null;
    }
    if (this.ipAddress != null) {
      json[r'ipAddress'] = this.ipAddress;
    } else {
      json[r'ipAddress'] = null;
    }
    if (this.sessionId != null) {
      json[r'sessionId'] = this.sessionId;
    } else {
      json[r'sessionId'] = null;
    }
    if (this.clientInfo != null) {
      json[r'clientInfo'] = this.clientInfo;
    } else {
      json[r'clientInfo'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'createdAt'] = null;
    }
    if (this.expiryDate != null) {
      json[r'expiryDate'] = this.expiryDate!.toUtc().toIso8601String();
    } else {
      json[r'expiryDate'] = null;
    }
    return json;
  }

  /// Returns a new [RefreshTokenDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RefreshTokenDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RefreshTokenDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RefreshTokenDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RefreshTokenDto(
        refreshTokenId: mapValueOfType<int>(json, r'refreshTokenId'),
        accountId: mapValueOfType<int>(json, r'accountId'),
        token: mapValueOfType<String>(json, r'token'),
        ipAddress: mapValueOfType<String>(json, r'ipAddress'),
        sessionId: mapValueOfType<String>(json, r'sessionId'),
        clientInfo: mapValueOfType<String>(json, r'clientInfo'),
        createdAt: mapDateTime(json, r'createdAt', r''),
        expiryDate: mapDateTime(json, r'expiryDate', r''),
      );
    }
    return null;
  }

  static List<RefreshTokenDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RefreshTokenDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RefreshTokenDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RefreshTokenDto> mapFromJson(dynamic json) {
    final map = <String, RefreshTokenDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RefreshTokenDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RefreshTokenDto-objects as value to a dart map
  static Map<String, List<RefreshTokenDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RefreshTokenDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RefreshTokenDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

