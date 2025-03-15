

import 'package:flutter/material.dart';

Widget buildShippingMethod(){
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giao Nhanh 4 Ngày',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Đảm bảo nhận hàng vào 17 Tháng 2',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          'Giao hàng trong 4 ngày cho đơn đặt trước 14:00, không tính Chủ nhật & ngày lễ',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    ),
  );
}