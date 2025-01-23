import 'package:mobile/data/repositories/auth_repository.dart';

import '../../../data/models/auth_response_model.dart';

class LoginViewModel {
  LoginViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<AuthResponseModel> login(String email, String password) async {
    return _authRepository.login(email, password);
  }
}
