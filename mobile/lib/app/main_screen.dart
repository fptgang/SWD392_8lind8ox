import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/cubits/bottom_navigation_cubit.dart';
import 'package:mobile/feature/cart/cart_screen.dart';
import 'package:mobile/feature/search/search_screen.dart';
import 'package:mobile/feature/sets/set_screen.dart';

import '../feature/home/homepage_screen.dart';
import '../feature/profile/profile_screen.dart';
import 'widgets/custom_bottom_app_bar.dart';

class MainScreen extends StatelessWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MainScreen());
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building MainScreen with initialIndex: $initialIndex');

    return BlocProvider(
      create: (context) {
        // Create the cubit and immediately set the initial tab
        final cubit = BottomNavigationCubit();

        // If initialIndex is not the default (0), change to that tab
        if (initialIndex != 0) {
          cubit.changeTab(initialIndex);
        }

        return cubit;
      },
      child: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, selectedIndex) {
          debugPrint('MainScreen selected index: $selectedIndex');

          final bool isCartScreen = selectedIndex == 2;

          return Scaffold(
            body: _buildBody(context, selectedIndex),
            bottomNavigationBar: CustomBottomAppBar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) =>
                  context.read<BottomNavigationCubit>().changeTab(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, int selectedIndex) {
    return IndexedStack(
      index: selectedIndex,
      children: [
        HomePageScreen(),
        SearchScreen(),
        CartScreen(isFromBottomNav: true),
        SetScreen(),
        ProfileScreen(),
      ],
    );
  }
}
