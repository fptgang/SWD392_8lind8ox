import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/feature/toys/toy_detail_screen.dart';

class AppRouter {
  static GoRouter get router {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/toy/:id',
          builder: (context, state) {
            final int id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
            return ToyDetailScreen(toyId: id);
          },
        ),
      ],
    );
  }
}
