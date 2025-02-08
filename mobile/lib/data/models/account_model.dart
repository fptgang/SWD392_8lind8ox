import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  static const AccountModel empty = AccountModel();
  final int? accountId;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? avatarUrl;
  final double? balance;
  final bool? isVerified;
  final DateTime? verifiedAt;
  final bool? isVisible;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AccountModel({
    this.accountId,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.balance,
    this.isVerified,
    this.verifiedAt,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
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
    isVerified,
    verifiedAt,
    isVisible,
    createdAt,
    updatedAt,
  ];
}