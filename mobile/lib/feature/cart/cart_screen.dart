import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/blocs/cart/cart_event.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';
import 'package:mobile/app/blocs/cart/cart_state.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/cart/widget/cart_item.dart';

import '../../app/cubits/bottom_navigation_cubit.dart';
import '../../app/di/injection.dart';

class CartScreen extends StatelessWidget {
  final bool isFromBottomNav;

  const CartScreen({
    super.key,
    this.isFromBottomNav = false,
  });

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CartScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<CartGlobalBloc>();
        // Ensure cart is loaded when the screen is opened
        bloc.add(LoadCart());
        return bloc;
      },
      child: Scaffold(
        extendBody: !isFromBottomNav,
        extendBodyBehindAppBar: false,
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
            onPressed: () {
              if (isFromBottomNav) {
                context.read<BottomNavigationCubit>().changeTab(0);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete_outline, color: getColorSkin().white),
              onPressed: () {
                final state = context.read<CartGlobalBloc>().state;
                if (state.items.isNotEmpty) {
                  _showClearCartConfirmation(context);
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<CartGlobalBloc, CartState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SelectableText.rich(
                        TextSpan(
                          text: state.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CartGlobalBloc>().add(LoadCart());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state.items.isEmpty) {
                return _buildEmptyCart(context);
              }

              return Column(
                children: [
                  _buildSelectAllRow(context, state),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.items.length,
                      separatorBuilder: (context, index) => Divider(
                        color: getColorSkin().lightGrey200,
                        height: 16.h,
                      ),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return CartItemWidget(
                          cartItem: item,
                          onRemove: () {
                            _removeItem(context, item);
                          },
                          onQuantityChanged: (newQuantity) {
                            debugPrint(
                                'Quantity changed for ${item.skuId} to $newQuantity');
                            _updateItemQuantity(context, item, newQuantity);
                          },
                        );
                      },
                    ),
                  ),
                  _buildCartSummary(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showClearCartConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear Cart',
            style: TextStyle(
              color: getColorSkin().primaryRed800,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
              'Are you sure you want to remove all items from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: getColorSkin().grey),
              ),
            ),
            TextButton(
              onPressed: () {
                final cartBloc = context.read<CartGlobalBloc>();
                if (!cartBloc.isClosed) {
                  cartBloc.add(ClearCart());
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your cart has been cleared'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _removeItem(BuildContext context, dynamic item) {
    final cartBloc = context.read<CartGlobalBloc>();
    if (!cartBloc.isClosed) {
      cartBloc.add(RemoveItemFromCart(
        skuId: item.skuId,
        slotId: item.slotId,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item removed from cart'),
          duration: const Duration(seconds: 2),
          backgroundColor: getColorSkin().primaryRed650,
        ),
      );
    }
  }

  void _updateItemQuantity(
      BuildContext context, dynamic item, int newQuantity) {
    final cartBloc = context.read<CartGlobalBloc>();
    if (!cartBloc.isClosed) {
      cartBloc.add(UpdateItemQuantity(
        skuId: item.skuId,
        quantity: newQuantity,
        slotId: item.slotId,
      ));
    }
  }

  Widget _buildSelectAllRow(BuildContext context, CartState state) {
    return Container(
      color: getColorSkin().white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Text(
            'Items in Cart',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: getColorSkin().primaryRed800,
            ),
          ),
          const Spacer(),
          Text(
            '${state.items.length} item(s)',
            style: TextStyle(
              fontSize: 14.sp,
              color: getColorSkin().grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64.sp,
            color: getColorSkin().grey,
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!.emptyCart,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: getColorSkin().grey,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 200.w,
            child: ElevatedButton(
              onPressed: () {
                if (isFromBottomNav) {
                  context.read<BottomNavigationCubit>().changeTab(0);
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: getColorSkin().primaryRed650,
                foregroundColor: getColorSkin().white,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, CartState state) {
    final totalItems = state.itemCount;
    final subtotal = state.total;
    final discount = state.voucherDiscount;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: getColorSkin().white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: getColorSkin().shadowLight,
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
                '${AppLocalizations.of(context)!.subTotal} ($totalItems items)',
                style: TextStyle(color: getColorSkin().grey),
              ),
              Text(
                "\$${subtotal.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().primaryRed800,
                ),
              ),
            ],
          ),
          if (discount > 0) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style: TextStyle(color: getColorSkin().green),
                ),
                Text(
                  "-\$${discount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: getColorSkin().green,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().primaryRed950,
                ),
              ),
              Text(
                "\$${state.finalTotal.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().primaryRed950,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: state.items.isNotEmpty
                ? () => _proceedToCheckout(context)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: getColorSkin().primaryRed650,
              disabledBackgroundColor: getColorSkin().lightGrey300,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              '${AppLocalizations.of(context)!.checkout} ($totalItems)',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().white),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context) {
    context.push('/checkout');
  }
}
