
import 'package:mobile/data/models/auth_response_model.dart';
import 'package:openapi/api.dart';

class AuthMapper {
  static AuthResponseModel toModel(AuthResponseDto dto) {
    return AuthResponseModel(
      token: dto.token,
      refreshToken: dto.refreshToken,
      email: dto.email,
      accountResponseDTO: dto.accountResponseDTO,
    );
  }
}