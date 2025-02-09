import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/cart/widget/cart_screen.dart';
import 'package:mobile/ui/information/widget/feature_test_bottom.dart';
import 'package:mobile/ui/information/widget/search_test_bottom.dart';
import '../../../blocs/bottom_navigation_bar/bottom_navigation_cubit.dart';
import '../../account/account_screen.dart';
import '../../common/custom_bottom_app_bar.dart';
import '../../homepage/widget/homepage_screen.dart';

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
        return CartScreen();
      case 3:
        return FeatureScreen();
      case 4:
        return AccountScreen();
      default:
        return HomePageScreen();
    }
  }
}
