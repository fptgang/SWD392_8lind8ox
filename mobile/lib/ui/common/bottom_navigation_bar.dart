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
    // Add debug print to see if this component is being rendered
    debugPrint('Building MainScreen...');
    
    return BlocProvider(
      create: (context) => BottomNavigationCubit(),
      child: BlocBuilder<BottomNavigationCubit, int>(
        builder: (context, selectedIndex) {
          // Add debug print to see the selected index
          debugPrint('MainScreen selected index: $selectedIndex');
          
          final bool isCartScreen = selectedIndex == 2; // Hide Bottom Bar when in Cart

          return Scaffold(
            body: _buildBody(context, selectedIndex),
            // Always show the bottom navigation bar for debugging
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
