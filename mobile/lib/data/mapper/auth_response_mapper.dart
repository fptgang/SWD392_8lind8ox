
import 'package:mobile/data/models/auth_response_model.dart';
import 'package:openapi/api.dart';

import 'account_mapper.dart';

class AuthMapper {
  static AuthResponseModel toModel(AuthResponseDto dto) {
    return AuthResponseModel(
      token: dto.token ?? '',
      refreshToken: dto.refreshToken,
      email: dto.email ?? '',
      accountModel: dto.accountResponseDTO != null ? AccountMapper.toModel(dto.accountResponseDTO!) : AccountMapper.toModel(AccountDto()),
    );
  }
}