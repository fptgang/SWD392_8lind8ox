import 'package:flutter/material.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/feature/order/screens/order_detail_screen.dart';
import 'package:mobile/utils/enum/enum.dart';

import '../../../../utils/utils.dart';

class OrderListItem extends StatelessWidget {
  final OrderModel order;

  const OrderListItem({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final orderId = order.orderId?.toString() ?? "N/A";
    final dateCreated = order.createdAt != null 
        ? Utils.formatDateTime(order.createdAt!)
        : "Date not available";
    final status = order.latestStatus ?? OrderStatusEnum.CREATED;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(
              orderId: orderId,
              status: status,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Order#: $orderId",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (order.orderDetails != null && order.orderDetails!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          "(${order.orderDetails!.length} items)",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateCreated,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDeliveryInfo(status, order),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildProductIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo(OrderStatusEnum status, OrderModel order) {
    final DateTime? dateToUse = order.updatedAt ?? order.createdAt;
    final String formattedDate = dateToUse != null 
        ? Utils.formatShortDate(dateToUse)
        : "Date not available";

    if (status == OrderStatusEnum.PREPARING || status == OrderStatusEnum.CREATED) {
      final estimatedDate = order.createdAt != null
          ? Utils.calculateEstimatedDelivery(order.createdAt!)
          : "Date not available";
      return Text(
        "Estimated Delivery on $estimatedDate",
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      );
    } else if (status == OrderStatusEnum.DELIVERED ||
        status == OrderStatusEnum.RECEIVED ||
        status == OrderStatusEnum.COMPLETED) {
      return Text(
        "Delivered on $formattedDate",
        style: const TextStyle(
          color: Colors.green,
          fontSize: 12,
        ),
      );
    } else if (status == OrderStatusEnum.CANCELED) {
      return Text(
        "Canceled on $formattedDate",
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      );
    } else if (status == OrderStatusEnum.PAYMENT_EXPIRED){
      return Text(
        "Payment Expired",
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      );
    }
    else {
      return Text(
        "Status: $status",
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 12,
        ),
      );
    }
  }

  Widget _buildProductIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          '📦',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}