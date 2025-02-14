import 'package:flutter/material.dart';

Widget buildSummarySection(){
  return Container(
    color: Colors.white,
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chi tiết thanh toán',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Tổng tiền hàng'),
            Text('đ59.000'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Tổng tiền phí vận chuyển'),
            Text('đ17.000'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Giảm giá phí vận chuyển'),
            Text(
              '-đ17.000',
              style: TextStyle(color: Colors.red[400]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng cộng Voucher giảm giá'),
            Text(
              '-đ2.950',
              style: TextStyle(color: Colors.red[400]),
            ),
          ],
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tổng thanh toán',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'đ56.050',
              style: TextStyle(
                color: Colors.red[400],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}