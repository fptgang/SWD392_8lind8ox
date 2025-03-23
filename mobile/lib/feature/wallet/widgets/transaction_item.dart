// lib/feature/wallet/widgets/transaction_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/utils/enum/enum.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');
    final dateString = transaction.createdAt != null
        ? dateFormat.format(transaction.createdAt!)
        : 'N/A';

    final isDeposit = transaction.type == TransactionType.DEPOSIT;
    final statusColor = _getStatusColor(transaction.status);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: isDeposit
                ? getColorSkin().tertiaryGreen100
                : getColorSkin().lightRed,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDeposit ? Icons.arrow_downward : Icons.shopping_bag_outlined,
            color: isDeposit
                ? getColorSkin().tertiaryGreen500
                : getColorSkin().primaryRed600,
            size: 22.sp,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isDeposit ? 'Deposit' : 'Purchase',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: getColorSkin().darkGrey,
              ),
            ),
            Text(
              '${isDeposit ? '+' : '-'}\$${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: isDeposit
                    ? getColorSkin().tertiaryGreen500
                    : getColorSkin().primaryRed600,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateString,
                  style: TextStyle(
                    color: getColorSkin().grey,
                    fontSize: 12.sp,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _getStatusText(transaction.status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (transaction.orderId != null) ...[
              SizedBox(height: 4.h),
              Text(
                'Order #${transaction.orderId}',
                style: TextStyle(
                  color: getColorSkin().grey,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TransactionStatusEnum? status) {
    switch(status) {
      case TransactionStatusEnum.SUCCESS:
        return getColorSkin().successGreen;
      case TransactionStatusEnum.PENDING:
        return getColorSkin().brightOrange;
      case TransactionStatusEnum.FAILED:
        return getColorSkin().errorRed;
      default:
        return getColorSkin().grey;
    }
  }

  String _getStatusText(TransactionStatusEnum? status) {
    switch(status) {
      case TransactionStatusEnum.SUCCESS:
        return 'Completed';
      case TransactionStatusEnum.PENDING:
        return 'Pending';
      case TransactionStatusEnum.FAILED:
        return 'Failed';
      default:
        return 'Unknown';
    }
  }
}