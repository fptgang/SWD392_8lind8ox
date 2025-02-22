import 'package:flutter/material.dart';

class SortByBottomSheet extends StatelessWidget {
  final Function(String) onSortSelected;

  const SortByBottomSheet({
    Key? key,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SORT BY',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          _SortOption(
            title: 'Recommended',
            isSelected: true,
            onTap: () => onSortSelected('recommended'),
          ),
          _SortOption(
            title: 'Recently added',
            isSelected: false,
            onTap: () => onSortSelected('recent'),
          ),
          _SortOption(
            title: 'Price: Low to High',
            isSelected: false,
            onTap: () => onSortSelected('price_asc'),
          ),
          _SortOption(
            title: 'Price: High to Low',
            isSelected: false,
            onTap: () => onSortSelected('price_desc'),
          ),
          _SortOption(
            title: 'Top rated',
            isSelected: false,
            onTap: () => onSortSelected('rating'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  final Function(Map<String, dynamic>) onApplyFilter;

  const FilterBottomSheet({
    Key? key,
    required this.onApplyFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back),
              ),
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Reset filter logic
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _FilterSection(
            title: 'Category',
            trailing: 'View all',
            onTap: () {},
          ),
          _FilterSection(
            title: 'Brand',
            trailing: 'View all',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          _ColorFilter(),
          const SizedBox(height: 20),
          _PriceRangeFilter(),
          const SizedBox(height: 20),
          _CustomerReviewFilter(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Apply filter logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Show 345 results',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final String trailing;
  final VoidCallback onTap;

  const _FilterSection({
    Key? key,
    required this.title,
    required this.trailing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  trailing,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ColorOption(
              color: Colors.grey,
              isSelected: true,
              label: 'Gray',
            ),
            const SizedBox(width: 8),
            _ColorOption(
              color: Colors.black,
              isSelected: false,
              label: 'Black',
            ),
            const SizedBox(width: 8),
            _ColorOption(
              color: Colors.white,
              isSelected: false,
              label: 'White',
              hasBorder: true,
            ),
            const SizedBox(width: 8),
            _ColorOption(
              color: Colors.teal,
              isSelected: false,
              label: 'Teal',
            ),
          ],
        ),
      ],
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final String label;
  final bool hasBorder;

  const _ColorOption({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.label,
    this.hasBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: hasBorder ? Border.all(color: Colors.grey) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: hasBorder ? Border.all(color: Colors.grey) : null,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRangeFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Price Range',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '0-234€',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Colors.black,
          ),
          child: RangeSlider(
            values: const RangeValues(0, 234),
            min: 0,
            max: 500,
            onChanged: (RangeValues values) {},
          ),
        ),
      ],
    );
  }
}

class _CustomerReviewFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Review',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        _ReviewOption(stars: 4, isSelected: true),
        _ReviewOption(stars: 3, isSelected: false),
        _ReviewOption(stars: 2, isSelected: false),
      ],
    );
  }
}

class _ReviewOption extends StatelessWidget {
  final int stars;
  final bool isSelected;

  const _ReviewOption({
    Key? key,
    required this.stars,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),
          const Text(' & up'),
          const Spacer(),
          if (isSelected)
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
