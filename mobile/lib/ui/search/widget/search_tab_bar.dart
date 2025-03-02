import 'package:flutter/material.dart';

class SearchTabBar extends StatelessWidget {
  const SearchTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildTab(Icons.person_outline, 'Labubu', Colors.orange),
          _buildTab(Icons.favorite_border, 'BabyThree', Colors.pink),
          _buildTab(Icons.home_outlined, 'Cinamoroll', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 14),
          ),
        ],
      ),
    );
  }
}