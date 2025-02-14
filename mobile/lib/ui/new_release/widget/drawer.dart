import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/category_cubit/category_cubit.dart';
import 'package:mobile/ui/core/theme/theme.dart';
class CategoryDrawer extends StatelessWidget {
  final List<String> categories = [
    "Popular",
    "Trending",
    "Skullpanda",
    "Labubu",
    "Dimoo",
    "Molly",
    "Storage",
    "Phone Stands",
    "Earphones",
    "Cables",
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: getColorSkin().primaryRed650),
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          ...categories.map((category) {
            return ListTile(
              title: Text(category),
              onTap: () {
                context.read<CategoryCubit>().selectCategory(category);
                Navigator.pop(context); // Close the drawer
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
