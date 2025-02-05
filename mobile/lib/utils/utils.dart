class Utils {
  static List<T> listFromJson<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
    if (json is List) {
      return json.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }
}