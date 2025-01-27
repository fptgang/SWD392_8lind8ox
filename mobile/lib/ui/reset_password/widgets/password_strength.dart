import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildPasswordStrength() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      buildStrengthIndicator("Min 6 characters", true),
      SizedBox(width: 10),
      buildStrengthIndicator("Uppercase", true),
      SizedBox(width: 10),
      buildStrengthIndicator("Lowercase", true),
    ],
  );
}

Widget buildStrengthIndicator(String text, bool isMet) {
  return Row(
    children: [
      Icon(
        isMet ? Icons.check_circle : Icons.circle_outlined,
        color: isMet ? Colors.green : Colors.grey,
        size: 16,
      ),
      SizedBox(width: 4),
      Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: isMet ? Colors.green : Colors.grey[400],
        ),
      ),
    ],
  );
}
