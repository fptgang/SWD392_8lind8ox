import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/data/models/cart_model.dart';
import '../../../cubit/cart_cubit/cart_state.dart';
import '../../core/theme/theme.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (!state.items.any((item) => item.id == cartItem.id)) {
          return const SizedBox.shrink();
        }

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
          context.read<CartCubit>().removeFromCart(cartItem.id.toString());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
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
                                onPressed: cartItem.quantity > 1
                                    ? () {
                                  context.read<CartCubit>().updateQuantity(
                                    cartItem.id.toString(),
                                    cartItem.quantity - 1,
                                  );
                                }
                                    : null,
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
                                    cartItem.id.toString(),
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
