import 'package:flutter/material.dart';
import 'package:mobile/data/models/order_model.dart';

class PaymentInformationCard extends StatelessWidget {
  final OrderModel order;

  const PaymentInformationCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final transaction = order.transaction;
    final paymentMethod = transaction?.paymentMethod?.toString() ?? "Standard Payment";
    final subTotal = order.subTotal ?? 0.0;
    final shipping = 4.99; // Default shipping cost
    final tax = (subTotal * 0.1).toDouble(); // Assume 10% tax
    final discount = order.voucher != null ? (order.voucher?.discountRate ?? 0.0) * subTotal / 100 : 0.0;
    final finalTotal = order.finalTotal ?? (subTotal + shipping + tax - discount);

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
                  color: _getStatusColor(transaction?.status),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaction?.status.toString() ?? "Pending",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Shipping"),
              Text("\$${shipping.toStringAsFixed(2)}"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tax"),
              Text("\$${tax.toStringAsFixed(2)}"),
            ],
          ),
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

  Color _getStatusColor(dynamic status) {
    if (status == null) return Colors.orange;
    final statusStr = status.toString().toLowerCase();

    if (statusStr.contains('success')) return Colors.green;
    if (statusStr.contains('fail')) return Colors.red;
    return Colors.orange; // PENDING
  }
}