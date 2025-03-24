import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/blocs/cart/cart_event.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';
import 'package:mobile/app/blocs/cart/cart_state.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/cart/widget/cart_item.dart';

import '../../app/cubits/bottom_navigation_cubit.dart';
import '../../app/di/injection.dart';

class CartScreen extends StatefulWidget {
  final bool isFromBottomNav;

  const CartScreen({
    super.key,
    this.isFromBottomNav = false,
  });

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const CartScreen());
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CartGlobalBloc _cartBloc;
  
  @override
  void initState() {
    super.initState();
    _cartBloc = getIt<CartGlobalBloc>();
    
    // Load cart data only once when the screen is initialized
    // This is safer than using WidgetsBinding in the build method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_cartBloc.isClosed && _cartBloc.state.items.isEmpty && !_cartBloc.state.isLoading) {
        _cartBloc.add(LoadCart());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: !widget.isFromBottomNav,
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
            if (widget.isFromBottomNav) {
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
              final state = _cartBloc.state;
              if (state.items.isNotEmpty) {
                _showClearCartConfirmation(context);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CartGlobalBloc, CartState>(
          bloc: _cartBloc, // Use the singleton instance directly
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
                        if (!_cartBloc.isClosed) {
                          _cartBloc.add(LoadCart());
                        }
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
                        isSelected: state.isItemSelected(item.id),
                        onSelectionChanged: (selected) {
                          if (!_cartBloc.isClosed) {
                            _cartBloc.add(ToggleItemSelection(item.id));
                          }
                        },
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
                if (!_cartBloc.isClosed) {
                  _cartBloc.add(ClearCart());
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
    if (!_cartBloc.isClosed) {
      _cartBloc.add(RemoveItemFromCart(
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
    if (!_cartBloc.isClosed) {
      _cartBloc.add(UpdateItemQuantity(
        skuId: item.skuId,
        quantity: newQuantity,
        slotId: item.slotId,
      ));
    }
  }

  Widget _buildSelectAllRow(BuildContext context, CartState state) {
    final bool allSelected = state.items.isNotEmpty && 
                            state.selectedItemIds.length == state.items.length;
    
    return Container(
      color: getColorSkin().white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Row(
            children: [
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: Checkbox(
                  value: allSelected,
                  onChanged: (selected) {
                    if (!_cartBloc.isClosed) {
                      if (selected == true) {
                        _cartBloc.add(SelectAllItems());
                      } else {
                        _cartBloc.add(DeselectAllItems());
                      }
                    }
                  },
                  activeColor: getColorSkin().primaryRed650,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Select All',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: getColorSkin().darkGrey,
                ),
              ),
            ],
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
                if (widget.isFromBottomNav) {
                  context.read<BottomNavigationCubit>().changeTab(0);
                } else {
                  AppRouter.router.go('/main');
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
    // Use selected items for calculations if any are selected, otherwise use all items
    final bool hasSelectedItems = state.hasSelectedItems;
    final int totalItems = hasSelectedItems ? state.selectedItemCount : state.itemCount;
    final double subtotal = hasSelectedItems ? state.selectedItemsTotal : state.total;
    final double discount = hasSelectedItems 
        ? state.selectedItemsVoucherDiscount
        : state.voucherDiscount;
    final double finalTotal = hasSelectedItems ? state.finalTotal : state.finalTotal;

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
                '${AppLocalizations.of(context)!.subTotal} (${hasSelectedItems ? state.selectedItems.length : state.items.length} items)',
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
                "\$${finalTotal.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().primaryRed950,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Show remove selected button when items are selected
          if (hasSelectedItems) ...[
            OutlinedButton.icon(
              onPressed: () {
                _showRemoveSelectedConfirmation(context);
              },
              icon: Icon(
                Icons.delete_outline,
                color: getColorSkin().warningRed,
              ),
              label: Text(
                'Remove Selected (${state.selectedItems.length})',
                style: TextStyle(
                  color: getColorSkin().warningRed,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: getColorSkin().warningRed),
                minimumSize: Size(double.infinity, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],
          
          ElevatedButton(
            onPressed: state.hasSelectedItems
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
              hasSelectedItems
                ? '${AppLocalizations.of(context)!.checkout} (${state.selectedItems.length})'
                : 'Select items to checkout',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().white),
            ),
          ),
          
          // Show selection hint when no items are selected
          if (!hasSelectedItems && state.items.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              'Select items above to proceed to checkout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: getColorSkin().grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context) {
    // Only proceed to checkout if there are selected items
    if (_cartBloc.state.hasSelectedItems) {
      context.push('/checkout');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select items to checkout'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showRemoveSelectedConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Selected Items',
            style: TextStyle(
              color: getColorSkin().primaryRed800,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to remove ${_cartBloc.state.selectedItems.length} selected items from your cart?'
          ),
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
                if (!_cartBloc.isClosed) {
                  _cartBloc.add(RemoveSelectedItems());
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Selected items removed from cart'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
