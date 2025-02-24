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

// import 'package:equatable/equatable.dart';
//
// class AccountModel extends Equatable {
//   // Note: We need to update the empty constant to match non-nullable requirements
//   static const AccountModel empty = AccountModel(
//     accountId: 0,
//     email: '',
//     firstName: '',
//     lastName: '',
//     password: '',
//     avatarUrl: '',
//     balance: 0.0,
//     isVerified: false,
//     verifiedAt: null, // This will need special handling
//     isVisible: false,
//     createdAt: null, // This will need special handling
//     updatedAt: null, // This will need special handling
//   );
//
//   final int accountId;
//   final String email;
//   final String firstName;
//   final String lastName;
//   final String password;
//   final String avatarUrl;
//   final double balance;
//   final bool isVerified;
//   final DateTime? verifiedAt; // Keeping nullable as it makes sense
//   final bool isVisible;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   const AccountModel({
//     required this.accountId,
//     required this.email,
//     required this.password,
//     required this.firstName,
//     required this.lastName,
//     required this.avatarUrl,
//     required this.balance,
//     required this.isVerified,
//     this.verifiedAt, // Can remain nullable
//     required this.isVisible,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   @override
//   List<Object?> get props => [
//     accountId,
//     email,
//     password,
//     firstName,
//     lastName,
//     avatarUrl,
//     balance,
//     isVerified,
//     verifiedAt,
//     isVisible,
//     createdAt,
//     updatedAt,
//   ];
