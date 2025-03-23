import 'package:flutter/material.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTimeline extends StatelessWidget {
  final OrderStatusEnum status;

  const OrderTimeline({
    Key? key,
    required this.status,
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
            _getRandomPastDate(days: 0),
            _isStatusCompleted(OrderStatusEnum.CREATED),
          ),
          _buildTimeline(
            OrderStatusEnum.PREPARING,
            "Processing",
            _getRandomPastDate(days: 1),
            _isStatusCompleted(OrderStatusEnum.PREPARING),
          ),
          _buildTimeline(
            OrderStatusEnum.SHIPPING,
            "Shipped",
            _getRandomPastDate(days: 2),
            _isStatusCompleted(OrderStatusEnum.SHIPPING),
          ),
          _buildTimeline(
            OrderStatusEnum.DELIVERED,
            "Delivered",
            _getRandomPastDate(days: 3),
            _isStatusCompleted(OrderStatusEnum.DELIVERED),
            isLast: true,
          ),
        ],
      ),
    );
  }

  bool _isStatusCompleted(OrderStatusEnum checkStatus) {
    final statusOrder = {
      OrderStatusEnum.CREATED: 0,
      OrderStatusEnum.PREPARING: 1,
      OrderStatusEnum.SHIPPING: 2,
      OrderStatusEnum.READY_FOR_PICKUP: 3,
      OrderStatusEnum.DELIVERED: 4,
      OrderStatusEnum.RECEIVED: 5,
      OrderStatusEnum.COMPLETED: 6,
    };

    final currentIndex = statusOrder[status] ?? 0;
    final checkIndex = statusOrder[checkStatus] ?? 999;

    return checkIndex <= currentIndex;
  }

  Widget _buildTimeline(
      OrderStatusEnum timelineStatus,
      String title,
      String date,
      bool isCompleted,
      {bool isLast = false}
      ) {
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

  String _getRandomPastDate({required int days}) {
    final today = DateTime.now();
    final date = today.subtract(Duration(days: days));

    final day = date.day.toString();
    final month = _getMonthName(date.month);

    return "$day $month";
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}