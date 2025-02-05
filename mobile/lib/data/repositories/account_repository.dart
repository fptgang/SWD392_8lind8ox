
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/account_model.dart';

@Singleton()
@injectable
abstract class AccountRepository{

  Future<AccountModel> getUser();
}