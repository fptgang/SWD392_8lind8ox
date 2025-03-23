import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/shipping_info_model.dart';

class AddressCard extends StatelessWidget {
  final ShippingInfoModel address;
  final bool isDefault;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback? onSelect;
  final VoidCallback? onEdit;

  const AddressCard({
    Key? key,
    required this.address,
    this.isDefault = false,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onSelect,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelectionMode ? onSelect : onEdit,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSelectionMode)
              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : null,
                onChanged: (_) => onSelect?.call(),
                activeColor: getColorSkin().primaryRed650,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 4.h),
                  _buildAddressDetails(),
                  SizedBox(height: 8.h),
                  if (isDefault)
                    _buildDefaultBadge(),
                ],
              ),
            ),
            if (!isSelectionMode && onEdit != null)
              TextButton(
                onPressed: onEdit,
                child: Text(
                  'Sửa',
                  style: TextStyle(
                    color: getColorSkin().primaryRed650,
                    fontSize: 14.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          address.name ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '|',
          style: TextStyle(
            color: getColorSkin().grey,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          address.phoneNumber ?? '',
          style: TextStyle(
            color: getColorSkin().darkGrey,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.address ?? '',
          style: TextStyle(
            color: getColorSkin().darkGrey,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${address.ward ?? ''}, ${address.district ?? ''}, ${address.city ?? ''}',
          style: TextStyle(
            color: getColorSkin().darkGrey,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(color: getColorSkin().primaryRed650),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'Mặc định',
        style: TextStyle(
          color: getColorSkin().primaryRed650,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}