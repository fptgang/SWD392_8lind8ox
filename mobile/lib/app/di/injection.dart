import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';
import 'package:mobile/app/cubits/locale_cubit.dart';
import 'package:mobile/app/di/injection.config.dart';
import 'package:mobile/data/network/dio_client.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:mobile/data/repositories/brand_repository.dart';
import 'package:mobile/data/repositories/implement/account_repository_impl.dart';
import 'package:mobile/data/repositories/implement/blindbox_repository_impl.dart';
import 'package:mobile/data/repositories/implement/brand_repository_impl.dart';
import 'package:mobile/data/repositories/implement/order_detail_repository_impl.dart';
import 'package:mobile/data/repositories/implement/order_repository_impl.dart';
import 'package:mobile/data/repositories/implement/promotion_repository_impl.dart';
import 'package:mobile/data/repositories/implement/set_repository_impl.dart';
import 'package:mobile/data/repositories/implement/shipping_info_repository_impl.dart';
import 'package:mobile/data/repositories/implement/voucher_repository_impl.dart';
import 'package:mobile/data/repositories/order_detail_repository.dart';
import 'package:mobile/data/repositories/promotion_repository.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/data/repositories/transaction_repository.dart';
import 'package:mobile/data/services/token_refresh_service.dart';
import 'package:mobile/data/services/token_service.dart';
import 'package:mobile/feature/cart/cubits/cart_cubit.dart';
import 'package:mobile/feature/checkout/blocs/checkout_bloc.dart';
import 'package:mobile/feature/checkout/blocs/voucher/voucher_bloc.dart';
import 'package:mobile/feature/detail/blocs/blindbox_detail_bloc.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/feature/home/blocs/promotion/promotion_bloc.dart';
import 'package:mobile/feature/home/blocs/set/set_bloc.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_bloc.dart';
import 'package:mobile/feature/wallet/bloc/wallet_bloc.dart';
import 'package:openapi/api.dart';
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

  if (!getIt.isRegistered<DefaultApi>()) {
    getIt.registerLazySingleton<DefaultApi>(() {
      final apiClient = ApiClient(basePath: dotenv.env['BASE_URL'] ?? '');
      final token = box.get('loginToken');
      if (token != null && token.isNotEmpty) {
        apiClient.addDefaultHeader("Authorization", token);
      }
      return DefaultApi(apiClient);
    });
  }
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
      ),
    );
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
  if (!getIt.isRegistered<CartCubit>()) {
    getIt.registerLazySingleton<CartCubit>(() => CartCubit());
  }

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
        () => CartGlobalBloc(getIt<OrderRepository>(), getIt<SkuRepository>()));
  }

  if (!getIt.isRegistered<WalletBloc>()) {
    getIt.registerLazySingleton<WalletBloc>(
            () => WalletBloc(getIt<TransactionRepository>(), getIt<AccountRepository>()));
  }

  if (!getIt.isRegistered<PromotionBloc>()) {
    getIt.registerLazySingleton<PromotionBloc>(
        () => PromotionBloc(getIt<PromotionRepository>()));
  }

  if (!getIt.isRegistered<VoucherBloc>()) {
    getIt.registerLazySingleton<VoucherBloc>(
            () => VoucherBloc(getIt<VoucherRepository>()));
  }


  if (!getIt.isRegistered<BlindBoxesListBloc>()) {
    getIt.registerLazySingleton<BlindBoxesListBloc>(
        () => BlindBoxesListBloc(getIt<BlindBoxRepository>()));
  }

  if (!getIt.isRegistered<OrderDetailBloc>()) {
    getIt.registerLazySingleton<OrderDetailBloc>(() => OrderDetailBloc(
          orderDetailRepository: getIt<OrderDetailRepository>(),
        ));
  }

  if (!getIt.isRegistered<ShippingInfoBloc>()) {
    getIt.registerLazySingleton<ShippingInfoBloc>(
        () => ShippingInfoBloc(getIt<ShippingInfoRepository>()));
  }

  if (!getIt.isRegistered<CheckoutBloc>()) {
    getIt.registerLazySingleton<CheckoutBloc>(() => CheckoutBloc(
          getIt<VoucherRepository>(),
          orderRepository: getIt<OrderRepository>(),
        ));
  }

  // Factory Blocs (short-lived, recreated frequently)
  getIt.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(
        authenticationRepository: getIt<AuthRepository>(),
        userRepository: getIt<AccountRepository>(),
      ));

  getIt.registerFactory<LoginBloc>(() => LoginBloc(
        authRepository: getIt<AuthRepository>(),
      ));

  getIt.registerFactory<BlindBoxDetailBloc>(() => BlindBoxDetailBloc(
        blindBoxRepository: getIt<BlindBoxRepository>(),
        skuRepository: getIt<SkuRepository>(),
        imageRepository: getIt<ImageRepository>(),
      ));
}
