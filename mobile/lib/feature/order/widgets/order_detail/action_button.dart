import 'package:flutter/material.dart';
import 'package:mobile/utils/enum/enum.dart';

class ActionButtons extends StatelessWidget {
  final OrderStatusEnum status;
  final String orderId;

  const ActionButtons({
    super.key,
    required this.status,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case OrderStatusEnum.DELIVERED:
      case OrderStatusEnum.RECEIVED:
      case OrderStatusEnum.COMPLETED:
        return _buildCompletedButtons(context);
      case OrderStatusEnum.CANCELED:
      case OrderStatusEnum.PAYMENT_FAILED:
      case OrderStatusEnum.PAYMENT_EXPIRED:
        return _buildCanceledButtons(context);
      default: // For CREATED, PREPARING, SHIPPING, etc.
        return _buildActiveButtons(context);
    }
  }

  Widget _buildCompletedButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          // onPressed: () => showDialog(
          //   context: context,
          //   builder: (context) => RatingDialog(),
          // ),
          onPressed: (){},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Upload Video Review"),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _handleReorder(context),
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
  }

  Widget _buildCanceledButtons(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _handleReorder(context),
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
  }

  Widget _buildActiveButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: (){},
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
          onPressed: (){},
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

  void _handleReorder(BuildContext context) {
    // In a real app, this would recreate the order
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reordering items...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class CancellationDialog {
}