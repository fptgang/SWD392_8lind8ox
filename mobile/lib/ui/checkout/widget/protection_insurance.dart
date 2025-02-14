import 'package:flutter/material.dart';

Widget buildProtectionInsurance(){
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (value) {},
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bảo hiểm rơi vỡ màn hình'),
              Text(
                'Bảo vệ các rủi ro nứt vỡ do sự cố hoặc tai nạn cho màn hình của thiết bị di động được mua tại Shopee hoặc các kênh mua sắm khác',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'đ23.999',
              style: TextStyle(color: Colors.red[700]),
            ),
            const Text('x1'),
          ],
        ),
      ],
    ),
  );
}