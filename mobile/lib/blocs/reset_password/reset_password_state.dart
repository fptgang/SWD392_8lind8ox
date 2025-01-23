

class ResetPasswordState{
  final String? email;
  final String? status;
  ResetPasswordState({this.email, this.status});

  ResetPasswordState copyWith({String? email}){
    return ResetPasswordState(
        status: status
    );
  }
}