import 'package:flutter/material.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_bloc.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_event.dart';

Widget buildAddressSection(ShippingInfoModel shippingInfo) {
  return Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(16),
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Use the existing AppRouter.router instance
                AppRouter.router.go('/shipping-address', extra: {
                  'isSelectionMode': true,
                  'onAddressSelected': (ShippingInfoModel address) {
                    getIt<ShippingInfoBloc>().add(SelectShippingInfo(address));
                  },
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: getColorSkin().primaryRed650,
              ),
              child: const Text('Change'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildAddressInfo(shippingInfo),
      ],
    ),
  );
}


Widget _buildAddressInfo(ShippingInfoModel address) {
  final fullAddress = _buildFullAddressString(address);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "${address.name ?? 'No Name'} | ${address.phoneNumber ?? 'No Phone'}",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 4),
      Text(
        fullAddress,
        style: TextStyle(color: Colors.grey[600]),
      ),
      Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: getColorSkin().primaryRed100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Default',
          style: TextStyle(
            color: getColorSkin().primaryRed650,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

String _buildFullAddressString(ShippingInfoModel address) {
  final components = <String>[];

  if (address.address != null && address.address!.isNotEmpty) {
    components.add(address.address!);
  }
  if (address.ward != null && address.ward!.isNotEmpty) {
    components.add(address.ward!);
  }
  if (address.district != null && address.district!.isNotEmpty) {
    components.add(address.district!);
  }
  if (address.city != null && address.city!.isNotEmpty) {
    components.add(address.city!);
  }

  return components.join(', ');
}

Widget buildAddAddressButton(ShippingInfoBloc shippingInfoBloc) {
  return Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(16),
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Address',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _navigateToSelectAddress(shippingInfoBloc),
          style: ElevatedButton.styleFrom(
            backgroundColor: getColorSkin().primaryRed650,
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text(
            'Add Shipping Address',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

void _navigateToSelectAddress(ShippingInfoBloc shippingInfoBloc) {
  AppRouter.router.go('/shipping-address', extra: {
    'isSelectionMode': true,
    'onAddressSelected': (ShippingInfoModel address) {
      shippingInfoBloc.add(SelectShippingInfo(address));
    },
  });
}
