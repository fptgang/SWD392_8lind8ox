import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/cubit/cart_cubit/cart_state.dart';
import 'package:mobile/ui/cart/widget/cart_item.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../di/injection.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>(),
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
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return CartItemWidget(cartItem: item);
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
