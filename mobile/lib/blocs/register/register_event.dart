
abstract class RegisterEvent{
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent{
  final bool isSuccessfully;

  const RegisterSubmitted(this.isSuccessfully);

  @override
  List<Object?> get props => [isSuccessfully];
}