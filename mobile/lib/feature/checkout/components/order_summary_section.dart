import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/base/theme/theme.dart';

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
    final colorSkin = getColorSkin();

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorSkin.lightGrey300, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorSkin.white,
              colorSkin.lightGrey100,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: colorSkin.primaryRed650,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorSkin.primaryRed800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Items Summary in a Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorSkin.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorSkin.lightGrey300),
                boxShadow: [
                  BoxShadow(
                    color: colorSkin.shadowLight,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    context,
                    label: 'Subtotal',
                    value: subtotal,
                  ),
                  if (savings > 0) ...[
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      context,
                      label: 'Savings',
                      value: -savings,
                      isHighlighted: true,
                      textColor: colorSkin.green,
                      icon: Icons.savings,
                    ),
                  ],
                  if (voucherDiscount > 0) ...[
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      context,
                      label: 'Voucher Discount',
                      value: -voucherDiscount,
                      isHighlighted: true,
                      textColor: colorSkin.green,
                      icon: Icons.discount,
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(
                      color: colorSkin.lightGrey300,
                      thickness: 1,
                    ),
                  ),
                  _buildSummaryRow(
                    context,
                    label: 'Total',
                    value: finalTotal,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    canPlaceOrder && !isProcessingOrder ? onPlaceOrder : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSkin.primaryRed650,
                  foregroundColor: colorSkin.white,
                  disabledBackgroundColor: colorSkin.lightGrey300,
                  disabledForegroundColor: colorSkin.grey,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isProcessingOrder
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: getColorSkin().primaryRed650,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              color: colorSkin.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Place Order',
                        style: TextStyle(
                          color: colorSkin.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            if (!canPlaceOrder)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorSkin.brightOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: colorSkin.brightOrange.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: colorSkin.shadowLight,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorSkin.brightOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please select a shipping address to continue',
                        style: TextStyle(
                          color: colorSkin.brightOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                GoRouter.of(context).go('/cart');
              },
              icon: Icon(Icons.arrow_back, color: getColorSkin().black),
              label: Text('Return to Cart', style: TextStyle(color: getColorSkin().black),),
              style: TextButton.styleFrom(
                backgroundColor: colorSkin.primaryRed650.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                minimumSize: const Size.fromHeight(44),
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
    IconData? icon,
  }) {
    final colorSkin = getColorSkin();
    final style = isTotal
        ? TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorSkin.primaryRed950,
          )
        : isHighlighted
            ? TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor ?? colorSkin.darkGrey,
              )
            : TextStyle(
                fontSize: 14,
                color: colorSkin.grey,
              );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: textColor ?? colorSkin.grey,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: style,
            ),
          ],
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
