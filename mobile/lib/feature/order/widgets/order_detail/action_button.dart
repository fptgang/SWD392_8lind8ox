import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/feature/order/blocs/video/video_bloc.dart';
import 'package:mobile/feature/order/widgets/video/video_upload_section.dart';
import 'package:mobile/utils/enum/enum.dart';

class ActionButtons extends StatelessWidget {
  final OrderStatusEnum status;
  final String orderId;

  const ActionButtons({
    super.key,
    required this.status,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (status == OrderStatusEnum.COMPLETED)
          ElevatedButton(
            onPressed: () {
              // Handle order completion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: getColorSkin().primaryRed650,
              foregroundColor: Colors.white,
            ),
            child: const Text('Order Completed'),
          ),
      ],
    );
  }
}

class CancellationDialog {
}