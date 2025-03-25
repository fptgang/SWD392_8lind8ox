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
          onPressed: () => _showVoucherSelectionModal(context),
          icon: const Icon(Icons.loyalty),
          label: const Text('Select Voucher'),
        ),
      ],
    );
  }

  void _showVoucherSelectionModal(BuildContext context) {
    // Sample vouchers - in a real app would come from API
    final availableVouchers = [
      VoucherDto(
        voucherId: 1,
        code: 'WELCOME10',
        discountRate: 0.1,
        limitAmount: 20,
        expiredAt: DateTime.now().add(const Duration(days: 30)),
      ),
      VoucherDto(
        voucherId: 2,
        code: 'SUMMER20',
        discountRate: 0.2,
        limitAmount: 50,
        expiredAt: DateTime.now().add(const Duration(days: 15)),
      ),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Voucher',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: availableVouchers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.loyalty_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No vouchers available',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: availableVouchers.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final voucher = availableVouchers[index];
                        return _buildVoucherItem(context, voucher);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherItem(BuildContext context, VoucherDto voucher) {
    final discountRate = voucher.discountRate ?? 0;
    final discountPercentage = (discountRate * 100).round();

    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onSelectVoucher(voucher);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.confirmation_number,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.code ?? 'Voucher',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$discountPercentage% discount${voucher.limitAmount != null ? ' up to \$${voucher.limitAmount!.toStringAsFixed(2)}' : ''}',
                  ),
                  if (voucher.expiredAt != null)
                    Text(
                      'Expires: ${_formatDate(voucher.expiredAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSelectVoucher(voucher);
              },
              child: const Text('Select'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
