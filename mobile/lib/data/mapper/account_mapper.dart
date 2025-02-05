
import 'package:mobile/data/models/account_model.dart';
import 'package:openapi/api.dart';

class AccountMapper{
  static AccountModel toModel(AccountDto dto){
    return AccountModel(
      accountId: dto.accountId,
      firstName: dto.firstName,
      lastName: dto.lastName,
      email: dto.email,
      password: dto.password,
      avatarUrl: dto.avatarUrl,
      balance: dto.balance,
      isVerified: dto.isVerified,
      verifiedAt: dto.verifiedAt,
      isVisible: dto.isVisible,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,

    );
  }

}