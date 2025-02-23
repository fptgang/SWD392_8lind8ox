import 'package:flutter/material.dart';

class FilterSortButtons extends StatelessWidget {
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;

  const FilterSortButtons({
    Key? key,
    required this.onSortTap,
    required this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilterButton(
          icon: Icons.sort,
          label: 'Sort by',
          onTap: onSortTap,
        ),
        const SizedBox(width: 12),
        FilterButton(
          icon: Icons.tune,
          label: 'Filter',
          onTap: onFilterTap,
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}