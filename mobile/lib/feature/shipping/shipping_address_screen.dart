import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/base/common/widgets/common_loading.dart';
import 'package:mobile/base/common/widgets/error.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/map_repository.dart';
import 'package:mobile/feature/shipping/blocs/map/map_bloc.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_bloc.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_event.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_state.dart';
import 'package:mobile/feature/shipping/shipping_address_form_screen.dart';
import 'package:mobile/feature/shipping/widgets/address_card.dart';
import 'package:mobile/feature/shipping/widgets/empty_address_view.dart';
import 'package:provider/provider.dart';

class ShippingAddressScreen extends StatefulWidget {
  final bool isSelectionMode;
  final Function(ShippingInfoModel)? onAddressSelected;
  
  static Route<void> route() {
    return MaterialPageRoute<void>(
        builder: (_) => const ShippingAddressScreen());
  }

  const ShippingAddressScreen({
    super.key,
    this.isSelectionMode = false,
    this.onAddressSelected,
  });

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final navigatingKey = GlobalKey<_NavigationTrackerState>();
  bool hasInitialized = false;
  bool isAddressFormOpened = false;
  
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeShippingInfo();
    });
  }
  
  void _initializeShippingInfo() {
    if (!mounted) return;
    
    final shippingInfoBloc = context.read<ShippingInfoBloc>();
    
    if (shippingInfoBloc.state is! ShippingInfoDataState ||
        (shippingInfoBloc.state is ShippingInfoDataState &&
            !(shippingInfoBloc.state as ShippingInfoDataState)
                .hasShippingInfos)) {
      shippingInfoBloc.add(GetShippingInfos());
    } else if (widget.isSelectionMode &&
        shippingInfoBloc.state is ShippingInfoDataState &&
        (shippingInfoBloc.state as ShippingInfoDataState)
                .selectedShippingInfo ==
            null &&
        (shippingInfoBloc.state as ShippingInfoDataState).hasShippingInfos) {
      final dataState = shippingInfoBloc.state as ShippingInfoDataState;

      final defaultAddress = dataState.shippingInfos.firstWhere(
        (info) => info.isVisible == true,
        orElse: () => dataState.shippingInfos.first,
      );

      shippingInfoBloc.add(SelectShippingInfo(defaultAddress));
    }
    
    setState(() {
      hasInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MapBloc(mapRepository: getIt<MapRepository>()),
        ),
        BlocProvider(
          create: (context) => getIt<ShippingInfoBloc>()..add(GetShippingInfos()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Địa chỉ của tôi',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => AppRouter.router.pop(),
          ),
        ),
        body: BlocBuilder<ShippingInfoBloc, ShippingInfoState>(
          builder: (context, state) {
            if (state is ShippingInfoLoadingState && state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ShippingInfoLoadingState && state.error != null) {
              return Center(
                child: Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is ShippingInfoDataState && state.shippingInfos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(
                      'Bạn chưa có địa chỉ nào',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: getColorSkin().darkGrey,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        AppRouter.router.push('/shipping-address-form');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getColorSkin().primaryRed650,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Thêm địa chỉ mới',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is ShippingInfoDataState) {
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.shippingInfos.length,
                itemBuilder: (context, index) {
                  final address = state.shippingInfos[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: BorderSide(
                        color: getColorSkin().white,
                        width: 1.w,
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 16.h),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                address.name ?? 'No Name',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (address.isVisible == true)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getColorSkin().primaryRed650.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    'Mặc định',
                                    style: TextStyle(
                                      color: getColorSkin().primaryRed650,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            address.phoneNumber ?? 'No Phone',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: getColorSkin().darkGrey,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${address.address ?? ''}, ${address.ward ?? ''}, ${address.district ?? ''}, ${address.city ?? ''}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: getColorSkin().darkGrey,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  AppRouter.router.push(
                                    '/shipping-address-form',
                                    extra: address,
                                  );
                                },
                                child: Text(
                                  'Chỉnh sửa',
                                  style: TextStyle(
                                    color: getColorSkin().primaryRed650,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<ShippingInfoBloc>().add(
                                    DeleteShippingInfo(address.shippingInfoId!),
                                  );
                                },
                                child: Text(
                                  'Xóa',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            
            // Fallback
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppRouter.router.push('/shipping-address-form');
          },
          backgroundColor: getColorSkin().primaryRed650,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _NavigationTracker extends StatefulWidget {
  final Widget child;
  
  const _NavigationTracker({
    required this.child,
    super.key,
  });
  
  @override
  _NavigationTrackerState createState() => _NavigationTrackerState();
}

class _NavigationTrackerState extends State<_NavigationTracker> {
  bool isNavigating = false;
  
  void startNavigating() {
    setState(() {
      isNavigating = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
