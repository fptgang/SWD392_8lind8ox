
import 'package:flutter/material.dart';

Widget buildPromotionalSection(){
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Icon(Icons.confirmation_number_outlined, color: Colors.red[400]),
        const SizedBox(width: 12),
        const Text('Shopee Voucher'),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Miễn Phí Vận Chuyển',
            style: TextStyle(color: Colors.green),
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    ),
  );
}