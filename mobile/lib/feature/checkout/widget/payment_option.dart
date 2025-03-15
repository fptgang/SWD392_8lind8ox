import 'package:flutter/material.dart';

Widget buildPaymentOption({
  required String title,
  required Widget icon,
  Widget? trailing,
  bool selected = false,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          trailing ?? (selected
            ? Icon(Icons.check_circle, color: Colors.red[400])
            : const Icon(Icons.circle_outlined, color: Colors.grey)
          ),
        ],
      ),
    ),
  );
}