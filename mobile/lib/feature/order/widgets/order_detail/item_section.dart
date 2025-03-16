import 'package:flutter/material.dart';
import 'package:mobile/data/models/order_detail_model.dart';

class OrderItemsSection extends StatelessWidget {
  final List<OrderDetailModel> orderDetails;

  const OrderItemsSection({
    Key? key,
    required this.orderDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            "Items",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          if (orderDetails.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No items found"),
              ),
            )
          else
            ...List.generate(orderDetails.length, (index) {
              final detail = orderDetails[index];
              final name = detail.sku?.name ?? "Product";
              final price = '\$${(detail.unitPrice ?? 0.0).toStringAsFixed(2)}';
              final quantity = detail.quantity?.toString() ?? "1";

              return Column(
                children: [
                  _buildOrderItem(name, "$quantity item(s)", price, detail.sku?.image?.imageUrl ?? ""),
                  if (index < orderDetails.length - 1) const Divider(),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
      String name,
      String quantity,
      String price,
      String image,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.network(
                image,
                width: 30,
                height: 30,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  quantity,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}