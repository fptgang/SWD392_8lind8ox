
import 'package:mobile/data/models/jwt_response_model.dart';
import 'package:openapi/api.dart';

class JwtMapper {
  static JwtResponseModel toModel(JwtResponseDto dto) {
    return JwtResponseModel(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
  }
}