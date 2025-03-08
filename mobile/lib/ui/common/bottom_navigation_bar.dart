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
  const MainScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MainScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationCubit(),
      child: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: _buildBody(selectedIndex),
            bottomNavigationBar: CustomBottomAppBar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) => context.read<BottomNavigationCubit>().changeTab(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return HomePageScreen();
      case 1:
        return SearchScreen();
      case 2:
        return CartScreen(isFromBottomNav: true);
      case 3:
        return NewReleasesScreen();
      case 4:
        return AccountScreen();
      default:
        return HomePageScreen();
    }
  }
}
