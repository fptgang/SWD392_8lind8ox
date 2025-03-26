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
  bool hasInitialized = false;

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.isSelectionMode ? 'Chọn địa chỉ giao hàng' : 'Địa chỉ của tôi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // Check if we can safely pop
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // Fallback to routing to main screen
              AppRouter.router.go('/main');
            }
          },
        ),
        actions: widget.isSelectionMode
            ? [
                // Add a Done button in selection mode
                TextButton(
                  onPressed: () {
                    _selectAddressAndReturn();
                  },
                  child: Text(
                    'Xong',
                    style: TextStyle(
                      color: getColorSkin().primaryRed650,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: BlocConsumer<ShippingInfoBloc, ShippingInfoState>(
        listener: (context, state) {
          // Listen for errors
          if (state is ShippingInfoLoadingState && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ShippingInfoLoadingState && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ShippingInfoLoadingState && state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ShippingInfoBloc>().add(GetShippingInfos());
                    },
                    child: const Text('Retry'),
                  ),
                ],
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
                      // Use navigate instead of push to avoid stacking multiple screens
                      if (Navigator.of(context).canPop()) {
                        AppRouter.router.push('/shipping-address-form');
                      } else {
                        AppRouter.router.go('/shipping-address-form');
                      }
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
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.shippingInfos.length,
              separatorBuilder: (context, index) => Divider(
                color: getColorSkin().lightGrey200,
                height: 16.h,
              ),
              itemBuilder: (context, index) {
                final address = state.shippingInfos[index];
                final isSelected = widget.isSelectionMode &&
                    state.selectedShippingInfo != null &&
                    state.selectedShippingInfo!.shippingInfoId ==
                        address.shippingInfoId;

                return widget.isSelectionMode
                    ? _buildSelectableAddressCard(
                        context, address, isSelected, state)
                    : _buildManageableAddressCard(context, address);
              },
            );
          }

          // Fallback
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Use navigate instead of push to avoid stacking multiple screens
          if (Navigator.of(context).canPop()) {
            AppRouter.router.push('/shipping-address-form');
          } else {
            AppRouter.router.go('/shipping-address-form');
          }
        },
        backgroundColor: getColorSkin().primaryRed650,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: widget.isSelectionMode ? _buildBottomBar() : null,
    );
  }

  // Function to handle address selection and return
  void _selectAddressAndReturn() {
    final state = context.read<ShippingInfoBloc>().state;
    if (state is ShippingInfoDataState && state.selectedShippingInfo != null) {
      // Make sure we only call the callback once
      if (widget.onAddressSelected != null) {
        // Use try-catch to handle the "Future already completed" error
        try {
          widget.onAddressSelected!(state.selectedShippingInfo!);
        } catch (e) {
          debugPrint('Error calling onAddressSelected: $e');
        }
      }

      // Check if we can safely pop
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        // Fallback to routing to main screen
        AppRouter.router.go('/main');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn một địa chỉ'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSelectableAddressCard(BuildContext context,
      ShippingInfoModel address, bool isSelected, ShippingInfoDataState state) {
    return InkWell(
      onTap: () {
        context.read<ShippingInfoBloc>().add(SelectShippingInfo(address));
      },
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(
            color: isSelected
                ? getColorSkin().primaryRed650
                : getColorSkin().lightGrey200,
            width: isSelected ? 2.w : 1.w,
          ),
        ),
        margin: EdgeInsets.only(bottom: 8.h),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : false,
                onChanged: (_) {
                  context
                      .read<ShippingInfoBloc>()
                      .add(SelectShippingInfo(address));
                },
                activeColor: getColorSkin().primaryRed650,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            address.name ?? 'No Name',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '|',
                          style: TextStyle(color: getColorSkin().grey),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            address.phoneNumber ?? 'No Phone',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: getColorSkin().darkGrey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      address.address ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: getColorSkin().darkGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${address.ward ?? ''}, ${address.district ?? ''}, ${address.city ?? ''}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: getColorSkin().darkGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 8.h),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManageableAddressCard(
      BuildContext context, ShippingInfoModel address) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: BorderSide(
          color: getColorSkin().lightGrey200,
          width: 1.w,
        ),
      ),
      margin: EdgeInsets.only(bottom: 8.h),
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
                    // Show a confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Xóa địa chỉ'),
                          content: const Text(
                              'Bạn có chắc chắn muốn xóa địa chỉ này?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Hủy',
                                style: TextStyle(color: getColorSkin().grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<ShippingInfoBloc>().add(
                                      DeleteShippingInfo(
                                          address.shippingInfoId!),
                                    );
                              },
                              child: Text(
                                'Xóa',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
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
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          _selectAddressAndReturn();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: getColorSkin().primaryRed650,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          'Xác nhận',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
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
