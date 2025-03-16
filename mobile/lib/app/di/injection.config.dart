// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../base/common/blocs/sku/sku_bloc.dart' as _i1049;
import '../../data/datasources/local/impl/search_local_datasource_impl.dart'
    as _i41;
import '../../data/datasources/local/search_local_datasource.dart' as _i449;
import '../../data/datasources/shared_preferences/shared_pref_manager.dart'
    as _i336;
import '../../data/repositories/account_repository.dart' as _i283;
import '../../data/repositories/auth_repository.dart' as _i481;
import '../../data/repositories/blindbox_campaign_repository.dart' as _i232;
import '../../data/repositories/blindbox_repository.dart' as _i347;
import '../../data/repositories/image_repository.dart' as _i398;
import '../../data/repositories/order_detail_repository.dart' as _i84;
import '../../data/repositories/order_repository.dart' as _i893;
import '../../data/repositories/promotion_repository.dart' as _i599;
import '../../data/repositories/set_repository.dart' as _i232;
import '../../data/repositories/shipping_info_repository.dart' as _i365;
import '../../data/repositories/sku_repository.dart' as _i640;
import '../../data/repositories/voucher_repository.dart' as _i5;
import '../../data/services/token_refresh_service.dart' as _i285;
import '../../data/services/token_service.dart' as _i315;
import '../../feature/auth/login/blocs/login_bloc.dart' as _i112;
import '../../feature/cart/cubits/cart_cubit.dart' as _i1002;
import '../../feature/checkout/blocs/checkout_bloc.dart' as _i219;
import '../../feature/checkout/blocs/shipping_info/shipping_info_bloc.dart'
    as _i225;
import '../../feature/checkout/blocs/voucher/voucher_bloc.dart' as _i456;
import '../../feature/detail/blocs/blindbox_detail_bloc.dart' as _i267;
import '../../feature/home/blocs/blindbox_list/blindbox_list_bloc.dart'
    as _i167;
import '../../feature/home/blocs/promotion/promotion_bloc.dart' as _i886;
import '../../feature/home/blocs/set/set_bloc.dart' as _i183;
import '../../feature/order/blocs/order/order_bloc.dart' as _i1070;
import '../../feature/order/blocs/order_detail/order_detail_bloc.dart' as _i337;
import '../../feature/search/blocs/search_bloc.dart' as _i362;
import '../../feature/shipping_address/bloc/shipping_info_bloc.dart' as _i933;
import '../blocs/authentication/authentication_bloc.dart' as _i598;
import '../blocs/cart/cart_global_bloc.dart' as _i801;
import '../cubits/locale_cubit.dart' as _i867;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i1002.CartCubit>(() => _i1002.CartCubit());
    gh.singleton<_i867.LocaleCubit>(() => _i867.LocaleCubit());
    gh.factory<_i1049.StockKeepingUnitsBloc>(() => _i1049.StockKeepingUnitsBloc(
          gh<_i640.SkuRepository>(),
          gh<_i398.ImageRepository>(),
        ));
    gh.factory<_i1070.OrderBloc>(
        () => _i1070.OrderBloc(gh<_i893.OrderRepository>()));
    gh.factory<_i112.LoginBloc>(
        () => _i112.LoginBloc(authRepository: gh<_i481.AuthRepository>()));
    gh.factory<_i225.ShippingInfoBloc>(
        () => _i225.ShippingInfoBloc(gh<_i365.ShippingInfoRepository>()));
    gh.factory<_i933.ShippingInfoBloc>(
        () => _i933.ShippingInfoBloc(gh<_i365.ShippingInfoRepository>()));
    gh.factory<_i456.VoucherBloc>(
        () => _i456.VoucherBloc(gh<_i5.VoucherRepository>()));
    gh.factory<_i267.BlindBoxDetailBloc>(() => _i267.BlindBoxDetailBloc(
          blindBoxRepository: gh<_i347.BlindBoxRepository>(),
          skuRepository: gh<_i640.SkuRepository>(),
          imageRepository: gh<_i398.ImageRepository>(),
          blindBoxCampaignRepository: gh<_i232.BlindBoxCampaignRepository>(),
        ));
    gh.factory<_i801.CartGlobalBloc>(() => _i801.CartGlobalBloc(
          gh<_i893.OrderRepository>(),
          gh<_i640.SkuRepository>(),
        ));
    gh.factory<_i167.BlindBoxesListBloc>(
        () => _i167.BlindBoxesListBloc(gh<_i347.BlindBoxRepository>()));
    gh.factory<_i183.SetBloc>(() => _i183.SetBloc(
          gh<_i232.SetRepository>(),
          skuRepository: gh<_i640.SkuRepository>(),
          imageRepository: gh<_i398.ImageRepository>(),
        ));
    gh.factory<_i219.CheckoutBloc>(() => _i219.CheckoutBloc(
          gh<_i5.VoucherRepository>(),
          orderRepository: gh<_i893.OrderRepository>(),
        ));
    gh.factory<_i886.PromotionBloc>(
        () => _i886.PromotionBloc(gh<_i599.PromotionRepository>()));
    gh.lazySingleton<_i315.TokenService>(
        () => _i315.TokenService(box: gh<_i986.Box<dynamic>>()));
    gh.factory<_i337.OrderDetailBloc>(() => _i337.OrderDetailBloc(
        orderDetailRepository: gh<_i84.OrderDetailRepository>()));
    gh.factory<_i598.AuthenticationBloc>(() => _i598.AuthenticationBloc(
          authenticationRepository: gh<_i481.AuthRepository>(),
          userRepository: gh<_i283.AccountRepository>(),
        ));
    gh.singleton<_i336.SharedPrefManager>(
        () => _i336.SharedPrefManager(gh<_i460.SharedPreferences>()));
    gh.singleton<_i449.SearchLocalDatasource>(
        () => _i41.SearchLocalDatasourceImpl(gh<_i336.SharedPrefManager>()));
    gh.lazySingleton<_i285.TokenRefreshService>(() => _i285.TokenRefreshService(
          tokenService: gh<_i315.TokenService>(),
          dio: gh<_i361.Dio>(),
        ));
    gh.factory<_i362.SearchBloc>(() => _i362.SearchBloc(
          gh<_i347.BlindBoxRepository>(),
          gh<_i449.SearchLocalDatasource>(),
        ));
    return this;
  }
}
