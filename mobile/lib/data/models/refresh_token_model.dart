

class RefreshTokenModel{
  final int? refreshTokenId;
  int? accountId;
  String? token;
  final String? ipAddress;
  final String? sessionId;
  String? clientInfo;
  DateTime? expiryDate;

  RefreshTokenModel({
    this.refreshTokenId,
    this.accountId,
    this.token,
    this.ipAddress,
    this.sessionId,
    this.clientInfo,
    this.expiryDate,
  });

  List<Object?> get props => [refreshTokenId, accountId, token, ipAddress, sessionId, clientInfo, expiryDate];
}