//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OrderDetailDto {
  /// Returns a new [OrderDetailDto] instance.
  OrderDetailDto({
    this.orderDetailId,
    this.orderId,
    this.blindBoxId,
    this.packId,
    this.promotionalCampaignId,
    this.originalProductPrice,
    this.discountPrice,
    this.requestUnbox,
    this.unboxedToys = const [],
    this.toyCount,
    this.videoId,
    this.createdAt,
    this.updatedAt,
  });

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
  int? orderId;

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
  int? packId;

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
  double? originalProductPrice;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? discountPrice;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? requestUnbox;

  List<ToyDto> unboxedToys;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? toyCount;

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
  DateTime? createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OrderDetailDto &&
    other.orderDetailId == orderDetailId &&
    other.orderId == orderId &&
    other.blindBoxId == blindBoxId &&
    other.packId == packId &&
    other.promotionalCampaignId == promotionalCampaignId &&
    other.originalProductPrice == originalProductPrice &&
    other.discountPrice == discountPrice &&
    other.requestUnbox == requestUnbox &&
    _deepEquality.equals(other.unboxedToys, unboxedToys) &&
    other.toyCount == toyCount &&
    other.videoId == videoId &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (orderDetailId == null ? 0 : orderDetailId!.hashCode) +
    (orderId == null ? 0 : orderId!.hashCode) +
    (blindBoxId == null ? 0 : blindBoxId!.hashCode) +
    (packId == null ? 0 : packId!.hashCode) +
    (promotionalCampaignId == null ? 0 : promotionalCampaignId!.hashCode) +
    (originalProductPrice == null ? 0 : originalProductPrice!.hashCode) +
    (discountPrice == null ? 0 : discountPrice!.hashCode) +
    (requestUnbox == null ? 0 : requestUnbox!.hashCode) +
    (unboxedToys.hashCode) +
    (toyCount == null ? 0 : toyCount!.hashCode) +
    (videoId == null ? 0 : videoId!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode);

  @override
  String toString() => 'OrderDetailDto[orderDetailId=$orderDetailId, orderId=$orderId, blindBoxId=$blindBoxId, packId=$packId, promotionalCampaignId=$promotionalCampaignId, originalProductPrice=$originalProductPrice, discountPrice=$discountPrice, requestUnbox=$requestUnbox, unboxedToys=$unboxedToys, toyCount=$toyCount, videoId=$videoId, createdAt=$createdAt, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.orderDetailId != null) {
      json[r'orderDetailId'] = this.orderDetailId;
    } else {
      json[r'orderDetailId'] = null;
    }
    if (this.orderId != null) {
      json[r'orderId'] = this.orderId;
    } else {
      json[r'orderId'] = null;
    }
    if (this.blindBoxId != null) {
      json[r'blindBoxId'] = this.blindBoxId;
    } else {
      json[r'blindBoxId'] = null;
    }
    if (this.packId != null) {
      json[r'packId'] = this.packId;
    } else {
      json[r'packId'] = null;
    }
    if (this.promotionalCampaignId != null) {
      json[r'promotionalCampaignId'] = this.promotionalCampaignId;
    } else {
      json[r'promotionalCampaignId'] = null;
    }
    if (this.originalProductPrice != null) {
      json[r'originalProductPrice'] = this.originalProductPrice;
    } else {
      json[r'originalProductPrice'] = null;
    }
    if (this.discountPrice != null) {
      json[r'discountPrice'] = this.discountPrice;
    } else {
      json[r'discountPrice'] = null;
    }
    if (this.requestUnbox != null) {
      json[r'requestUnbox'] = this.requestUnbox;
    } else {
      json[r'requestUnbox'] = null;
    }
      json[r'unboxedToys'] = this.unboxedToys;
    if (this.toyCount != null) {
      json[r'toyCount'] = this.toyCount;
    } else {
      json[r'toyCount'] = null;
    }
    if (this.videoId != null) {
      json[r'videoId'] = this.videoId;
    } else {
      json[r'videoId'] = null;
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

  /// Returns a new [OrderDetailDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OrderDetailDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OrderDetailDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OrderDetailDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OrderDetailDto(
        orderDetailId: mapValueOfType<int>(json, r'orderDetailId'),
        orderId: mapValueOfType<int>(json, r'orderId'),
        blindBoxId: mapValueOfType<int>(json, r'blindBoxId'),
        packId: mapValueOfType<int>(json, r'packId'),
        promotionalCampaignId: mapValueOfType<int>(json, r'promotionalCampaignId'),
        originalProductPrice: mapValueOfType<double>(json, r'originalProductPrice'),
        discountPrice: mapValueOfType<double>(json, r'discountPrice'),
        requestUnbox: mapValueOfType<bool>(json, r'requestUnbox'),
        unboxedToys: ToyDto.listFromJson(json[r'unboxedToys']),
        toyCount: mapValueOfType<int>(json, r'toyCount'),
        videoId: mapValueOfType<int>(json, r'videoId'),
        createdAt: mapDateTime(json, r'createdAt', r''),
        updatedAt: mapDateTime(json, r'updatedAt', r''),
      );
    }
    return null;
  }

  static List<OrderDetailDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OrderDetailDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OrderDetailDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OrderDetailDto> mapFromJson(dynamic json) {
    final map = <String, OrderDetailDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OrderDetailDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OrderDetailDto-objects as value to a dart map
  static Map<String, List<OrderDetailDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OrderDetailDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OrderDetailDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

