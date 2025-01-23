import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final int? accountId;
  final String? email;
  String? firstName;
  String? lastName;
  final String? password;
  String? avatarUrl;
  double? balance;
  // AccountDtoRoleEnum? role;
  bool? isVerified;
  DateTime? verifiedAt;
  bool? isVisible;
  DateTime? createdAt;
  DateTime? updatedAt;

  AccountModel({
    this.accountId,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.balance,
    // this.role,
    this.isVerified,
    this.verifiedAt,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        accountId,
        email,
        password,
        firstName,
        lastName,
        avatarUrl,
        balance,
        // role,
        isVerified,
        verifiedAt,
        isVisible,
        createdAt,
        updatedAt,
      ];
}
