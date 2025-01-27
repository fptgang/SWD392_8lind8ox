//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoDto {
  /// Returns a new [VideoDto] instance.
  VideoDto({
    this.videoId,
    this.accountId,
    this.orderDetailId,
    this.url,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.isVisible,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? videoId;

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
  int? orderDetailId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? url;

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
  DateTime? createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isVisible;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VideoDto &&
    other.videoId == videoId &&
    other.accountId == accountId &&
    other.orderDetailId == orderDetailId &&
    other.url == url &&
    other.description == description &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.isVisible == isVisible;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (videoId == null ? 0 : videoId!.hashCode) +
    (accountId == null ? 0 : accountId!.hashCode) +
    (orderDetailId == null ? 0 : orderDetailId!.hashCode) +
    (url == null ? 0 : url!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode) +
    (isVisible == null ? 0 : isVisible!.hashCode);

  @override
  String toString() => 'VideoDto[videoId=$videoId, accountId=$accountId, orderDetailId=$orderDetailId, url=$url, description=$description, createdAt=$createdAt, updatedAt=$updatedAt, isVisible=$isVisible]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.videoId != null) {
      json[r'videoId'] = this.videoId;
    } else {
      json[r'videoId'] = null;
    }
    if (this.accountId != null) {
      json[r'accountId'] = this.accountId;
    } else {
      json[r'accountId'] = null;
    }
    if (this.orderDetailId != null) {
      json[r'orderDetailId'] = this.orderDetailId;
    } else {
      json[r'orderDetailId'] = null;
    }
    if (this.url != null) {
      json[r'url'] = this.url;
    } else {
      json[r'url'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
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
    if (this.isVisible != null) {
      json[r'isVisible'] = this.isVisible;
    } else {
      json[r'isVisible'] = null;
    }
    return json;
  }

  /// Returns a new [VideoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VideoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "VideoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "VideoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoDto(
        videoId: mapValueOfType<int>(json, r'videoId'),
        accountId: mapValueOfType<int>(json, r'accountId'),
        orderDetailId: mapValueOfType<int>(json, r'orderDetailId'),
        url: mapValueOfType<String>(json, r'url'),
        description: mapValueOfType<String>(json, r'description'),
        createdAt: mapDateTime(json, r'createdAt', r''),
        updatedAt: mapDateTime(json, r'updatedAt', r''),
        isVisible: mapValueOfType<bool>(json, r'isVisible'),
      );
    }
    return null;
  }

  static List<VideoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VideoDto> mapFromJson(dynamic json) {
    final map = <String, VideoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VideoDto-objects as value to a dart map
  static Map<String, List<VideoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VideoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VideoDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

