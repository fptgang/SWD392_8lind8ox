//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OrderDto {
  /// Returns a new [OrderDto] instance.
  OrderDto({
    this.orderId,
    this.accountId,
    this.status,
    this.orderDetails = const [],
    this.createdAt,
    this.updatedAt,
    this.totalPrice,
  });

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
  int? accountId;

  OrderDtoStatusEnum? status;

  List<OrderDetailDto> orderDetails;

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
  double? totalPrice;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OrderDto &&
    other.orderId == orderId &&
    other.accountId == accountId &&
    other.status == status &&
    _deepEquality.equals(other.orderDetails, orderDetails) &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.totalPrice == totalPrice;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (orderId == null ? 0 : orderId!.hashCode) +
    (accountId == null ? 0 : accountId!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (orderDetails.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode) +
    (totalPrice == null ? 0 : totalPrice!.hashCode);

  @override
  String toString() => 'OrderDto[orderId=$orderId, accountId=$accountId, status=$status, orderDetails=$orderDetails, createdAt=$createdAt, updatedAt=$updatedAt, totalPrice=$totalPrice]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.orderId != null) {
      json[r'orderId'] = this.orderId;
    } else {
      json[r'orderId'] = null;
    }
    if (this.accountId != null) {
      json[r'accountId'] = this.accountId;
    } else {
      json[r'accountId'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
      json[r'orderDetails'] = this.orderDetails;
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
    if (this.totalPrice != null) {
      json[r'totalPrice'] = this.totalPrice;
    } else {
      json[r'totalPrice'] = null;
    }
    return json;
  }

  /// Returns a new [OrderDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OrderDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OrderDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OrderDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OrderDto(
        orderId: mapValueOfType<int>(json, r'orderId'),
        accountId: mapValueOfType<int>(json, r'accountId'),
        status: OrderDtoStatusEnum.fromJson(json[r'status']),
        orderDetails: OrderDetailDto.listFromJson(json[r'orderDetails']),
        createdAt: mapDateTime(json, r'createdAt', r''),
        updatedAt: mapDateTime(json, r'updatedAt', r''),
        totalPrice: mapValueOfType<double>(json, r'totalPrice'),
      );
    }
    return null;
  }

  static List<OrderDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OrderDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OrderDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OrderDto> mapFromJson(dynamic json) {
    final map = <String, OrderDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OrderDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OrderDto-objects as value to a dart map
  static Map<String, List<OrderDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OrderDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OrderDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class OrderDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const OrderDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING = OrderDtoStatusEnum._(r'PENDING');
  static const COMPLETED = OrderDtoStatusEnum._(r'COMPLETED');
  static const CANCELED = OrderDtoStatusEnum._(r'CANCELED');

  /// List of all possible values in this [enum][OrderDtoStatusEnum].
  static const values = <OrderDtoStatusEnum>[
    PENDING,
    COMPLETED,
    CANCELED,
  ];

  static OrderDtoStatusEnum? fromJson(dynamic value) => OrderDtoStatusEnumTypeTransformer().decode(value);

  static List<OrderDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OrderDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OrderDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OrderDtoStatusEnum] to String,
/// and [decode] dynamic data back to [OrderDtoStatusEnum].
class OrderDtoStatusEnumTypeTransformer {
  factory OrderDtoStatusEnumTypeTransformer() => _instance ??= const OrderDtoStatusEnumTypeTransformer._();

  const OrderDtoStatusEnumTypeTransformer._();

  String encode(OrderDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OrderDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OrderDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING': return OrderDtoStatusEnum.PENDING;
        case r'COMPLETED': return OrderDtoStatusEnum.COMPLETED;
        case r'CANCELED': return OrderDtoStatusEnum.CANCELED;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OrderDtoStatusEnumTypeTransformer] instance.
  static OrderDtoStatusEnumTypeTransformer? _instance;
}


