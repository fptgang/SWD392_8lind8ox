import 'dart:convert';

import 'package:mobile/ui/cart/widget/cart_item.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> cartItems = jsonDecode(mockCartData);
    return Scaffold(
      backgroundColor: getColorSkin().backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Cart (03)",
          style: TextStyle(color: getColorSkin().black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getColorSkin().black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: getColorSkin().black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItem(
                  productName: item['productName'],
                  price: item['price'],
                  color: item['color'],
                  image: item['image'],
                );
              },
            ),
          ),

          // Bottom Summary Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration:  BoxDecoration(
              color: getColorSkin().backgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: getColorSkin().lightGrey300,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sub-total", style: TextStyle(color: getColorSkin().grey)),
                    const Text("\$2070.00",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery Fee", style: TextStyle(color: getColorSkin().grey)),
                    Text("\$45.00",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 8.h),
                Divider(thickness: 1.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Cost",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("\$2115.00",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: getColorSkin().black)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().accentColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                        color: getColorSkin().black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String mockCartData = '''
[
  {
    "productName": "Labubu Blind Box",
    "price": 975.0,
    "color": "Yellow Gold",
    "image": "assets/jpg/blind_box.jpg"
  },
  {
    "productName": "Baby Three Blind Box",
    "price": 750.0,
    "color": "Gray",
    "image": "assets/jpg/blind_box.jpg"
  },
  {
    "productName": "Cinamoroll Blind Box",
    "price": 345.0,
    "color": "Blue",
    "image": "assets/jpg/blind_box.jpg"
  }
]
''';

