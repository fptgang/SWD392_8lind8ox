import 'package:flutter/material.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/order_model.dart';
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
          ],
        ),
      ),
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