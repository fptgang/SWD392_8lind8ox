//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TransactionDto {
  /// Returns a new [TransactionDto] instance.
  TransactionDto({
    this.transactionId,
    this.accountId,
    this.type,
    this.paymentMethod,
    this.dateTime,
    this.amount,
    this.oldBalance,
    this.newBalance,
    this.orderId,
    this.success,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? transactionId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? accountId;

  TransactionDtoTypeEnum? type;

  TransactionDtoPaymentMethodEnum? paymentMethod;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? dateTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? amount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? oldBalance;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? newBalance;

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
  bool? success;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TransactionDto &&
    other.transactionId == transactionId &&
    other.accountId == accountId &&
    other.type == type &&
    other.paymentMethod == paymentMethod &&
    other.dateTime == dateTime &&
    other.amount == amount &&
    other.oldBalance == oldBalance &&
    other.newBalance == newBalance &&
    other.orderId == orderId &&
    other.success == success;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (transactionId == null ? 0 : transactionId!.hashCode) +
    (accountId == null ? 0 : accountId!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (paymentMethod == null ? 0 : paymentMethod!.hashCode) +
    (dateTime == null ? 0 : dateTime!.hashCode) +
    (amount == null ? 0 : amount!.hashCode) +
    (oldBalance == null ? 0 : oldBalance!.hashCode) +
    (newBalance == null ? 0 : newBalance!.hashCode) +
    (orderId == null ? 0 : orderId!.hashCode) +
    (success == null ? 0 : success!.hashCode);

  @override
  String toString() => 'TransactionDto[transactionId=$transactionId, accountId=$accountId, type=$type, paymentMethod=$paymentMethod, dateTime=$dateTime, amount=$amount, oldBalance=$oldBalance, newBalance=$newBalance, orderId=$orderId, success=$success]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.transactionId != null) {
      json[r'transactionId'] = this.transactionId;
    } else {
      json[r'transactionId'] = null;
    }
    if (this.accountId != null) {
      json[r'accountId'] = this.accountId;
    } else {
      json[r'accountId'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.paymentMethod != null) {
      json[r'paymentMethod'] = this.paymentMethod;
    } else {
      json[r'paymentMethod'] = null;
    }
    if (this.dateTime != null) {
      json[r'dateTime'] = this.dateTime!.toUtc().toIso8601String();
    } else {
      json[r'dateTime'] = null;
    }
    if (this.amount != null) {
      json[r'amount'] = this.amount;
    } else {
      json[r'amount'] = null;
    }
    if (this.oldBalance != null) {
      json[r'oldBalance'] = this.oldBalance;
    } else {
      json[r'oldBalance'] = null;
    }
    if (this.newBalance != null) {
      json[r'newBalance'] = this.newBalance;
    } else {
      json[r'newBalance'] = null;
    }
    if (this.orderId != null) {
      json[r'orderId'] = this.orderId;
    } else {
      json[r'orderId'] = null;
    }
    if (this.success != null) {
      json[r'success'] = this.success;
    } else {
      json[r'success'] = null;
    }
    return json;
  }

  /// Returns a new [TransactionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TransactionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TransactionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TransactionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TransactionDto(
        transactionId: mapValueOfType<int>(json, r'transactionId'),
        accountId: mapValueOfType<int>(json, r'accountId'),
        type: TransactionDtoTypeEnum.fromJson(json[r'type']),
        paymentMethod: TransactionDtoPaymentMethodEnum.fromJson(json[r'paymentMethod']),
        dateTime: mapDateTime(json, r'dateTime', r''),
        amount: mapValueOfType<double>(json, r'amount'),
        oldBalance: mapValueOfType<double>(json, r'oldBalance'),
        newBalance: mapValueOfType<double>(json, r'newBalance'),
        orderId: mapValueOfType<int>(json, r'orderId'),
        success: mapValueOfType<bool>(json, r'success'),
      );
    }
    return null;
  }

  static List<TransactionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TransactionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TransactionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TransactionDto> mapFromJson(dynamic json) {
    final map = <String, TransactionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TransactionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TransactionDto-objects as value to a dart map
  static Map<String, List<TransactionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TransactionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TransactionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class TransactionDtoTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const TransactionDtoTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const DEPOSIT = TransactionDtoTypeEnum._(r'DEPOSIT');
  static const WITHDRAW = TransactionDtoTypeEnum._(r'WITHDRAW');
  static const ORDER = TransactionDtoTypeEnum._(r'ORDER');
  static const PAYOUT = TransactionDtoTypeEnum._(r'PAYOUT');

  /// List of all possible values in this [enum][TransactionDtoTypeEnum].
  static const values = <TransactionDtoTypeEnum>[
    DEPOSIT,
    WITHDRAW,
    ORDER,
    PAYOUT,
  ];

  static TransactionDtoTypeEnum? fromJson(dynamic value) => TransactionDtoTypeEnumTypeTransformer().decode(value);

  static List<TransactionDtoTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TransactionDtoTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TransactionDtoTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TransactionDtoTypeEnum] to String,
/// and [decode] dynamic data back to [TransactionDtoTypeEnum].
class TransactionDtoTypeEnumTypeTransformer {
  factory TransactionDtoTypeEnumTypeTransformer() => _instance ??= const TransactionDtoTypeEnumTypeTransformer._();

  const TransactionDtoTypeEnumTypeTransformer._();

  String encode(TransactionDtoTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TransactionDtoTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TransactionDtoTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'DEPOSIT': return TransactionDtoTypeEnum.DEPOSIT;
        case r'WITHDRAW': return TransactionDtoTypeEnum.WITHDRAW;
        case r'ORDER': return TransactionDtoTypeEnum.ORDER;
        case r'PAYOUT': return TransactionDtoTypeEnum.PAYOUT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TransactionDtoTypeEnumTypeTransformer] instance.
  static TransactionDtoTypeEnumTypeTransformer? _instance;
}



class TransactionDtoPaymentMethodEnum {
  /// Instantiate a new enum with the provided [value].
  const TransactionDtoPaymentMethodEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PAYPAL = TransactionDtoPaymentMethodEnum._(r'PAYPAL');
  static const VNPAY = TransactionDtoPaymentMethodEnum._(r'VNPAY');

  /// List of all possible values in this [enum][TransactionDtoPaymentMethodEnum].
  static const values = <TransactionDtoPaymentMethodEnum>[
    PAYPAL,
    VNPAY,
  ];

  static TransactionDtoPaymentMethodEnum? fromJson(dynamic value) => TransactionDtoPaymentMethodEnumTypeTransformer().decode(value);

  static List<TransactionDtoPaymentMethodEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TransactionDtoPaymentMethodEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TransactionDtoPaymentMethodEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TransactionDtoPaymentMethodEnum] to String,
/// and [decode] dynamic data back to [TransactionDtoPaymentMethodEnum].
class TransactionDtoPaymentMethodEnumTypeTransformer {
  factory TransactionDtoPaymentMethodEnumTypeTransformer() => _instance ??= const TransactionDtoPaymentMethodEnumTypeTransformer._();

  const TransactionDtoPaymentMethodEnumTypeTransformer._();

  String encode(TransactionDtoPaymentMethodEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TransactionDtoPaymentMethodEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TransactionDtoPaymentMethodEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PAYPAL': return TransactionDtoPaymentMethodEnum.PAYPAL;
        case r'VNPAY': return TransactionDtoPaymentMethodEnum.VNPAY;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TransactionDtoPaymentMethodEnumTypeTransformer] instance.
  static TransactionDtoPaymentMethodEnumTypeTransformer? _instance;
}


