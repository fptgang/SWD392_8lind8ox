//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AccountDto {
  /// Returns a new [AccountDto] instance.
  AccountDto({
    this.accountId,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.avatarUrl,
    this.balance,
    this.role,
    this.isVerified,
    this.verifiedAt,
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
  int? accountId;

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
  String? firstName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? lastName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? password;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? avatarUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? balance;

  AccountDtoRoleEnum? role;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isVerified;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? verifiedAt;

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
  bool operator ==(Object other) => identical(this, other) || other is AccountDto &&
    other.accountId == accountId &&
    other.email == email &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.password == password &&
    other.avatarUrl == avatarUrl &&
    other.balance == balance &&
    other.role == role &&
    other.isVerified == isVerified &&
    other.verifiedAt == verifiedAt &&
    other.isVisible == isVisible &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accountId == null ? 0 : accountId!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (firstName == null ? 0 : firstName!.hashCode) +
    (lastName == null ? 0 : lastName!.hashCode) +
    (password == null ? 0 : password!.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (balance == null ? 0 : balance!.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (isVerified == null ? 0 : isVerified!.hashCode) +
    (verifiedAt == null ? 0 : verifiedAt!.hashCode) +
    (isVisible == null ? 0 : isVisible!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode);

  @override
  String toString() => 'AccountDto[accountId=$accountId, email=$email, firstName=$firstName, lastName=$lastName, password=$password, avatarUrl=$avatarUrl, balance=$balance, role=$role, isVerified=$isVerified, verifiedAt=$verifiedAt, isVisible=$isVisible, createdAt=$createdAt, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.accountId != null) {
      json[r'accountId'] = this.accountId;
    } else {
      json[r'accountId'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.firstName != null) {
      json[r'firstName'] = this.firstName;
    } else {
      json[r'firstName'] = null;
    }
    if (this.lastName != null) {
      json[r'lastName'] = this.lastName;
    } else {
      json[r'lastName'] = null;
    }
    if (this.password != null) {
      json[r'password'] = this.password;
    } else {
      json[r'password'] = null;
    }
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
    if (this.balance != null) {
      json[r'balance'] = this.balance;
    } else {
      json[r'balance'] = null;
    }
    if (this.role != null) {
      json[r'role'] = this.role;
    } else {
      json[r'role'] = null;
    }
    if (this.isVerified != null) {
      json[r'isVerified'] = this.isVerified;
    } else {
      json[r'isVerified'] = null;
    }
    if (this.verifiedAt != null) {
      json[r'verifiedAt'] = this.verifiedAt!.toUtc().toIso8601String();
    } else {
      json[r'verifiedAt'] = null;
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

  /// Returns a new [AccountDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AccountDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AccountDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AccountDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AccountDto(
        accountId: mapValueOfType<int>(json, r'accountId'),
        email: mapValueOfType<String>(json, r'email'),
        firstName: mapValueOfType<String>(json, r'firstName'),
        lastName: mapValueOfType<String>(json, r'lastName'),
        password: mapValueOfType<String>(json, r'password'),
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl'),
        balance: mapValueOfType<double>(json, r'balance'),
        role: AccountDtoRoleEnum.fromJson(json[r'role']),
        isVerified: mapValueOfType<bool>(json, r'isVerified'),
        verifiedAt: mapDateTime(json, r'verifiedAt', r''),
        isVisible: mapValueOfType<bool>(json, r'isVisible'),
        createdAt: mapDateTime(json, r'createdAt', r''),
        updatedAt: mapDateTime(json, r'updatedAt', r''),
      );
    }
    return null;
  }

  static List<AccountDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AccountDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AccountDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AccountDto> mapFromJson(dynamic json) {
    final map = <String, AccountDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AccountDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AccountDto-objects as value to a dart map
  static Map<String, List<AccountDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AccountDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AccountDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class AccountDtoRoleEnum {
  /// Instantiate a new enum with the provided [value].
  const AccountDtoRoleEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ADMIN = AccountDtoRoleEnum._(r'ADMIN');
  static const STAFF = AccountDtoRoleEnum._(r'STAFF');
  static const CLIENT = AccountDtoRoleEnum._(r'CLIENT');
  static const FREELANCER = AccountDtoRoleEnum._(r'FREELANCER');

  /// List of all possible values in this [enum][AccountDtoRoleEnum].
  static const values = <AccountDtoRoleEnum>[
    ADMIN,
    STAFF,
    CLIENT,
    FREELANCER,
  ];

  static AccountDtoRoleEnum? fromJson(dynamic value) => AccountDtoRoleEnumTypeTransformer().decode(value);

  static List<AccountDtoRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AccountDtoRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AccountDtoRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AccountDtoRoleEnum] to String,
/// and [decode] dynamic data back to [AccountDtoRoleEnum].
class AccountDtoRoleEnumTypeTransformer {
  factory AccountDtoRoleEnumTypeTransformer() => _instance ??= const AccountDtoRoleEnumTypeTransformer._();

  const AccountDtoRoleEnumTypeTransformer._();

  String encode(AccountDtoRoleEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AccountDtoRoleEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AccountDtoRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ADMIN': return AccountDtoRoleEnum.ADMIN;
        case r'STAFF': return AccountDtoRoleEnum.STAFF;
        case r'CLIENT': return AccountDtoRoleEnum.CLIENT;
        case r'FREELANCER': return AccountDtoRoleEnum.FREELANCER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AccountDtoRoleEnumTypeTransformer] instance.
  static AccountDtoRoleEnumTypeTransformer? _instance;
}


