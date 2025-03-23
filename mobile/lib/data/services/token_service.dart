import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TokenService {
  final Box box;

  TokenService({Box? box}) : box = box ?? Hive.box('authentication');

  String? getAccessToken() {
    try {
      final token = box.get('loginToken');
      
      if (token == null) {
        debugPrint('Retrieved access token: ');
        return '';
      }
      
      debugPrint('Retrieved access token: ${token.length > 0 ? "${token.substring(0, min(10, token.length))}..." : "empty"}');

      if (token.length == 0) {
        debugPrint('WARNING: Access token is empty');
        return null;
      }
      return token;
    } catch (e) {
      debugPrint('Error retrieving access token: $e');
      return null;
    }
  }

  String? getRefreshToken() {
    try {
      final token = box.get('refreshToken');
      
      if (token == null) {
        debugPrint('Retrieved refresh token: ');
        return '';
      }
      
      debugPrint('Retrieved refresh token: ${token.length > 0 ? "${token.substring(0, min(10, token.length))}..." : "empty"}');
      
      if (token.length == 0) {
        debugPrint('WARNING: Refresh token is empty');
        return null;
      }
      return token;
    } catch (e) {
      debugPrint('Error retrieving refresh token: $e');
      return null;
    }
  }

  Future<void> saveTokens(String accessToken, String refreshToken, {bool forceWrite = false}) async {
    try {
      // Ensure we don't save null or empty tokens
      if (accessToken.isEmpty || refreshToken.isEmpty) {
        debugPrint('WARNING: Attempted to save empty tokens, skipping');
        return;
      }

      debugPrint('Saving tokens - Access: ${accessToken.substring(0, min(10, accessToken.length))}... Refresh: ${refreshToken.substring(0, min(10, refreshToken.length))}...');

      if (forceWrite) {
        await box.delete('loginToken');
        await box.delete('refreshToken');
        await box.flush();
      }

      // Save tokens
      await box.put('loginToken', accessToken);
      await box.put('refreshToken', refreshToken);
      await box.flush(); // Ensure changes are written to disk

      debugPrint('Tokens saved successfully');

      // Verify tokens were saved
      final verifyAccess = box.get('loginToken');
      final verifyRefresh = box.get('refreshToken');
      debugPrint('Token verification - Access: ${verifyAccess}, Refresh: ${verifyRefresh}');
    } catch (e) {
      debugPrint('Error saving tokens: $e');
      // Try an alternative approach for saving
      try {
        box.put('loginToken', accessToken);
        box.put('refreshToken', refreshToken);
        debugPrint('Attempted fallback token save');
      } catch (e2) {
        debugPrint('Critical error: Failed to save tokens even with fallback method: $e2');
      }
    }
  }

  Future<void> clearTokens() async {
    try {
      debugPrint('Clearing tokens');
      await box.delete('loginToken');
      await box.delete('refreshToken');
      await box.flush();
      debugPrint('Tokens cleared successfully');
    } catch (e) {
      debugPrint('Error clearing tokens: $e');
    }
  }

  bool hasTokens() {
    try {
      final accessToken = getAccessToken();
      final refreshToken = getRefreshToken();
      final hasToken = accessToken != null && accessToken.isNotEmpty &&
          refreshToken != null && refreshToken.isNotEmpty;
      debugPrint('Has tokens: $hasToken');
      return hasToken;
    } catch (e) {
      debugPrint('Error checking if has tokens: $e');
      return false;
    }
  }

  String? getAuthorizationHeader() {
    try {
      final token = getAccessToken();

      // Only add Bearer prefix if token exists and is not empty
      if (token != null && token.isNotEmpty) {
        return token.startsWith('Bearer ') ? token : 'Bearer $token';
      }

      // Return null instead of empty string when no valid token
      return null;
    } catch (e) {
      debugPrint('Error generating auth header: $e');
      return null; // Return null on error
    }
  }

  int min(int a, int b) => a < b ? a : b;
}