import 'package:flutter/material.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  final OrderStatusEnum status;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
    required this.status,
  });

  static Route<void> route(String orderId, OrderStatusEnum status) {
    return MaterialPageRoute<void>(
        builder: (_) => OrderDetailScreen(orderId: orderId, status: status));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().backgroundColor,
      appBar: AppBar(
        title: Text("Order #$orderId",
            style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: getColorSkin().primaryRed650,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary Card
              _buildOrderSummaryCard(),

              const SizedBox(height: 24),

              // Order Timeline
              _buildOrderTimeline(),

              const SizedBox(height: 24),

              // Order Details Section
              _buildItemsSection(),

              const SizedBox(height: 24),

              // Delivery Information
              _buildDeliveryInformation(),

              const SizedBox(height: 24),

              // Payment Information
              _buildPaymentInformation(),

              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
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
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Placed on Dec 20, 2019 at 3:00 PM",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "3 Items",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Total: \$24.97",
                  style: TextStyle(
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

  Widget _buildStatusChip() {
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
          // color: chipColor.withBlue(255).withRed(0).withGreen(0),
          color: getColorSkin().black,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildOrderTimeline() {
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
            "Order Status",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimeline(
              OrderStatusEnum.CREATED,
              "Order Placed",
              "Dec 20, 2019",
              status == OrderStatusEnum.CREATED ||
                  status == OrderStatusEnum.PREPARING ||
                  status == OrderStatusEnum.SHIPPING ||
                  status == OrderStatusEnum.DELIVERED ||
                  status == OrderStatusEnum.RECEIVED ||
                  status == OrderStatusEnum.COMPLETED),
          _buildTimeline(
              OrderStatusEnum.PREPARING,
              "Processing",
              "Dec 21, 2019",
              status == OrderStatusEnum.PREPARING ||
                  status == OrderStatusEnum.SHIPPING ||
                  status == OrderStatusEnum.DELIVERED ||
                  status == OrderStatusEnum.RECEIVED ||
                  status == OrderStatusEnum.COMPLETED),
          _buildTimeline(
              OrderStatusEnum.SHIPPING,
              "Shipped",
              "Dec 22, 2019",
              status == OrderStatusEnum.SHIPPING ||
                  status == OrderStatusEnum.DELIVERED ||
                  status == OrderStatusEnum.RECEIVED ||
                  status == OrderStatusEnum.COMPLETED),
          _buildTimeline(
              OrderStatusEnum.DELIVERED,
              "Delivered",
              "Dec 31, 2019",
              status == OrderStatusEnum.DELIVERED ||
                  status == OrderStatusEnum.RECEIVED ||
                  status == OrderStatusEnum.COMPLETED,
              isLast: true),
        ],
      ),
    );
  }

  Widget _buildTimeline(OrderStatusEnum timelineStatus, String title,
      String date, bool isCompleted,
      {bool isLast = false}) {
    return SizedBox(
      height: 70,
      child: TimelineTile(
        alignment: TimelineAlign.start,
        isFirst: timelineStatus == OrderStatusEnum.CREATED,
        isLast: isLast,
        indicatorStyle: IndicatorStyle(
          width: 25,
          height: 25,
          indicator: Container(
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.grey.shade300,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: isCompleted
                ? const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                : null,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: isCompleted ? Colors.green : Colors.grey.shade300,
        ),
        afterLineStyle: LineStyle(
          color: status == timelineStatus || !isCompleted
              ? Colors.grey.shade300
              : Colors.green,
        ),
        endChild: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  color: isCompleted ? Colors.black87 : Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemsSection() {
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
          _buildOrderItem("Organic Avocado", "1 kg", "\$8.99", "🥑"),
          const Divider(),
          _buildOrderItem("Fresh Apples", "2 kg", "\$5.99", "🍎"),
          const Divider(),
          _buildOrderItem("Strawberries", "500g", "\$9.99", "🍓"),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
      String name, String quantity, String price, String emoji) {
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
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
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

  Widget _buildDeliveryInformation() {
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
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shipping Address",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "123 Main Street, Apt 4B\nNew York, NY 10001",
                      style: TextStyle(
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
                          "Express Delivery",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          status == OrderStatusEnum.DELIVERED
                              ? "Delivered"
                              : "Est. Delivery Dec 31",
                          style: TextStyle(
                            color: status == OrderStatusEnum.DELIVERED
                                ? Colors.green
                                : Colors.blue,
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

  Widget _buildPaymentInformation() {
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
          const Row(
            children: [
              Icon(Icons.credit_card, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Credit Card ending in 1234",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal"),
              Text("\$24.97"),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Shipping"),
              Text("\$4.99"),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tax"),
              Text("\$2.50"),
            ],
          ),
          const Divider(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$32.46",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Update _buildActionButtons method to reflect the new enum cases
  Widget _buildActionButtons(BuildContext context) {
    switch (status) {
      case OrderStatusEnum.DELIVERED:
      case OrderStatusEnum.RECEIVED:
      case OrderStatusEnum.COMPLETED:
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _buildRatingDialog(context),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Rate Products"),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                // Handle reorder
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Reorder"),
            ),
          ],
        );
      case OrderStatusEnum.CANCELED:
        return OutlinedButton(
          onPressed: () {
            // Handle reorder
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Order Again"),
        );
      default: // For CREATED, PREPARING, SHIPPING, etc.
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle tracking
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Track Delivery"),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _buildCancelDialog(context),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Cancel Order"),
            ),
          ],
        );
    }
  }
}

Widget _buildRatingDialog(BuildContext context) {
  return AlertDialog(
    title: const Text("Rate Your Order"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("How was your experience with this order?"),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: const Icon(Icons.star_outline),
              color: Colors.amber,
              iconSize: 30,
              onPressed: () {
                // Handle rating
                Navigator.pop(context);
              },
            );
          }),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel"),
      ),
    ],
  );
}

Widget _buildCancelDialog(BuildContext context) {
  return AlertDialog(
    title: const Text("Cancel Order"),
    content: const Text(
        "Are you sure you want to cancel this order? This action cannot be undone."),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("No"),
      ),
      TextButton(
        onPressed: () {
          // Handle order cancellation
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
        ),
        child: const Text("Yes, Cancel"),
      ),
    ],
  );
}
