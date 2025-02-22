import 'package:mobile/data/models/refresh_token_model.dart';
import 'package:openapi/api.dart';

class RefreshTokenMapper {
  static RefreshTokenModel toModel(RefreshTokenDto dto) {
    return RefreshTokenModel(
      refreshTokenId: dto.refreshTokenId!,
      accountId: dto.accountId!,
      token: dto.token!,
      ipAddress: dto.ipAddress!,
      sessionId: dto.sessionId!,
      clientInfo: dto.clientInfo!,
      expiryDate: dto.expiryDate!,
    );
  }
}
