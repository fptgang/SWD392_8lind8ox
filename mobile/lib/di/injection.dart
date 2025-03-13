import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/blocs/blindbox_detail/blindbox_detail_bloc.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/blocs/brand/brand_bloc.dart';
import 'package:mobile/blocs/checkout/checkout_bloc.dart';
import 'package:mobile/blocs/promotion/promotion_bloc.dart';
import 'package:mobile/blocs/set/set_bloc.dart';
import 'package:mobile/blocs/shipping_info/shipping_info_bloc.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/cubit/locale_cubit/locale_cubit.dart';
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
import 'package:mobile/di/injection.config.dart';
import 'package:openapi/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/order_detail/order_detail_bloc.dart';
import '../cubit/dropdown_cubit/dropdown_cubit.dart';
import '../data/datasources/local/impl/search_local_datasource_impl.dart';
import '../data/datasources/local/search_local_datasource.dart';
import '../data/datasources/shared_preferences/shared_pref_manager.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/blindbox_repository.dart';
import '../data/repositories/implement/auth_repository_impl.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/shipping_info_repository.dart';
import '../data/repositories/sku_repository.dart';
import '../data/repositories/image_repository.dart';
import '../data/repositories/implement/sku_repository_imp.dart';
import '../data/repositories/implement/image_repository_impl.dart';
import '../data/repositories/voucher_repository.dart';

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
    getIt.registerSingleton<SharedPrefManager>(SharedPrefManager(sharedPreferences));
  }
}

void _registerRepositories() {
  // Register all repositories as LazySignleton
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  }
  
  if (!getIt.isRegistered<AccountRepository>()) {
    getIt.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl());
  }
  
  if (!getIt.isRegistered<BlindBoxRepository>()) {
    getIt.registerLazySingleton<BlindBoxRepository>(() => BlindBoxRepositoryImpl());
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
    getIt.registerLazySingleton<OrderDetailRepository>(() => OrderDetailRepositoryImpl());
  }

  if (!getIt.isRegistered<PromotionRepository>()) {
    getIt.registerLazySingleton<PromotionRepository>(() => PromotionRepositoryImpl());
  }

  if (!getIt.isRegistered<ShippingInfoRepository>()) {
    getIt.registerLazySingleton<ShippingInfoRepository>(() => ShippingInfoRepositoryImpl());
  }

  // Register VoucherRepository if it's not already registered
  if (!getIt.isRegistered<VoucherRepository>()) {
    getIt.registerLazySingleton<VoucherRepository>(() => VoucherRepositoryImpl());
  }
}

void _registerDataSources(SharedPrefManager sharedPrefManager) {
  if (!getIt.isRegistered<SearchLocalDatasource>()) {
    getIt.registerSingleton<SearchLocalDatasource>(SearchLocalDatasourceImpl(sharedPrefManager));
  }
}

void _registerAPI(Box box) {
  // API client
  if (!getIt.isRegistered<DefaultApi>()) {
    getIt.registerLazySingleton<DefaultApi>(() => DefaultApi(
      ApiClient(basePath: dotenv.env['BASE_URL'] ?? '')
        ..authentication?.applyToParams([], {
          "Authorization": "Bearer ${box.get('loginToken')}",
        })
    ));
  }
}

void _registerBlocs() {
  // Cubits (stateful singleton components)
  if (!getIt.isRegistered<CartCubit>()) {
    getIt.registerLazySingleton<CartCubit>(() => CartCubit());
  }
  
  if (!getIt.isRegistered<DropdownCubit>()) {
    getIt.registerFactory<DropdownCubit>(() => DropdownCubit(getIt<LocaleCubit>()));
  }
  
  // Singleton Blocs (long-lived Blocs)
  if (!getIt.isRegistered<SetBloc>()) {
    getIt.registerLazySingleton<SetBloc>(() => SetBloc(
      getIt<SetRepository>(),
      skuRepository: getIt<SkuRepository>(),
      imageRepository: getIt<ImageRepository>(),
    ));
  }
  
  if (!getIt.isRegistered<BrandBloc>()) {
    getIt.registerLazySingleton<BrandBloc>(() => BrandBloc(getIt<BrandRepository>()));
  }

  if (!getIt.isRegistered<PromotionBloc>()) {
    getIt.registerLazySingleton<PromotionBloc>(() => PromotionBloc(getIt<PromotionRepository>()));
  }
  
  if (!getIt.isRegistered<BlindBoxesBloc>()) {
    getIt.registerLazySingleton<BlindBoxesBloc>(() => BlindBoxesBloc(getIt<BlindBoxRepository>()));
  }
  
  if (!getIt.isRegistered<OrderDetailBloc>()) {
    getIt.registerLazySingleton<OrderDetailBloc>(() => OrderDetailBloc(
      orderDetailRepository: getIt<OrderDetailRepository>(),
    ));
  }

  if (!getIt.isRegistered<ShippingInfoBloc>()) {
    getIt.registerLazySingleton<ShippingInfoBloc>(() => ShippingInfoBloc(getIt<ShippingInfoRepository>()));
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
