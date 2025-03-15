import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/cart/cubits/cart_cubit.dart';
import 'package:mobile/feature/cart/cubits/cart_state.dart';
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
      create: (context) => getIt<CartCubit>(),
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
        ),
        body: SafeArea(
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null) {
                return Center(
                  child: SelectableText.rich(
                    TextSpan(
                      text: state.error!,
                      style: TextStyle(color: Colors.red),
                    ),
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
                        return CartItemWidget(cartItem: item);
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
                final cartCubit = context.read<CartCubit>();
                if (!cartCubit.isClosed) {
                  cartCubit.clearCart();
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your cart has been cleared'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectAllRow(BuildContext context, CartState state) {
    final bool allSelected =
        state.items.length == state.selectedItemIds.length &&
            state.items.isNotEmpty;
    final int selectedCount = state.selectedItemIds.length;

    return Container(
      color: getColorSkin().white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Checkbox(
            value: allSelected,
            activeColor: getColorSkin().primaryRed650,
            onChanged: (bool? value) {
              final cartCubit = context.read<CartCubit>();
              if (!cartCubit.isClosed) {
                cartCubit.toggleSelectAll();
              }
            },
          ),
          Text(
            'Select All',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            '$selectedCount item(s) selected',
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
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: getColorSkin().primaryRed650,
                foregroundColor: getColorSkin().white,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
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
    final selectedItems = state.items
        .where((item) => state.selectedItemIds.contains(item.id))
        .toList();
    final totalItems =
        selectedItems.fold(0, (sum, item) => sum + item.quantity);
    final subtotal = selectedItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));

    return Container(
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
                '${AppLocalizations.of(context)!.subTotal} ($totalItems items)',
                style: TextStyle(color: getColorSkin().grey),
              ),
              Text(
                "\$${subtotal.toStringAsFixed(2)}",
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
            onPressed: state.selectedItemIds.isNotEmpty
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
              '${AppLocalizations.of(context)!.checkout} (${state.selectedItemIds.length})',
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
