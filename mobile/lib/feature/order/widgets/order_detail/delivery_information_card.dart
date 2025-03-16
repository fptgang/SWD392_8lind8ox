import 'package:flutter/material.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:mobile/utils/utils.dart';

class DeliveryInformationCard extends StatelessWidget {
  final OrderModel order;

  const DeliveryInformationCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final status = order.latestStatus ?? OrderStatusEnum.CREATED;
    final shippingInfo = order.shippingInfo;
    final address = shippingInfo != null
        ? "${shippingInfo.address ?? ''}\n${shippingInfo.ward ?? ''}, ${shippingInfo.district ?? ''}\n${shippingInfo.city ?? ''}"
        : "No address information";
    final name = shippingInfo?.name ?? "N/A";
    final phoneNumber = shippingInfo?.phoneNumber ?? "N/A";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Delivery Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person_outline, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recipient",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$name | $phoneNumber",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Shipping Address",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.local_shipping_outlined,
                  color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Method",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Standard Delivery",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          _getDeliveryStatus(status),
                          style: TextStyle(
                            color: _getDeliveryStatusColor(status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDeliveryStatus(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.DELIVERED:
      case OrderStatusEnum.RECEIVED:
      case OrderStatusEnum.COMPLETED:
        return "Delivered";
      case OrderStatusEnum.SHIPPING:
        return "In Transit";
      case OrderStatusEnum.READY_FOR_PICKUP:
        return "Ready for Pickup";
      case OrderStatusEnum.CANCELED:
        return "Canceled";
      case OrderStatusEnum.PAYMENT_FAILED:
      case OrderStatusEnum.PAYMENT_EXPIRED:
        return "Payment Issue";
      default:
        final estimatedDate = _getEstimatedDeliveryDate();
        return "Est. Delivery $estimatedDate";
    }
  }

  Color _getDeliveryStatusColor(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.DELIVERED:
      case OrderStatusEnum.RECEIVED:
      case OrderStatusEnum.COMPLETED:
        return Colors.green;
      case OrderStatusEnum.SHIPPING:
      case OrderStatusEnum.READY_FOR_PICKUP:
        return Colors.blue;
      case OrderStatusEnum.CANCELED:
      case OrderStatusEnum.PAYMENT_FAILED:
      case OrderStatusEnum.PAYMENT_EXPIRED:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getEstimatedDeliveryDate() {
    final orderDate = order.createdAt as DateTime?;
    if (orderDate == null) return "Unknown";

    // Add 7 days for delivery
    final estimatedDate = orderDate.add(const Duration(days: 7));
    final day = estimatedDate.day.toString();
    final month = Utils.getMonthAbbreviation(estimatedDate.month);

    return "$day $month";
  }
}