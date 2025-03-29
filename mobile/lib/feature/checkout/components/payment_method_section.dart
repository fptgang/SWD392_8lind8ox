import 'package:flutter/material.dart';
import 'package:mobile/base/theme/theme.dart';

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
    final colorSkin = getColorSkin();

    return Card(
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
                  Icons.payment,
                  color: colorSkin.primaryRed650,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorSkin.primaryRed800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
    final colorSkin = getColorSkin();

    return InkWell(
      onTap: disabled
          ? null
          : () {
              onSelectPaymentMethod(value);
            },
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selected ? colorSkin.primaryRed650 : colorSkin.lightGrey300,
              width: selected ? 2 : 1,
            ),
            color: selected
                ? colorSkin.primaryRed650.withOpacity(0.08)
                : colorSkin.white,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colorSkin.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selected
                      ? colorSkin.primaryRed650.withOpacity(0.15)
                      : colorSkin.lightGrey100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: selected
                      ? colorSkin.primaryRed650
                      : colorSkin.primaryRed800,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: selected
                            ? colorSkin.primaryRed800
                            : colorSkin.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? colorSkin.primaryRed650.withOpacity(0.7)
                            : colorSkin.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingWidget != null) trailingWidget,
              if (selected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorSkin.primaryRed650,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
