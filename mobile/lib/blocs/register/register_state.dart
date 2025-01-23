class RegisterState {
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? firstName;
  final String? lastName;
  final String? registerStatus;

  RegisterState({
    this.email,
    this.password,
    this.confirmPassword,
    this.firstName,
    this.lastName,
    this.registerStatus,
  });

  RegisterState copyWith({String? registerStatus}) {
    return RegisterState(registerStatus: registerStatus);
  }
}
