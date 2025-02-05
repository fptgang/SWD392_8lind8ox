import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/repositories/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  AccountModel? _user;

  @override
  Future<AccountModel> getUser() async {
    if (_user != null) return _user!;
    throw Exception('User not found');
  }
}