import 'package:flutter/material.dart';
import 'package:mobile/enum/enum.dart';
import 'package:mobile/ui/account/order_tracking_screen.dart';
import 'package:mobile/ui/core/theme/theme.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MyOrdersScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: getColorSkin().primaryRed650,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            _buildOrderItem(
              context,
              orderId: "999012",
              date: "20-Dec-2019, 3:00 PM",
              status: OrderStatusEnum.PAYMENT_EXPIRED,
              estimatedDelivery: "31 Dec",
              productEmoji: "🥑",
              rating: 5,
              hasRated: false,
            ),
            const Divider(height: 1),
            _buildOrderItem(
              context,
              orderId: "660212",
              date: "18-Dec-2019, 1:00 PM",
              status: OrderStatusEnum.DELIVERED,
              deliveredDate: "18 Dec",
              productEmoji: "🍎",
              rating: 4,
              hasRated: true,
            ),
            const Divider(height: 1),
            _buildOrderItem(
              context,
              orderId: "551221",
              date: "16-Dec-2019, 3:00 PM",
              status: OrderStatusEnum.DELIVERED,
              deliveredDate: "17 Dec",
              productEmoji: "🍓",
              rating: 2,
              hasRated: true,
            ),
            const Divider(height: 1),
            _buildOrderItem(
              context,
              orderId: "448202",
              date: "12-Dec-2019, 3:00 PM",
              status: OrderStatusEnum.COMPLETED,
              deliveredDate: "13 Dec",
              productEmoji: "🥝",
              rating: 4,
              hasRated: true,
            ),
            const Divider(height: 1),
            _buildOrderItem(
              context,
              orderId: "425253",
              date: "10-Dec-2019, 3:00 PM",
              status: OrderStatusEnum.READY_FOR_PICKUP,
              deliveredDate: "11 Dec",
              productEmoji: "🥑",
              rating: 5,
              hasRated: true,
            ),
            const Divider(height: 1),
            _buildOrderItem(
              context,
              orderId: "335242",
              date: "08-Dec-2019, 2:00 PM",
              status: OrderStatusEnum.CANCELED,
              deliveredDate: "09 Dec",
              productEmoji: "🥑",
              rating: 4,
              hasRated: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(
      BuildContext context, {
        required String orderId,
        required String date,
        required OrderStatusEnum status,
        String? estimatedDelivery,
        String? deliveredDate,
        required String productEmoji,
        required int rating,
        required bool hasRated,
      }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(
              orderId: orderId, status: status,
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
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (status == OrderStatusEnum.PREPARING)
                    Text(
                      "Estimated Delivery on $estimatedDelivery",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    )
                  else
                    Text(
                      "Delivered on $deliveredDate",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  if (hasRated)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Text(
                            "You Rated: ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          _buildRatingStars(rating),
                        ],
                      ),
                    )
                  else if (status == OrderStatusEnum.PREPARING)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Text(
                            "Rating: ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          _buildRatingStars(rating, isInteractive: true),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              productEmoji,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(int rating, {bool isInteractive = false}) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 14,
        );
      }),
    );
  }
}

