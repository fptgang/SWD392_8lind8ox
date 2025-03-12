import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Utils {
  static List<T> listFromJson<T>(dynamic json, T Function(Map<String, dynamic>) fromJson) {
    if (json is List) {
      return json.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  String getAccountIdFromToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey('your-256-bit-secret'));
      return jwt.payload['accountId'] as String;
    } catch (e) {
      print('Error decoding JWT: $e');
      return '';
    }
  }
}

extension WDateTimeExtension on DateTime {
  static DateTime dateDefault = DateTime(2019, 1, 1);

  int totalSeconds() => difference(dateDefault).inSeconds;
}
