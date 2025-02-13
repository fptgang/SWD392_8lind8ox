import 'package:flutter/material.dart';

Widget buildPaymentOption({
  required String title,
  required Widget icon,
  Widget? trailing,
  bool selected = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        icon,
        const SizedBox(width: 12),
        Expanded(child: Text(title)),
        trailing ?? (selected ? Icon(Icons.check_circle, color: Colors.red[400]) : const SizedBox()),
      ],
    ),
  );
}