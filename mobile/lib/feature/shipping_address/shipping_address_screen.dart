import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/common/widgets/common_loading.dart';
import 'package:mobile/base/common/widgets/error.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_bloc.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_event.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_state.dart';
import 'package:mobile/feature/shipping_address/shipping_address_form_screen.dart';
import 'package:mobile/feature/shipping_address/widgets/address_card.dart';
import 'package:mobile/feature/shipping_address/widgets/empty_address_view.dart';
import 'package:provider/provider.dart';

class ShippingAddressScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final shippingInfoBloc = context.read<ShippingInfoBloc>();

    if (shippingInfoBloc.state is! ShippingInfoDataState ||
        (shippingInfoBloc.state is ShippingInfoDataState &&
            !(shippingInfoBloc.state as ShippingInfoDataState)
                .hasShippingInfos)) {
      shippingInfoBloc.add(GetShippingInfos());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSelectionMode
              ? 'Chọn địa chỉ nhận hàng'
              : 'Địa chỉ giao hàng',
          style: TextStyle(
            color: getColorSkin().white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: getColorSkin().primaryRed650,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ShippingInfoBloc, ShippingInfoState>(
        builder: (context, state) {
          if (state is ShippingInfoLoadingState && state.isLoading) {
            return buildLoadingIndicator();
          }

          if (state is ShippingInfoLoadingState && state.error != null) {
            return CommonErrorWidget(
              error: state.error ?? 'An error occurred',
              onRetry: () =>
                  context.read<ShippingInfoBloc>().add(GetShippingInfos()),
            );
          }

          if (state is ShippingInfoDataState) {
            final addresses = state.shippingInfos;

            if (addresses.isEmpty) {
              return EmptyAddressView(onAddNew: () =>
                  _navigateToAddAddress(context, shippingInfoBloc));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: addresses.length,
                    separatorBuilder: (context, index) =>
                    const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final isDefault = address.isVisible ?? false;

                      return AddressCard(
                        address: address,
                        isDefault: isDefault,
                        isSelected: state.selectedShippingInfo
                            ?.shippingInfoId == address.shippingInfoId,
                        isSelectionMode: isSelectionMode,
                        onSelect: isSelectionMode
                            ? () =>
                            context.read<ShippingInfoBloc>().add(
                                SelectShippingInfo(address))
                            : null,
                        onEdit: () =>
                            _navigateToEditAddress(
                                context, address, shippingInfoBloc),
                      );
                    },
                  ),
                ),
                if (isSelectionMode)
                  _buildConfirmButton(context, state),
              ],
            );
          }

          return buildLoadingIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddAddress(context, shippingInfoBloc),
        backgroundColor: getColorSkin().primaryRed650,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context,
      ShippingInfoDataState state) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: state.selectedShippingInfo != null
              ? () {
            if (onAddressSelected != null) {
              onAddressSelected!(state.selectedShippingInfo!);
            }
            Navigator.pop(context);
          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: getColorSkin().primaryRed650,
            disabledBackgroundColor: getColorSkin().grey.withOpacity(0.3),
            padding: EdgeInsets.symmetric(vertical: 15.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'HOÀN THÀNH',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context,
      ShippingInfoBloc shippingInfoBloc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BlocProvider.value(
              value: shippingInfoBloc,
              child: const ShippingAddressFormScreen(),
            ),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<ShippingInfoBloc>().add(GetShippingInfos());
      }
    });
  }

  void _navigateToEditAddress(BuildContext context, ShippingInfoModel address,
      ShippingInfoBloc shippingInfoBloc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BlocProvider.value(
              value: shippingInfoBloc,
              child: ShippingAddressFormScreen(
                address: address,
              ),
            ),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<ShippingInfoBloc>().add(GetShippingInfos());
      }
    });
  }
}