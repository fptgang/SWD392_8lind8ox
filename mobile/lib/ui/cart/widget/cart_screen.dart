import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/cubit/cart_cubit/cart_state.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit()..loadCart(),
      child: Scaffold(
        backgroundColor: getColorSkin().backgroundColor,
        appBar: AppBar(
          backgroundColor: getColorSkin().primaryRed650,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.cart,
            style: TextStyle(
              color: getColorSkin().white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: getColorSkin().backgroundColor),
            onPressed: () => context.push('/main'),
          ),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(child: Text(state.error!));
            }

            if (state.items.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.emptyCart),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Dismissible(
                        key: Key(item.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          context.read<CartCubit>().removeFromCart(item.productName);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: Row(
                            children: [
                              Image.network(
                                item.image,
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
                                      item.productName,
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
                                                  context.read<CartCubit>().updateQuantity(
                                                    item.productName,
                                                    item.quantity - 1,
                                                  );
                                                },
                                              ),
                                              Text(
                                                item.quantity.toString(),
                                                style: const TextStyle(fontSize: 14),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add, size: 16, color: getColorSkin().primaryRed800,),
                                                onPressed: () {
                                                  context.read<CartCubit>().updateQuantity(
                                                    item.productName,
                                                    item.quantity + 1,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "\$${(item.price * item.quantity).toStringAsFixed(2)}",
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
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: getColorSkin().backgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: getColorSkin().lightGrey300,
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.subTotal,
                            style: TextStyle(color: getColorSkin().grey),
                          ),
                          Text(
                            "\$${state.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: getColorSkin().primaryRed800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () => context.push('/checkout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getColorSkin().primaryRed650,
                          minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.checkout,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: getColorSkin().white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
