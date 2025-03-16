import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';

class EmptyAddressView extends StatelessWidget {
  final VoidCallback onAddNew;

  const EmptyAddressView({
    Key? key,
    required this.onAddNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 64.sp,
            color: getColorSkin().grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'Bạn chưa có địa chỉ giao hàng',
            style: TextStyle(
              fontSize: 16.sp,
              color: getColorSkin().darkGrey,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: onAddNew,
            style: ElevatedButton.styleFrom(
              backgroundColor: getColorSkin().primaryRed650,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text(
              'Thêm địa chỉ mới',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}