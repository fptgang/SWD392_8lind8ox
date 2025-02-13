

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/ui/core/theme/theme.dart';

Widget buildAddressSection(){
  return Container(
    color: getColorSkin().backgroundColor,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(Icons.location_on, color: Colors.red[400]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trúc Duyên (+84) 944 352 144',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Số 176, Phạm Văn Đồng\nPhường 3, Quận Gò Vấp, TP. Hồ Chí Minh',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    ),
  );
}