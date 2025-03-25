import 'package:mobile/data/models/auth_response_model.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:openapi/api.dart';

import 'account_mapper.dart';

class AuthMapper {
  static AuthResponseModel toModel(AuthResponseDto dto) {
    if (dto.token == null || dto.token!.isEmpty) {
      throw Exception('Invalid auth response: token is required');
    }

    return AuthResponseModel(
      token: dto.token!,
      refreshToken: dto.refreshToken,
      email: dto.email ?? '',
      accountModel: dto.accountResponseDTO != null
          ? AccountMapper.toModel(dto.accountResponseDTO!)
          : AccountModel(
              email: dto.email ?? '',
              firstName: '',
              lastName: '',
              isVisible: true,
              isVerified: false,
              balance: 0,
            ),
    );
  }

  static AuthResponseDto toDto(AuthResponseModel model) {
    return AuthResponseDto(
      token: model.token,
      refreshToken: model.refreshToken,
      email: model.email,
      accountResponseDTO: AccountMapper.toDto(model.accountModel),
    );
  }
}
