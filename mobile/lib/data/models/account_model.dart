import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:openapi/api.dart';

class
AccountModel extends Equatable {
  static const AccountModel empty = AccountModel();
  final int? accountId;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? avatarUrl;
  final double? balance;
  final DateTime? updateBalanceAt;
  final AccountDtoRoleEnum? role;
  final bool? isVerified;
  final DateTime? verifiedAt;
  final bool? isVisible;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ShippingInfoModel? defaultShippingInfo;

  const AccountModel({
    this.accountId,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.balance,
    this.updateBalanceAt,
    this.role,
    this.isVerified,
    this.verifiedAt,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
    this.defaultShippingInfo,
  });

  @override
  List<Object?> get props => [
        accountId,
        email,
        password,
        firstName,
        lastName,
        avatarUrl,
        balance,
        updateBalanceAt,
        role,
        isVerified,
        verifiedAt,
        isVisible,
        createdAt,
        updatedAt,
        defaultShippingInfo,
      ];
}
