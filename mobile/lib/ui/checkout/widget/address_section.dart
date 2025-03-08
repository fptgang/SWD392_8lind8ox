import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/di/injection.dart';
import 'package:mobile/ui/core/theme/theme.dart';

import '../../../blocs/shipping_info/shipping_info_bloc.dart';
import '../../../blocs/shipping_info/shipping_info_event.dart';
import '../../../blocs/shipping_info/shipping_info_state.dart';

Widget buildAddressSection() {
  return BlocBuilder<ShippingInfoBloc, ShippingInfoState>(
    builder: (context, state) {
      if (state is ShippingInfoLoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ShippingInfoDataState) {
        final shippingInfo = state.shippingInfo;
        return Container(
          color: getColorSkin().backgroundColor,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.red[400]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${shippingInfo?.name} (${shippingInfo?.phoneNumber})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${shippingInfo?.address}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        );
      } else if (state is ShippingInfoLoadingState && state.error != null) {
        return Center(child: Text('Error: ${state.error}'));
      } else {
        return Container(
          color: getColorSkin().backgroundColor,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.red[400]),
              const SizedBox(width: 12),
              const Expanded(
                child: Text("No shipping address available. Please add one."),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        );
      }
    },
  );
}