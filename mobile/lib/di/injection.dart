import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/blocs/blindbox_detail/blindbox_detail_bloc.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/cubit/locale_cubit/locale_cubit.dart';
import 'package:mobile/cubit/set_cubit/set_cubit.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:mobile/data/repositories/brand_repository.dart';
import 'package:mobile/data/repositories/implement/account_repository_impl.dart';
import 'package:mobile/data/repositories/implement/blindbox_repository_impl.dart';
import 'package:mobile/data/repositories/implement/brand_repository_impl.dart';
import 'package:mobile/data/repositories/implement/set_repository_impl.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/di/injection.config.dart';
import 'package:openapi/api.dart';
import '../blocs/login/login_bloc.dart';
import '../cubit/blindbox_list_cubit/blindbox_list_cubit.dart';
import '../cubit/dropdown_cubit/dropdown_cubit.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/blindbox_repository.dart';
import '../data/repositories/implement/auth_repository_impl.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)

@InjectableInit()
Future<void> configureDependencies() async {
  var box = Hive.box('authentication');
  getIt.init();

  //lazy singleton
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl());
  getIt.registerLazySingleton<BlindBoxRepository>(() => BlindBoxRepositoryImpl());
  getIt.registerLazySingleton<BrandRepository>(() => BrandRepositoryImpl());
  getIt.registerLazySingleton<SetRepository>(() => SetRepositoryImpl());
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
  getIt.registerLazySingleton<DefaultApi>(
          () => DefaultApi(ApiClient(basePath: dotenv.env['BASE_URL'] ?? '')..authentication?.applyToParams([], {
        "Authorization": "Bearer ${box.get('loginToken')}",
      })));
  getIt.registerLazySingleton<SetCubit>(() => SetCubit(getIt<SetRepository>()));

  //factory
  getIt.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(
        authenticationRepository: getIt<AuthRepository>(),
        userRepository: getIt<AccountRepository>(),
      ));
  getIt.registerFactory<LoginBloc>(() => LoginBloc(
        authRepository: getIt<AuthRepository>(),
      ));
  getIt.registerFactory<BlindBoxDetailBloc>(() => BlindBoxDetailBloc(blindBoxRepository: getIt<BlindBoxRepository>()));


  //cubit factory
  getIt.registerFactory<DropdownCubit>(() => DropdownCubit(getIt<LocaleCubit>()));
  getIt.registerLazySingleton<CartCubit>(() => CartCubit());
  getIt.registerFactory<BlindBoxesCubit>(() => BlindBoxesCubit(getIt<BlindBoxRepository>()));
}
