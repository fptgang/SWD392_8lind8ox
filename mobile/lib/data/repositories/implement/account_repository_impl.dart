import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/mapper/account_mapper.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:openapi/api.dart';

class AccountRepositoryImpl extends AccountRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  AccountRepositoryImpl() {
    if(box.get('loginToken') != null) {
      _apiService.apiClient.addDefaultHeader("Authorization", "Bearer ${box.get('loginToken')}");
    }
  }

  @override
  Future<AccountModel> getUser() async {
    try {
      debugPrint('token from account repo impl: ${box.get('loginToken')}');
      AccountDto? userDto = await _apiService.getCurrentUser();
      if (userDto == null) {
        throw Exception('Cannot get user information');
      }
      AccountModel user = AccountMapper.toModel(userDto);
      return user;
    } catch (e, stackTrace) {
      throw Exception(
          'Cannot get user information: $e, stackTrace: $stackTrace');
    }
  }
}
