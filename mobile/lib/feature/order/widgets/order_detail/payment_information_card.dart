import 'package:flutter/material.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/utils/enum/enum.dart';

class PaymentInformationCard extends StatelessWidget {
  final OrderModel order;

  const PaymentInformationCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final transaction = order.transaction;
    final paymentMethod = _getPaymentMethodText(transaction?.paymentMethod);
    final subTotal = order.subTotal ?? 0.0;
    final discount = order.voucher != null ? (order.voucher?.discountRate ?? 0.0) * subTotal / 100 : 0.0;
    final finalTotal = order.finalTotal ?? (subTotal - discount);

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
            "Payment Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.payment, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  paymentMethod,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.latestStatus),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getStatusText(order.latestStatus),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal"),
              Text("\$${subTotal.toStringAsFixed(2)}"),
            ],
          ),
          const SizedBox(height: 8),
          if (discount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Discount",
                    style: TextStyle(color: Colors.green),
                  ),
                  Text(
                    "-\$${discount.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${finalTotal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatusEnum? status) {
    if (status == null) return Colors.orange;

    switch (status) {
      case OrderStatusEnum.CREATED:
      case OrderStatusEnum.PREPARING:
        return Colors.orange;
      case OrderStatusEnum.PAYMENT_FAILED:
      case OrderStatusEnum.PAYMENT_EXPIRED:
      case OrderStatusEnum.CANCELED:
        return Colors.red;
      case OrderStatusEnum.READY_FOR_PICKUP:
      case OrderStatusEnum.SHIPPING:
        return Colors.blue;
      case OrderStatusEnum.DELIVERED:
      case OrderStatusEnum.RECEIVED:
      case OrderStatusEnum.COMPLETED:
        return Colors.green;
    }
  }

  String _getStatusText(OrderStatusEnum? status) {
    if (status == null) return "Pending";
    
    switch (status) {
      case OrderStatusEnum.CREATED:
        return 'Order Created';
      case OrderStatusEnum.PREPARING:
        return 'Preparing';
      case OrderStatusEnum.PAYMENT_FAILED:
        return 'Payment Failed';
      case OrderStatusEnum.PAYMENT_EXPIRED:
        return 'Payment Expired';
      case OrderStatusEnum.CANCELED:
        return 'Canceled';
      case OrderStatusEnum.READY_FOR_PICKUP:
        return 'Ready for Pickup';
      case OrderStatusEnum.SHIPPING:
        return 'Shipping';
      case OrderStatusEnum.DELIVERED:
        return 'Delivered';
      case OrderStatusEnum.RECEIVED:
        return 'Received';
      case OrderStatusEnum.COMPLETED:
        return 'Completed';
    }
  }

  String _getPaymentMethodText(PaymentMethod? paymentMethod) {
    if (paymentMethod == null) return "Standard Payment";
    
    switch (paymentMethod) {
      case PaymentMethod.PAYPAL:
        return 'PayPal';
      case PaymentMethod.VNPAY:
        return 'VNPay';
      case PaymentMethod.INTERNAL_WALLET:
        return 'Internal Wallet';
    }
  }
}