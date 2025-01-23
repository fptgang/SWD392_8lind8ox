import 'package:equatable/equatable.dart';

import '../../enum/enum.dart';

class LoginState extends Equatable {
  final String? email;
  final String? password;
  final AuthenticationStatus? status;

  LoginState({
    this.email,
    this.password,
    this.status = AuthenticationStatus.unknown,
  });

  LoginState copyWith({
    String? status,
  }) {
    return LoginState(
        status: AuthenticationStatus.unknown,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        password,
        status,
      ];
}

class Loading extends LoginState {}

class LoginSuccess extends LoginState {
  final String? token;

  LoginSuccess({this.token});

// LoginState copyWith({
//   int? accountId,
//   String? email,
//   String? firstName,
//   String? lastName,
//   String? avatarUrl,
//   double? balance,
//   // AccountDtoRoleEnum? role,
//   bool? isVerified,
//   DateTime? verifiedAt,
//   bool? isVisible,
//   DateTime? createdAt,
//   DateTime? updatedAt,
// }) {
//   return LoginSuccess(
//     accountId: accountId ?? this.accountId,
//     email: email ?? this.email,
//     firstName: firstName ?? this.firstName,
//     lastName: lastName ?? this.lastName,
//     avatarUrl: avatarUrl ?? this.avatarUrl,
//     balance: balance ?? this.balance,
//     // role: role ?? this.role,
//     isVerified: isVerified ?? this.isVerified,
//     verifiedAt: verifiedAt ?? this.verifiedAt,
//     isVisible: isVisible ?? this.isVisible,
//     createdAt: createdAt ?? this.createdAt,
//     updatedAt: updatedAt ?? this.updatedAt,
//   );
// }
}
