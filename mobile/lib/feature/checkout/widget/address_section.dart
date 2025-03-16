import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_bloc.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_state.dart';
import 'package:mobile/feature/shipping_address/shipping_address_screen.dart';

Widget buildAddressSection() {
  return BlocBuilder<ShippingInfoBloc, ShippingInfoState>(
    builder: (context, state) {
      if (state is ShippingInfoDataState && state.shippingInfo != null) {
        final address = state.shippingInfos.firstWhere(
          (info) => info.isVisible == true,
          orElse: () => state.shippingInfos.first,
        );
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
                      _navigateToSelectAddress(context);
                    },
                    child: Text(
                      'Change',
                      style: TextStyle(
                        color: getColorSkin().primaryRed650,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildAddressCard(address),
            ],
          ),
        );
      } else {
        // Show empty state
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange[800]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'No shipping address available',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.orange[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please add or select a shipping address to continue with your order.',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToSelectAddress(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().primaryRed650,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Shipping Address',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}

void _navigateToSelectAddress(BuildContext context) {
  final shippingInfoBloc = context.read<ShippingInfoBloc>();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: shippingInfoBloc,
        child: ShippingAddressScreen(
          isSelectionMode: true,
          onAddressSelected: (ShippingInfoModel address) {
            // The selection is handled inside the ShippingInfoBloc
            // No need to do anything here, just force a rebuild
            if (context.mounted) {
              (context as Element).markNeedsBuild();
            }
          },
        ),
      ),
    ),
  );
}

Widget _buildAddressCard(ShippingInfoModel address) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: getColorSkin().lightGrey400),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              address.name ?? 'No Name',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Text('|'),
            const SizedBox(width: 8),
            Text(
              address.phoneNumber ?? 'No Phone',
              style: TextStyle(
                color: getColorSkin().darkGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _buildFullAddress(address),
          style: TextStyle(
            color: getColorSkin().darkGrey,
          ),
        ),
        if (address.isVisible == true) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: getColorSkin().primaryRed650),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Default',
              style: TextStyle(
                fontSize: 12,
                color: getColorSkin().primaryRed650,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

String _buildFullAddress(ShippingInfoModel address) {
  List<String> parts = [];

  if ((address.address ?? '').isNotEmpty) {
    parts.add(address.address!);
  }

  if ((address.ward ?? '').isNotEmpty) {
    parts.add(address.ward!);
  }

  if ((address.district ?? '').isNotEmpty) {
    parts.add(address.district!);
  }

  if ((address.city ?? '').isNotEmpty) {
    parts.add(address.city!);
  }

  return parts.join(', ');
}