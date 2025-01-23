//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetAccountsPageableParameter {
  /// Returns a new [GetAccountsPageableParameter] instance.
  GetAccountsPageableParameter({
    this.page = 0,
    this.size = 20,
    this.sort = const [],
  });

  /// The page number to retrieve (zero-based index)
  int page;

  /// The size of the page to retrieve
  int size;

  /// Sorting criteria
  List<String> sort;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetAccountsPageableParameter &&
    other.page == page &&
    other.size == size &&
    _deepEquality.equals(other.sort, sort);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (page.hashCode) +
    (size.hashCode) +
    (sort.hashCode);

  @override
  String toString() => 'GetAccountsPageableParameter[page=$page, size=$size, sort=$sort]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'page'] = this.page;
      json[r'size'] = this.size;
      json[r'sort'] = this.sort;
    return json;
  }

  /// Returns a new [GetAccountsPageableParameter] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetAccountsPageableParameter? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GetAccountsPageableParameter[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GetAccountsPageableParameter[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GetAccountsPageableParameter(
        page: mapValueOfType<int>(json, r'page') ?? 0,
        size: mapValueOfType<int>(json, r'size') ?? 20,
        sort: json[r'sort'] is Iterable
            ? (json[r'sort'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<GetAccountsPageableParameter> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetAccountsPageableParameter>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetAccountsPageableParameter.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetAccountsPageableParameter> mapFromJson(dynamic json) {
    final map = <String, GetAccountsPageableParameter>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetAccountsPageableParameter.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetAccountsPageableParameter-objects as value to a dart map
  static Map<String, List<GetAccountsPageableParameter>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetAccountsPageableParameter>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetAccountsPageableParameter.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

