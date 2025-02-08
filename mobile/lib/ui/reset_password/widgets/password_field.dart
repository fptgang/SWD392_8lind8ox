import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildPasswordField(String label, String value, ValueChanged<String> onChanged, bool isValid) {
  return TextField(
    onChanged: onChanged,
    obscureText: true,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
      filled: true,
      fillColor: Color(0xFF23233D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}