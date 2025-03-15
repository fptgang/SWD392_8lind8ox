import 'package:flutter/material.dart';
import 'package:mobile/base/theme/theme.dart';

Widget buildLoadingIndicator() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: getColorSkin().primaryRed650,
        ),
        SizedBox(height: 16),
        Text('Processing...'),
      ],
    ),
  );
}
