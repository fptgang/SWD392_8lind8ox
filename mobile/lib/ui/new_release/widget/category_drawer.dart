import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/set/set_bloc.dart';
import 'package:mobile/blocs/set/set_event.dart';
import 'package:mobile/ui/core/theme/theme.dart';

class CategoryDrawer extends StatelessWidget {
  const CategoryDrawer({super.key});

  static const List<String> categories = [
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
          _buildHeader(),
          ...categories.map((category) => _buildCategoryTile(context, category)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(color: getColorSkin().primaryRed650),
      child: const Text(
        "Categories",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String category) {
    return ListTile(
      title: Text(category),
      onTap: () {
        context.read<SetBloc>().add(SelectSetCategory(category));
        Navigator.pop(context);
      },
    );
  }
}