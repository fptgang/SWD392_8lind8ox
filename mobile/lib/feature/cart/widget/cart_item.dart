import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/cart/cubits/cart_cubit.dart';
import 'package:mobile/feature/cart/cubits/cart_state.dart';

class CartItemWidget extends StatelessWidget {
  final CartDisplayItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (!state.items.any((item) => item.id == cartItem.id)) {
          return const SizedBox.shrink();
        }

        final bool isSelected = state.selectedItemIds.contains(cartItem.id);

        return Dismissible(
          key: Key(cartItem.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            debugPrint('Dismissing item with ID: ${cartItem.id}');
            context.read<CartCubit>().removeFromCart(cartItem.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item removed from cart'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  activeColor: getColorSkin().primaryRed800,
                  onChanged: (bool? value) {
                    context.read<CartCubit>().toggleItemSelection(cartItem.id);
                  },
                ),
                Image.network(
                  cartItem.image,
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/jpg/blind_box.jpg',
                      width: 80.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: getColorSkin().primaryRed200,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: getColorSkin().primaryRed800,
                                  ),
                                  onPressed: () {
                                    if (cartItem.quantity > 1) {
                                      context.read<CartCubit>().updateQuantity(
                                            cartItem.id,
                                            cartItem.quantity - 1,
                                          );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Remove Item'),
                                          content: const Text(
                                              'Do you want to remove this item from cart?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: getColorSkin().grey),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                debugPrint(
                                                    'Removing item from cart with ID: ${cartItem.id}');
                                                context
                                                    .read<CartCubit>()
                                                    .removeFromCart(
                                                        cartItem.id);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Item removed from cart'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Remove',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  cartItem.quantity.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    size: 16,
                                    color: getColorSkin().primaryRed800,
                                  ),
                                  onPressed: () {
                                    context.read<CartCubit>().updateQuantity(
                                          cartItem.id,
                                          cartItem.quantity + 1,
                                        );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}",
                            style: TextStyle(
                              color: getColorSkin().primaryRed800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
