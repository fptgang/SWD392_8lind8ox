import 'package:flutter/material.dart';

class VoucherDto {
  final int? voucherId;
  final String? code;
  final double? discountRate;
  final double? limitAmount;
  final DateTime? expiredAt;

  VoucherDto({
    this.voucherId,
    this.code,
    this.discountRate,
    this.limitAmount,
    this.expiredAt,
  });
}

class VoucherSection extends StatelessWidget {
  const VoucherSection({
    super.key,
    this.selectedVoucher,
    required this.onSelectVoucher,
    required this.onRemoveVoucher,
  });

  final VoucherDto? selectedVoucher;
  final Function(VoucherDto) onSelectVoucher;
  final Function() onRemoveVoucher;

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
              'Voucher',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (selectedVoucher != null)
              _buildAppliedVoucher(context)
            else
              _buildNoVoucher(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppliedVoucher(BuildContext context) {
    final discountRate = selectedVoucher?.discountRate ?? 0;
    final discountPercentage = (discountRate * 100).round();

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.green[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
              const SizedBox(width: 4),
              const Text('Applied'),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedVoucher?.code ?? 'Voucher',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$discountPercentage% discount${selectedVoucher?.limitAmount != null ? ' up to \$${selectedVoucher!.limitAmount!.toStringAsFixed(2)}' : ''}',
                style: TextStyle(color: Colors.green[700], fontSize: 13),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: onRemoveVoucher,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[50],
            foregroundColor: Colors.red,
          ),
          child: const Text('Remove'),
        ),
      ],
    );
  }

  Widget _buildNoVoucher(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'No voucher applied',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => onSelectVoucher(VoucherDto()),
          icon: const Icon(Icons.loyalty),
          label: const Text('Select Voucher'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
