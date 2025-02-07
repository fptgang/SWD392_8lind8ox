import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String productName;
  final double price;
  final String color;
  final String image;

  const CartItem({
    required this.productName,
    required this.price,
    required this.color,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(productName),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: getColorSkin().red,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: getColorSkin().backgroundColor),
      ),
      onDismissed: (direction) {
        // Handle the delete logic
      },
      child: Container(
        decoration: BoxDecoration(
          color: getColorSkin().backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16)),
              child: Image.asset(
                image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),

            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text("Size: M",
                        style: TextStyle(color: getColorSkin().grey)),
                    const SizedBox(height: 4),
                    Text("Color: $color",
                        style: TextStyle(color: getColorSkin().grey)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.remove, size: 18, color: getColorSkin().primaryRed800),
                            ),
                            const Text("01", style: TextStyle(fontSize: 14)),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.add, size: 18, color: getColorSkin().primaryRed800),
                            ),
                          ],
                        ),
                        // Price
                        Text("\$${price.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
