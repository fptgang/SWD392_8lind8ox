import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/feature/order/blocs/video/video_bloc.dart';
import 'package:mobile/feature/order/widgets/video/video_upload_section.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:mobile/utils/utils.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderModel order;

  const OrderSummaryCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderId = order.orderId?.toString() ?? "N/A";
    final status = order.latestStatus ?? OrderStatusEnum.CREATED;
    final dateCreated = Utils.formatDateTime(order.createdAt);
    final itemCount = order.orderDetails?.length ?? 0;
    final totalAmount = order.finalTotal?.toStringAsFixed(2) ?? "0.00";
    final hasSlots = order.orderDetails?.any((detail) => detail.slot != null) ?? false;

    return Card(
      color: getColorSkin().white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #$orderId",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusChip(status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Placed on $dateCreated",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$itemCount Item${itemCount != 1 ? 's' : ''}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Total: \$$totalAmount",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (hasSlots) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showVideoUploadDialog(context),
                  icon: const Icon(Icons.videocam),
                  label: const Text('Upload Video Review'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().primaryRed650,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showVideoUploadDialog(BuildContext context) {
    final orderDetailsWithSlots = order.orderDetails?.where((detail) => detail.slot != null).toList() ?? [];
    
    if (orderDetailsWithSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items available for video upload'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => getIt<VideoBloc>(),
          child: Dialog(
            backgroundColor: getColorSkin().white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upload Video Review',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getColorSkin().darkGrey,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...orderDetailsWithSlots.map((detail) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                detail.sku?.blindBox?.name ?? 'Unknown Item',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: getColorSkin().primaryRed650,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: getColorSkin().primaryRed650,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  detail.sku?.blindBox?.images?.isNotEmpty == true
                                      ? detail.sku!.blindBox!.images!.first.imageUrl ?? ''
                                      : detail.sku?.image?.imageUrl ?? '',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 80,
                                      width: 80,
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: getColorSkin().primaryRed650,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        VideoUploadSection(
                          accountId: order.account?.accountId ?? 0,
                          slotId: detail.slot?.slotId,
                          orderDetailId: detail.orderDetailId,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(OrderStatusEnum status) {
    Color chipColor = Colors.blue.shade100;
    String statusText = "";

    switch (status) {
      case OrderStatusEnum.CREATED:
        chipColor = Colors.blue.shade100;
        statusText = "Pending";
        break;
      case OrderStatusEnum.PREPARING:
        chipColor = Colors.orange.shade100;
        statusText = "Processing";
        break;
      case OrderStatusEnum.SHIPPING:
        chipColor = Colors.purple.shade100;
        statusText = "Shipping";
        break;
      case OrderStatusEnum.DELIVERED:
        chipColor = Colors.green.shade100;
        statusText = "Delivered";
        break;
      case OrderStatusEnum.CANCELED:
        chipColor = Colors.red.shade100;
        statusText = "Cancelled";
        break;
      case OrderStatusEnum.PAYMENT_FAILED:
        chipColor = Colors.red.shade100;
        statusText = "Payment Failed";
        break;
      case OrderStatusEnum.PAYMENT_EXPIRED:
        chipColor = Colors.red.shade100;
        statusText = "Payment Expired";
        break;
      case OrderStatusEnum.READY_FOR_PICKUP:
        chipColor = Colors.amber.shade100;
        statusText = "Ready for Pickup";
        break;
      case OrderStatusEnum.RECEIVED:
        chipColor = Colors.teal.shade100;
        statusText = "Received";
        break;
      case OrderStatusEnum.COMPLETED:
        chipColor = Colors.green.shade100;
        statusText = "Completed";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: getColorSkin().black,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}