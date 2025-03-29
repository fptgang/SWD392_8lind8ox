import 'package:flutter/material.dart';

enum CartDtoPaymentMethodEnum {
  VNPAY,
}

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onSelectPaymentMethod,
    this.finalTotal = 0.0,
  });

  final CartDtoPaymentMethodEnum selectedPaymentMethod;
  final Function(CartDtoPaymentMethodEnum) onSelectPaymentMethod;
  final double finalTotal;

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
              'Payment Method',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodOption(
              context,
              title: 'VNPAY',
              subtitle: 'Pay via VNPAY gateway',
              icon: Icons.account_balance,
              value: CartDtoPaymentMethodEnum.VNPAY,
              selected: selectedPaymentMethod == CartDtoPaymentMethodEnum.VNPAY,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required CartDtoPaymentMethodEnum value,
    required bool selected,
    bool disabled = false,
    Widget? trailingWidget,
  }) {
    return InkWell(
      onTap: disabled
          ? null
          : () {
              onSelectPaymentMethod(value);
            },
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? Colors.blue : Colors.grey[300]!,
              width: selected ? 2 : 1,
            ),
            color: selected ? Colors.blue.withOpacity(0.05) : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingWidget != null) trailingWidget,
              if (selected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
