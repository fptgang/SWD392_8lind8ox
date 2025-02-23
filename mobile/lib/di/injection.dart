import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/blocs/blindbox_detail/blindbox_detail_bloc.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/blocs/brand/brand_bloc.dart';
import 'package:mobile/blocs/search/search_bloc.dart';
import 'package:mobile/blocs/set/set_bloc.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/cubit/locale_cubit/locale_cubit.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:mobile/data/repositories/brand_repository.dart';
import 'package:mobile/data/repositories/implement/account_repository_impl.dart';
import 'package:mobile/data/repositories/implement/blindbox_repository_impl.dart';
import 'package:mobile/data/repositories/implement/brand_repository_impl.dart';
import 'package:mobile/data/repositories/implement/set_repository_impl.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/di/injection.config.dart';
import 'package:openapi/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/login/login_bloc.dart';
import '../cubit/dropdown_cubit/dropdown_cubit.dart';
import '../data/datasources/local/impl/search_local_datasource_impl.dart';
import '../data/datasources/local/search_local_datasource.dart';
import '../data/datasources/shared_preferences/shared_pref_manager.dart';
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
  final sharedPreferences = await SharedPreferences.getInstance();
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
  getIt.registerLazySingleton<SetBloc>(() => SetBloc(getIt<SetRepository>()));
  getIt.registerLazySingleton<BrandBloc>(() => BrandBloc(getIt<BrandRepository>()));
  getIt.registerLazySingleton<BlindBoxesBloc>(() => BlindBoxesBloc(getIt<BlindBoxRepository>()));
  // getIt.registerLazySingleton<SearchBloc>(() => SearchBloc(getIt<BlindBoxRepository>(),

  //singleton
  getIt.registerSingleton<SharedPrefManager>(SharedPrefManager(sharedPreferences));
  getIt.registerSingleton<SearchLocalDatasource>(SearchLocalDatasourceImpl(getIt<SharedPrefManager>()));

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
}
