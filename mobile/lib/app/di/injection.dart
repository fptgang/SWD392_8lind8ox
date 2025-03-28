import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';
import 'package:mobile/app/cubits/locale_cubit.dart';
import 'package:mobile/app/di/injection.config.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:mobile/data/repositories/brand_repository.dart';
import 'package:mobile/data/repositories/implement/account_repository_impl.dart';
import 'package:mobile/data/repositories/implement/blindbox_repository_impl.dart';
import 'package:mobile/data/repositories/implement/brand_repository_impl.dart';
import 'package:mobile/data/repositories/implement/map_repository_impl.dart';
import 'package:mobile/data/repositories/implement/order_detail_repository_impl.dart';
import 'package:mobile/data/repositories/implement/order_repository_impl.dart';
import 'package:mobile/data/repositories/implement/promotion_repository_impl.dart';
import 'package:mobile/data/repositories/implement/set_repository_impl.dart';
import 'package:mobile/data/repositories/implement/shipping_info_repository_impl.dart';
import 'package:mobile/data/repositories/implement/voucher_repository_impl.dart';
import 'package:mobile/data/repositories/map_repository.dart';
import 'package:mobile/data/repositories/order_detail_repository.dart';
import 'package:mobile/data/repositories/promotion_repository.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/data/repositories/transaction_repository.dart';
import 'package:mobile/data/services/auth_interceptor.dart';
import 'package:mobile/data/services/token_refresh_service.dart';
import 'package:mobile/data/services/token_service.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_bloc.dart';
import 'package:mobile/feature/detail/blocs/blindbox_detail_bloc.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/feature/home/blocs/promotion/promotion_bloc.dart';
import 'package:mobile/feature/home/blocs/set/set_bloc.dart';
import 'package:mobile/feature/order/blocs/order/order_bloc.dart';
import 'package:mobile/feature/wallet/bloc/wallet_bloc.dart';
import 'package:openapi/api.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/impl/search_local_datasource_impl.dart';
import '../../data/datasources/local/search_local_datasource.dart';
import '../../data/datasources/shared_preferences/shared_pref_manager.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/blindbox_repository.dart';
import '../../data/repositories/image_repository.dart';
import '../../data/repositories/implement/auth_repository_impl.dart';
import '../../data/repositories/implement/image_repository_impl.dart';
import '../../data/repositories/implement/sku_repository_imp.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/shipping_info_repository.dart';
import '../../data/repositories/sku_repository.dart';
import '../../data/repositories/voucher_repository.dart';
import '../../feature/auth/login/blocs/login_bloc.dart';
import '../../feature/order/blocs/order_detail/order_detail_bloc.dart';
import '../../feature/profile/cubits/dropdown_cubit.dart';
import '../../feature/profile/blocs/account/account_bloc.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
@InjectableInit()
Future<void> configureDependencies() async {
  try {
    var box = Hive.box('authentication');
    final sharedPreferences = await SharedPreferences.getInstance();

    // Try to initialize injectable, but handle if it fails
    try {
      getIt.init();
    } catch (e) {
      debugPrint('Error initializing GetIt: $e');
      // Continue with manual registrations even if init() fails
    }

    _registerManagers(sharedPreferences);
    _registerRepositories();
    _registerDataSources(getIt<SharedPrefManager>());
    _registerAPI(box);
    _registerBlocs();
  } catch (e) {
    debugPrint('Error configuring dependencies: $e');
    // Create a fallback LocaleCubit instance to prevent cascade failures
    if (!getIt.isRegistered<LocaleCubit>()) {
      getIt.registerSingleton<LocaleCubit>(LocaleCubit());
    }
  }
}

void _registerManagers(SharedPreferences sharedPreferences) {
  // LocaleCubit first to ensure it's available for everything else
  if (!getIt.isRegistered<LocaleCubit>()) {
    getIt.registerSingleton<LocaleCubit>(LocaleCubit());
  }

  // SharedPreferences manager
  if (!getIt.isRegistered<SharedPrefManager>()) {
    getIt.registerSingleton<SharedPrefManager>(
        SharedPrefManager(sharedPreferences));
  }
}

void _registerRepositories() {
  // Register all repositories as LazySignleton
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  }

  if (!getIt.isRegistered<MapRepository>()) {
    getIt.registerLazySingleton<MapRepository>(() => MapRepositoryImpl());
  }

  if (!getIt.isRegistered<AccountRepository>()) {
    getIt.registerLazySingleton<AccountRepository>(
        () => AccountRepositoryImpl());
  }

  if (!getIt.isRegistered<BlindBoxRepository>()) {
    getIt.registerLazySingleton<BlindBoxRepository>(
        () => BlindBoxRepositoryImpl());
  }

  if (!getIt.isRegistered<BrandRepository>()) {
    getIt.registerLazySingleton<BrandRepository>(() => BrandRepositoryImpl());
  }

  if (!getIt.isRegistered<SetRepository>()) {
    getIt.registerLazySingleton<SetRepository>(() => SetRepositoryImpl());
  }

  if (!getIt.isRegistered<SkuRepository>()) {
    getIt.registerLazySingleton<SkuRepository>(() => SkuRepositoryImpl());
  }

  if (!getIt.isRegistered<ImageRepository>()) {
    getIt.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl());
  }

  if (!getIt.isRegistered<OrderRepository>()) {
    getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());
  }

  if (!getIt.isRegistered<OrderDetailRepository>()) {
    getIt.registerLazySingleton<OrderDetailRepository>(
        () => OrderDetailRepositoryImpl());
  }

  if (!getIt.isRegistered<OrderRepository>()) {
    getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());
  }

  if (!getIt.isRegistered<PromotionRepository>()) {
    getIt.registerLazySingleton<PromotionRepository>(
        () => PromotionRepositoryImpl());
  }

  if (!getIt.isRegistered<ShippingInfoRepository>()) {
    getIt.registerLazySingleton<ShippingInfoRepository>(
        () => ShippingInfoRepositoryImpl());
  }

  // Register VoucherRepository if it's not already registered
  if (!getIt.isRegistered<VoucherRepository>()) {
    getIt.registerLazySingleton<VoucherRepository>(
        () => VoucherRepositoryImpl());
  }
}

void _registerDataSources(SharedPrefManager sharedPrefManager) {
  if (!getIt.isRegistered<SearchLocalDatasource>()) {
    getIt.registerSingleton<SearchLocalDatasource>(
        SearchLocalDatasourceImpl(sharedPrefManager));
  }
}

void _registerAPI(Box box) {
  if (!getIt.isRegistered<TokenService>()) {
    getIt.registerLazySingleton<TokenService>(
      () {
        final service = TokenService(box: box);

        final accessToken = service.getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          final parts = accessToken.split('.');
          if (parts.length != 3) {
            debugPrint('⚠️ Invalid token found on startup, clearing tokens');
            service.clearTokens();
          }
        }

        return service;
      },
    );
  }

  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() {
      final dio = Dio(BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      // Add logging in debug mode
      if (kDebugMode) {
        dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
        ));
      }

      return dio;
    });
  }

  if (!getIt.isRegistered<DefaultApi>()) {
    getIt.registerLazySingleton<DefaultApi>(() {
      final apiClient = ApiClient(basePath: dotenv.env['BASE_URL'] ?? '');
      final tokenService = getIt<TokenService>();
      final token = tokenService.getAccessToken();

      if (token != null && token.isNotEmpty) {
        final authHeader =
            token.startsWith('Bearer ') ? token : 'Bearer $token';
        apiClient.addDefaultHeader("Authorization", authHeader);
        debugPrint('Set API client Authorization header: $authHeader');
      } else {
        // Fallback to direct box access if token service fails
        final fallbackToken = box.get('loginToken');
        if (fallbackToken != null && fallbackToken.isNotEmpty) {
          final authHeader = 'Bearer $fallbackToken';
          apiClient.addDefaultHeader("Authorization", authHeader);
          debugPrint('Set fallback API Authorization header: $authHeader');
        } else {
          debugPrint(
              'WARNING: No valid auth token found for API initialization');
        }
      }

      return DefaultApi(apiClient);
    });
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(),
    );
  }

  if (!getIt.isRegistered<AuthInterceptor>()) {
    getIt.registerLazySingleton<AuthInterceptor>(() {
      final interceptor =
          AuthInterceptor(getIt<Dio>(), getIt<AuthRepository>());

      // Add the interceptor to the dio instance
      if (!getIt<Dio>().interceptors.contains(interceptor)) {
        getIt<Dio>().interceptors.add(interceptor);
      }

      return interceptor;
    });

    // Force creation to ensure interceptor is registered
    getIt<AuthInterceptor>();
  }

  if (!getIt.isRegistered<TokenRefreshService>()) {
    getIt.registerLazySingleton<TokenRefreshService>(
      () => TokenRefreshService(
        tokenService: getIt<TokenService>(),
        dio: getIt<Dio>(),
      ),
    );
  }
}

void _registerBlocs() {
  if (!getIt.isRegistered<DropdownCubit>()) {
    getIt.registerFactory<DropdownCubit>(
        () => DropdownCubit(getIt<LocaleCubit>()));
  }

  if (!getIt.isRegistered<SetBloc>()) {
    getIt.registerLazySingleton<SetBloc>(() => SetBloc(
          getIt<SetRepository>(),
          skuRepository: getIt<SkuRepository>(),
          imageRepository: getIt<ImageRepository>(),
        ));
  }
  if (!getIt.isRegistered<CartGlobalBloc>()) {
    getIt.registerLazySingleton<CartGlobalBloc>(
      () => CartGlobalBloc(
        getIt<OrderRepository>(),
        getIt<SkuRepository>(),
      ),
    );
  }

  if (!getIt.isRegistered<WalletBloc>()) {
    getIt.registerLazySingleton<WalletBloc>(() =>
        WalletBloc(getIt<TransactionRepository>(), getIt<AccountRepository>()));
  }

  if (!getIt.isRegistered<PromotionBloc>()) {
    getIt.registerLazySingleton<PromotionBloc>(
        () => PromotionBloc(getIt<PromotionRepository>()));
  }

  if (!getIt.isRegistered<BlindBoxesListBloc>()) {
    getIt.registerLazySingleton<BlindBoxesListBloc>(
        () => BlindBoxesListBloc(getIt<BlindBoxRepository>()));
  }

  if (!getIt.isRegistered<BlindBoxDetailBloc>()) {
    getIt.registerLazySingleton<BlindBoxDetailBloc>(
      () => BlindBoxDetailBloc(
        blindBoxRepository: getIt<BlindBoxRepository>(),
        skuRepository: getIt<SkuRepository>(),
        imageRepository: getIt<ImageRepository>(),
      ),
    );
  }

  if (!getIt.isRegistered<OrderDetailBloc>()) {
    getIt.registerLazySingleton<OrderDetailBloc>(() => OrderDetailBloc(
          orderDetailRepository: getIt<OrderDetailRepository>(),
        ));
  }
  if (!getIt.isRegistered<OrderBloc>()) {
    getIt.registerLazySingleton<OrderBloc>(() => OrderBloc(
          getIt<OrderRepository>(),
        ));
  }

  if (!getIt.isRegistered<ShippingInfoBloc>()) {
    getIt.registerLazySingleton<ShippingInfoBloc>(
        () => ShippingInfoBloc(getIt<ShippingInfoRepository>()));
  }

  // Factory Blocs (short-lived, recreated frequently)
  if (!getIt.isRegistered<AuthenticationBloc>()) {
    getIt.registerLazySingleton<AuthenticationBloc>(
      () => AuthenticationBloc(
        authenticationRepository: getIt<AuthRepository>(),
        userRepository: getIt<AccountRepository>(),
      ),
    );
  }

  getIt.registerFactory<LoginBloc>(() => LoginBloc(
        authRepository: getIt<AuthRepository>(),
      ));

  if (!getIt.isRegistered<AccountBloc>()) {
    getIt.registerLazySingleton<AccountBloc>(
        () => AccountBloc(getIt<AccountRepository>()));
  }
}
