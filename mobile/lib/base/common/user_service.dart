//
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mobile/data/models/account_model.dart';
// import 'package:mobile/data/models/refresh_token_model.dart';
// import 'package:mobile/ui/core/storage_keys_helper.dart';
// import 'package:mobile/utils/utils.dart';
//
// class UserService {
//
//   static bool isGuest = false;
//
//   static RefreshTokenModel userToken = RefreshTokenModel();
//   static bool isLoged = false;
//
//   static bool isLoggedIn = false;
//   static bool isLoggedInWithGoogleAuth = false;
//   static bool isLoginWithSocial = false;
//   static bool isLoginGoogleAuth = false;
//   static bool isLoginOTP = false;
//   static bool isLoginWithCheckPhienDangNhap = false;
//   static bool isLoginWithBiometric = false;
//
//   static Future<void> removeUser(BuildContext context) async {
//     await SharedPreferencesHelper.instance.removeKey(key: 'access_token');
//     userToken.token = '';
//     userToken.accountId;
//     isLoged = false;
//     isLoginWithSocial = false;
//     // await CoreRoutes.instance.navigateAndRemove(CoreRouteNames.LOGIN, arguments: true);
//     context.go('/main/home');
//     // await Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false, arguments: true);
//   }
//
//   static void getwelcome() {
//     userToken.token = SharedPreferencesHelper.instance.getString(key: 'access_token')!;
//
//     // userToken.session =
//     //     SharedPreferencesHelper.instance.getString(key: 'userToken.session');
//     userToken.accountId = SharedPreferencesHelper.instance.getInt(key: 'userid')!;
//     // userToken.remember =
//     //     SharedPreferencesHelper.instance.getBool(key: 'userToken.remember');
//
//     // userToken.remember = userToken.remember ?? false;
//     // userToken.avatar =
//     //     SharedPreferencesHelper.instance.getString(key: 'userToken.avatar');
//   }
//
//   static void setUser(RefreshTokenModel userToken) {
//     SharedPreferencesHelper.instance.setString(key: 'access_token', val: userToken.token);
//     SharedPreferencesHelper.instance.setString(key: 'refresh_token', val: userToken.token);
//     SharedPreferencesHelper.instance.setInt(key: 'userid', val: userToken.accountId ?? 1);
//     userToken = userToken;
//   }
//
//   // static void setAvatar(String urlAvatar) {
//   //   SharedPreferencesHelper.instance.setString(
//   //     key: 'user_avatar',
//   //     val: urlAvatar,
//   //   );
//   //   userToken.avatar = urlAvatar;
//   // }
//
//   // static Future<String> getUserName() {
//   //   return StorageHelper.instance.read(SecureKey.USERNAME);
//   // }
//
//   static Future<void> setUserFullName(String userFullName) async {
//     await StorageHelper.instance.write(SecureKey.FULLNAME, userFullName);
//   }
//
//   static Future<Object> getUserFullName() async {
//     return await StorageHelper.instance.read(SecureKey.FULLNAME);
//   }
//
//   // static String getUserName() {
//   //   return SharedPreferencesHelper.instance.getString(key: 'userid');
//   // }
//
//   static Future<Future<String?>> getUserName() {
//     return StorageHelper.instance.read(SecureKey.USERNAME);
//   }
//
//   static Future<Future<String?>> getUserId() {
//     return StorageHelper.instance.read(SecureKey.USERID);
//   }
//
//   static Future<void> setPassword(String password) async {
//     await StorageHelper.instance.write(SecureKey.PASSWORD, password);
//   }
//
//   static Future<Future<String?>> getPassword() {
//     return StorageHelper.instance.read(SecureKey.PASSWORD);
//   }
//
//   static void setLastUser(String lastUser) {
//     SharedPreferencesHelper.instance.setString(key: 'lastUser', val: lastUser);
//   }
//
//   static String? getLastUser() {
//     return SharedPreferencesHelper.instance.getString(key: 'lastUser');
//   }
//
//
//   static Future<void> setToken({required String token, required String refreshToken, required int timeExpired}) async {
//     await SharedPreferencesHelper.instance.setString(key: 'access_token', val: token);
//     userToken.token = token;
//     setTimeRefresh(timeExpired);
//     // if (ConfigAPI.isRefreshToken) {
//     //   setTimeRefresh(timeExpired);
//     // }
//     // if (ConfigAPI.isRefreshTokenFlow) {
//     //   setTimeRefreshToken(timeExpired);
//     // } else {
//     //   if (ConfigAPI.isForceLoginExpiredTokenFlow) {
//     //     setTimeForceLoginExpiredToken(timeExpired);
//     //   }
//     // }
//   }
//
//   static String? getToken() {
//     return SharedPreferencesHelper.instance.getString(key: 'access_token');
//   }
//
//   static String? getRefreshToken() {
//     return SharedPreferencesHelper.instance.getString(key: 'refresh_token');
//   }
//
//   static String? getKeyStore() {
//     return SharedPreferencesHelper.instance.getString(key: 'KeyStore');
//   }
//
//   static String? getTypeLogin() {
//     return SharedPreferencesHelper.instance.getString(key: 'typeLogin');
//   }
//
//   // số điện thoại kiểm tra khai báo y tế
//   static void setLookupPhone(String phone) {
//     SharedPreferencesHelper.instance.setString(key: 'lookupPhone', val: phone);
//   }
//
//   static String? getLookupPhone() {
//     return SharedPreferencesHelper.instance.getString(key: 'lookupPhone');
//   }
//
//   // tư cách đăng nhập khách hàng/nhân viên y tế
//   static void setRole(int selected) {
//     SharedPreferencesHelper.instance.setString(key: 'RolePlay', val: selected == 2 ? 'staff' : 'customer');
//   }
//
//   static String? getRole() {
//     return SharedPreferencesHelper.instance.getString(key: 'RolePlay');
//   }
//
//   // số điện thoại đăng nhập
//   static void setPhone(String phone) {
//     SharedPreferencesHelper.instance.setString(key: 'phone', val: phone);
//   }
//
//   static String? getPhone() {
//     return SharedPreferencesHelper.instance.getString(key: 'phone');
//   }
//
//   // permission location
//   static void setPermissionLocation(bool check) {
//     SharedPreferencesHelper.instance.setBool(key: 'permissionLocation', val: check);
//   }
//
//   static bool? getPermissionLocation() {
//     return SharedPreferencesHelper.instance.getBool(key: 'permissionLocation');
//   }
//
//   // email đăng nhập
//   static void setEmail(String email) {
//     SharedPreferencesHelper.instance.setString(key: 'email', val: email);
//   }
//
//   static String? getEmail() {
//     return SharedPreferencesHelper.instance.getString(key: 'email');
//   }
//
//   // thời gian refresh token
//   static void setTimeRefreshToken(int time) {
//     var now = DateTime.now();
//     now = now.add(Duration(seconds: time));
//     SharedPreferencesHelper.instance.setInt(key: 'timeRefreshToken', val: now.totalSeconds());
//   }
//
//   // thời gian expired token
//   static void setTimeForceLoginExpiredToken(int time) {
//     var now = DateTime.now();
//     now = now.add(Duration(seconds: time));
//     SharedPreferencesHelper.instance.setInt(key: 'timeForceLoginExpiredToken', val: now.totalSeconds());
//   }
//
//   // thời gian refresh token
//   static void setTimeRefresh(int time) {
//     var now = DateTime.now();
//     now = now.add(Duration(seconds: time));
//     SharedPreferencesHelper.instance.setInt(key: 'timeRefresh', val: now.totalSeconds());
//   }
//
//   static int? getTimeRefreshToken() {
//     return SharedPreferencesHelper.instance.getInt(key: 'timeRefreshToken');
//   }
//
//   static int? getTimeForceLoginExpiredToken() {
//     return SharedPreferencesHelper.instance.getInt(key: 'timeForceLoginExpiredToken');
//   }
//
//   static int? getTimeRefresh() {
//     return SharedPreferencesHelper.instance.getInt(key: 'timeRefresh');
//   }
//
// }
