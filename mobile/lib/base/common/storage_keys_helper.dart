// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// enum SecureKey { USERID, USERNAME, PASSWORD, FULLNAME, FORCE_UPDATE_LINK_FROM_BACKGROUND, IOS_DEVICE_ID, TOKEN }
//
// class StorageHelper {
//   StorageHelper._();
//
//   static final StorageHelper instance = StorageHelper._();
//
//   final storage = const FlutterSecureStorage();
//
//   String _enumToKey(SecureKey key) {
//     switch (key) {
//       case SecureKey.USERID:
//         return 'userid';
//       case SecureKey.USERNAME:
//         return 'username';
//       case SecureKey.PASSWORD:
//         return 'password';
//       case SecureKey.FULLNAME:
//         return 'fullname';
//       case SecureKey.FORCE_UPDATE_LINK_FROM_BACKGROUND:
//         return 'forceUpdateLinkFromBackground';
//       case SecureKey.IOS_DEVICE_ID:
//         return 'iosDeviceId';
//       case SecureKey.TOKEN:
//         return 'token';
//       }
//   }
//
//   Future<Map<String, String>> readAllValues() async {
//     final _result = await storage.readAll();
//     return _result;
//   }
//
//   Future<Future<String?>> read(SecureKey key) async {
//     final secureKey = _enumToKey(key);
//     return storage.read(key: secureKey);
//   }
//
//   Future<void> write(SecureKey key, String val) async {
//     final secureKey = _enumToKey(key);
//     await storage.write(key: secureKey, value: val);
//   }
//
//   Future<bool> containsKey(SecureKey key) async {
//     final secureKey = _enumToKey(key);
//     final rs = await storage.containsKey(key: secureKey);
//     return rs;
//   }
//
//   Future<void> deleteAll() async {
//     await storage.deleteAll();
//   }
//
//   Future<void> delete(SecureKey key) async {
//     final secureKey = _enumToKey(key);
//     await storage.delete(key: secureKey);
//   }
// }
//
// class SharedPreferencesHelper {
//   SharedPreferences? _prefs;
//
//   SharedPreferencesHelper._();
//
//   static final SharedPreferencesHelper instance = SharedPreferencesHelper._();
//
//   /// _ChieNV.
//   ///
//   /// *Call init() in main project.
//   ///
//   /// *Create SharedPreferences.getInstance on global.
//   ///
//   /// *Content paste: await SharedPreferencesHelper.instance.init();
//   Future init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }
//
//   Future<Future<bool>?> setString({required String? key, required String? val}) async {
//     return _prefs?.setString(key!, val!);
//   }
//
//   Future<Future<bool>?> setDouble({required String key, required double val}) async {
//     return _prefs?.setDouble(key, val);
//   }
//
//   Future<Future<bool>?> setBool({required String key, required bool val}) async {
//     return _prefs?.setBool(key, val);
//   }
//
//   Future<Future<bool>?> setInt({required String key, required int val}) async {
//     return _prefs?.setInt(key, val);
//   }
//
//   Future<Future<bool>?> setStringList({required String key, required List<String> val}) async {
//     return _prefs?.setStringList(key, val);
//   }
//
//   String? getString({required String key}) {
//     return _prefs?.getString(key);
//   }
//
//   double? getDouble({required String key}) {
//     return _prefs?.getDouble(key);
//   }
//
//   bool? getBool({required String key}) {
//     return _prefs?.getBool(key);
//   }
//
//   int? getInt({required String key}) {
//     return _prefs?.getInt(key);
//   }
//
//   Object? getObj({required String key}) {
//     return _prefs?.get(key);
//   }
//
//   List<String>? getStringList({required String key}) {
//     return _prefs?.getStringList(key);
//   }
//
//   Set<String>? getListKeys() {
//     return _prefs?.getKeys();
//   }
//
//   Future<bool>? removeKey({required String key}) {
//     return _prefs?.remove(key);
//   }
//
//   Future<bool>? clearAllKeys() {
//     return _prefs?.clear();
//   }
//
//   bool? containsKey({required String key}) {
//     return _prefs?.containsKey(key);
//   }
//
//   Future<void>? reloadAll() {
//     return _prefs?.reload();
//   }
// }
