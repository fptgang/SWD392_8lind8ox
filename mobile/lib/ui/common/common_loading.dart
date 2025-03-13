import 'package:flutter/material.dart';

Widget buildLoadingIndicator() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Processing...'),
      ],
    ),
  );
}
