
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
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
}