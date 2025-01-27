
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:mobile/data/repositories/implement/account_repository_impl.dart';
import 'package:mobile/di/injection.config.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/implement/auth_repository_impl.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
// void configureDependencies() => getIt.init();

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init(); // Initialize DI
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl());
  getIt.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(
    authenticationRepository: getIt<AuthRepository>(),
    userRepository: getIt<AccountRepository>(),
  ));
}