import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/bottom_navigation_bar/bottom_navigation_cubit.dart';
import 'package:mobile/ui/cart/cart_screen.dart';
import 'package:mobile/ui/search/search_screen.dart';
import '../account/account_screen.dart';
import '../homepage/homepage_screen.dart';
import '../new_release/new_release_screen.dart';
import 'custom_bottom_app_bar.dart';

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
        NewReleasesScreen(),
        AccountScreen(),
      ],
    );
  }
}
