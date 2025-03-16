import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';

class DepositDialog extends StatefulWidget {
  final Function(double) onDeposit;

  const DepositDialog({
    Key? key,
    required this.onDeposit,
  }) : super(key: key);

  @override
  State<DepositDialog> createState() => _DepositDialogState();
}

class _DepositDialogState extends State<DepositDialog> {
  final TextEditingController _amountController = TextEditingController();
  final List<double> _quickAmounts = [5, 10, 20, 50, 100];
  double _selectedAmount = 0;
  bool _isCustomAmount = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateSelectedAmount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _updateSelectedAmount() {
    if (_amountController.text.isNotEmpty) {
      try {
        setState(() {
          _selectedAmount = double.parse(_amountController.text);
        });
      } catch (_) {
        // Invalid number format, ignore or add error handling if needed
      }
    } else {
      setState(() {
        _selectedAmount = 0;
      });
    }
  }

  void _selectQuickAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _isCustomAmount = false;
      _amountController.text = amount.toString();
    });
  }

  void _activateCustomAmount() {
    setState(() {
      _isCustomAmount = true;
      _amountController.clear();
      _selectedAmount = 0;
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  bool get _isValidAmount => _selectedAmount > 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Title
            Text(
            'Add Money to Wallet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: getColorSkin().primaryRed950,
            ),
          ),
          SizedBox(height: 16.h),
          // Amount input field
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: 'Enter amount',
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: getColorSkin().lightGrey500),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: getColorSkin().primaryRed600),
              ),
            ),
            onTap: _activateCustomAmount,
          ),
          SizedBox(height: 24.h),
          // Button row for Cancel and Add Money
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(color: getColorSkin().lightGrey700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: getColorSkin().darkGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isValidAmount
                      ? () {
                    widget.onDeposit(_selectedAmount);
                    Navigator.pop(context);
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().primaryRed650,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    disabledBackgroundColor: getColorSkin().lightGrey300,
                  ),
                  child: Text(
                    'Add Money',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Instruction text
          Text(
            'Select an amount to add to your wallet',
            style: TextStyle(
              fontSize: 14.sp,
              color: getColorSkin().grey,
            ),
          ),
          SizedBox(height: 24.h),
          // Quick Amounts Title
          Text(
            'Quick Amounts',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: getColorSkin().darkGrey,
            ),
          ),
          SizedBox(height: 12.h),
          // Quick Amounts buttons
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _quickAmounts.map((amount) {
              final isSelected = !_isCustomAmount && _selectedAmount == amount;
              return InkWell(
                onTap: () => _selectQuickAmount(amount),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? getColorSkin().primaryRed600
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isSelected
                          ? getColorSkin().primaryRed600
                          : getColorSkin().lightGrey500,
                    ),
                  ),
                  child: Text(
                    '\$${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : getColorSkin().darkGrey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList()
              ..add(
                // Custom amount button
                InkWell(
                  onTap: _activateCustomAmount,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: _isCustomAmount
                          ? getColorSkin().primaryRed600
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: _isCustomAmount
                            ? getColorSkin().primaryRed600
                            : getColorSkin().lightGrey500,
                      ),
                    ),
                    child: Text(
                      'Custom',
                      style: TextStyle(
                        color: _isCustomAmount ? Colors.white : getColorSkin().darkGrey,
                        fontWeight: _isCustomAmount ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
          ),
          SizedBox(height: 24.h),
            Text(
              'Amount: \$${_selectedAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: getColorSkin().darkGrey,
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
