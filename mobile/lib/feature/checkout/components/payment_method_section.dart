import 'package:flutter/material.dart';

enum CartDtoPaymentMethodEnum {
  INTERNAL_WALLET,
  PAYPAL,
  VNPAY,
}

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({
    super.key,
    required this.selectedPaymentMethod,
    required this.onSelectPaymentMethod,
    this.walletBalance = 0.0,
    this.finalTotal = 0.0,
  });

  final CartDtoPaymentMethodEnum selectedPaymentMethod;
  final Function(CartDtoPaymentMethodEnum) onSelectPaymentMethod;
  final double walletBalance;
  final double finalTotal;

  @override
  Widget build(BuildContext context) {
    final hasInsufficientWalletBalance = walletBalance < finalTotal;

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
            const SizedBox(height: 12),
            _buildPaymentMethodOption(
              context,
              title: 'PayPal',
              subtitle: 'Pay with international cards via PayPal',
              icon: Icons.credit_card,
              value: CartDtoPaymentMethodEnum.PAYPAL,
              selected:
                  selectedPaymentMethod == CartDtoPaymentMethodEnum.PAYPAL,
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodOption(
              context,
              title: 'Wallet',
              subtitle:
                  'Available balance: \$${walletBalance.toStringAsFixed(2)}',
              icon: Icons.account_balance_wallet,
              value: CartDtoPaymentMethodEnum.INTERNAL_WALLET,
              selected: selectedPaymentMethod ==
                  CartDtoPaymentMethodEnum.INTERNAL_WALLET,
              disabled: hasInsufficientWalletBalance,
              trailingWidget: hasInsufficientWalletBalance
                  ? TextButton(
                      onPressed: () => _showWalletTopupDialog(context),
                      child: const Text('Top up'),
                    )
                  : null,
            ),
            if (hasInsufficientWalletBalance &&
                selectedPaymentMethod ==
                    CartDtoPaymentMethodEnum.INTERNAL_WALLET)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: _buildInsufficientBalanceAlert(context),
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
      onTap: disabled ? null : () => onSelectPaymentMethod(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey[300]!,
            width: selected ? 2 : 1,
          ),
          color: selected
              ? Colors.blue.withOpacity(0.05)
              : disabled
                  ? Colors.grey[100]
                  : null,
        ),
        child: Row(
          children: [
            Radio<CartDtoPaymentMethodEnum>(
              value: value,
              groupValue: selectedPaymentMethod,
              onChanged: disabled ? null : (v) => onSelectPaymentMethod(v!),
              activeColor: Colors.blue,
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.blue.withOpacity(0.1)
                    : disabled
                        ? Colors.grey[200]
                        : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: selected
                    ? Colors.blue
                    : disabled
                        ? Colors.grey[500]
                        : Colors.grey[700],
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
                      color: disabled ? Colors.grey[500] : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: disabled ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                  if (disabled &&
                      value == CartDtoPaymentMethodEnum.INTERNAL_WALLET)
                    Text(
                      'Insufficient balance',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            if (trailingWidget != null) trailingWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildInsufficientBalanceAlert(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red[700],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Insufficient wallet balance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                Text(
                  'Please top up your wallet or choose another payment method.',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWalletTopupDialog(BuildContext context) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Top Up Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Balance: \$${walletBalance.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
            ),
            if (finalTotal > walletBalance)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'To complete your order with wallet, you need to top up at least \$${(finalTotal - walletBalance).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, this would call a wallet top-up API
              Navigator.of(context).pop();

              // Show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wallet topped up successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Top Up'),
          ),
        ],
      ),
    );
  }
}
