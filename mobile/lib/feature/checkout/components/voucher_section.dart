import 'package:flutter/material.dart';
import 'package:mobile/base/theme/theme.dart';

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
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
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
                  Icons.discount_outlined,
                  color: colorSkin.primaryRed650,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Voucher',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorSkin.primaryRed800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
    final colorSkin = getColorSkin();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorSkin.green.withOpacity(0.1),
        border: Border.all(color: colorSkin.green.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: colorSkin.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorSkin.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, size: 22, color: colorSkin.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedVoucher?.code ?? 'Voucher',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorSkin.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$discountPercentage% discount${selectedVoucher?.limitAmount != null ? ' up to \$${selectedVoucher!.limitAmount!.toStringAsFixed(2)}' : ''}',
                  style: TextStyle(
                    color: colorSkin.green,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                if (selectedVoucher?.expiredAt != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Expires: ${_formatDate(selectedVoucher!.expiredAt!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorSkin.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onRemoveVoucher,
            icon: const Icon(Icons.close, size: 16),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorSkin.warningRed.withOpacity(0.1),
              foregroundColor: colorSkin.warningRed,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: colorSkin.warningRed.withOpacity(0.3)),
              ),
            ),
            label: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoVoucher(BuildContext context) {
    final colorSkin = getColorSkin();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorSkin.lightGrey100,
        border: Border.all(color: colorSkin.lightGrey300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorSkin.lightGrey200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.local_offer_outlined,
              size: 24,
              color: colorSkin.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No voucher applied',
              style: TextStyle(
                color: colorSkin.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => onSelectVoucher(VoucherDto()),
            icon: const Icon(Icons.loyalty),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorSkin.primaryRed650,
              foregroundColor: colorSkin.white,
              elevation: 1,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            label: const Text('Select Voucher'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
