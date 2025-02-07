import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/ui/cart/widget/cart_screen.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/information/widget/feature_test_bottom.dart';
import 'package:mobile/ui/information/widget/search_test_bottom.dart';
import '../../../blocs/bottom_navigation_bar/bottom_navigation_cubit.dart';
import '../../account/account_screen.dart';
import '../../common/custom_bottom_app_bar.dart';
import '../../homepage/widget/homepage_screen.dart';
import 'account_test_bottom.dart';

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
            body: IndexedStack(
              index: selectedIndex,
              children: [
                HomePageScreen(),
                SearchScreen(),
                CartScreen(),
                FeatureScreen(),
                AccounTestScreen(),
              ],
            ),
            bottomNavigationBar: CustomBottomAppBar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) => context.read<BottomNavigationCubit>().changeTab(index),
              // selectedItemColor: getColorSkin().primaryRed950,
              // unselectedItemColor: Colors.grey,
              // items: [
              //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              //   BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
              //   BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
              //   BottomNavigationBarItem(icon: Icon(Icons.star), label: "Features"),
              //   BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
              // ],
            ),
          );
        },
      ),
    );
  }
}
