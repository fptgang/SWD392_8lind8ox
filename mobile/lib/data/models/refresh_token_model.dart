

class RefreshTokenModel{
  final int refreshTokenId;
  final int accountId;
  final String token;
  final String? ipAddress;
  final String? sessionId;
  final String? clientInfo;
  final DateTime expiryDate;

  RefreshTokenModel({
    required this.refreshTokenId,
    required this.accountId,
    required this.token,
    this.ipAddress,
    this.sessionId,
    this.clientInfo,
    required this.expiryDate,
  });
}