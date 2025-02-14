


import 'package:flutter/material.dart';

Widget buildProductSection(){
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 8),
    child: Column(
      children: [
        // Shop Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'Mall',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            const Text('lenuo'),
          ],
        ),
        const SizedBox(height: 16),
        // Product Details
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/jpg/blind_box.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giá đỡ Lenuo để bàn có thể điều chỉnh cho điện thoại',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'black',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'đ59.000',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('x1'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}