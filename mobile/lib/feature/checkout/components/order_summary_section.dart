import 'package:flutter/material.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({
    super.key,
    required this.subtotal,
    this.voucherDiscount = 0.0,
    required this.finalTotal,
    required this.isProcessingOrder,
    required this.canPlaceOrder,
    required this.onPlaceOrder,
    this.savings = 0.0,
  });

  final double subtotal;
  final double voucherDiscount;
  final double finalTotal;
  final double savings;
  final bool isProcessingOrder;
  final bool canPlaceOrder;
  final Function() onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            _buildSummaryRow(
              context,
              label: 'Subtotal',
              value: subtotal,
            ),
            if (savings > 0) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                context,
                label: 'Savings',
                value: -savings,
                isHighlighted: true,
                textColor: Colors.green[700],
              ),
            ],
            if (voucherDiscount > 0) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                context,
                label: 'Voucher Discount',
                value: -voucherDiscount,
                isHighlighted: true,
                textColor: Colors.green[700],
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(),
            ),
            _buildSummaryRow(
              context,
              label: 'Total',
              value: finalTotal,
              isTotal: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    canPlaceOrder && !isProcessingOrder ? onPlaceOrder : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[600],
                ),
                child: isProcessingOrder
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Processing...',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      )
                    : Text(
                        'Place Order',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            if (!canPlaceOrder)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber[800],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please select a shipping address to continue',
                        style: TextStyle(
                          color: Colors.amber[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                // In a real app, navigate to cart
                // GoRouter.of(context).go('/cart');
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Return to Cart'),
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required double value,
    bool isHighlighted = false,
    Color? textColor,
    bool isTotal = false,
  }) {
    final style = isTotal
        ? Theme.of(context).textTheme.titleLarge
        : isHighlighted
            ? Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                )
            : Theme.of(context).textTheme.titleSmall;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: style,
        ),
        Text(
          _formatCurrency(value),
          style: style,
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}
