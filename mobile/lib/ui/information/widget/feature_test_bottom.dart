import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';

class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Feature Screen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: getColorSkin().primaryRed650,
        leading: Builder(
          builder: (context) => IconButton(
            color: Colors.white,
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add logic for more options
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}
