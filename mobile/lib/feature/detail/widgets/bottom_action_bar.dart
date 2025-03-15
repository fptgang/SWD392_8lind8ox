import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/cart/cart_screen.dart';

import '../../cart/cubits/cart_cubit.dart';
import '../blocs/blindbox_detail_state.dart';

class BottomActionBar extends StatelessWidget {
  final BlindBoxDataState state;

  const BottomActionBar({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return BottomAppBar(
      color: getColorSkin().white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _addToCart(context, appLocalizations),
                style: ElevatedButton.styleFrom(
                  backgroundColor: getColorSkin().white,
                  side: BorderSide(color: getColorSkin().primaryRed200),
                  padding:
                      EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  // minimumSize: Size(0, 50.h),
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    appLocalizations.addToCart,
                    style: TextStyle(
                      color: getColorSkin().primaryRed950,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.push('/checkout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: getColorSkin().primaryRed650,
                  padding:
                      EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    appLocalizations.shopNow,
                    style: TextStyle(
                      color: getColorSkin().white,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final blindBox = state.blindBox;
    final quantity = state.quantity;
    final selectedSku = state.sku;

    final bool isSet =
        selectedSku?.specCount != null && selectedSku!.specCount! > 1;

    final skus = blindBox.skus ?? [];
    final price =
        selectedSku?.price ?? (skus.isNotEmpty ? skus.first.price : 0) ?? 0.0;

    final String imageUrl;
    if (state.skuImages?.isNotEmpty == true) {
      imageUrl = state.skuImages!.first.imageUrl ?? '';
    } else if (state.images?.isNotEmpty == true) {
      imageUrl = state.images!.first;
    } else if (blindBox.images?.isNotEmpty == true) {
      imageUrl = blindBox.images!.first.imageUrl ?? '';
    } else {
      imageUrl = '';
    }

    final String productName;
    if (isSet && selectedSku.name != null) {
      productName = "${blindBox.name} - ${selectedSku.name}";
    } else {
      productName = blindBox.name ?? '';
    }

    final int itemId = selectedSku?.skuId ?? state.id;

    final product = CartDisplayItem(
      id: itemId,
      productName: productName,
      price: price,
      image: imageUrl,
      quantity: quantity,
      skuId: selectedSku?.skuId,
    );

    context.read<CartCubit>().addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${isSet ? "Set" : "Item"} ${appLocalizations.addToCart}',
          style: TextStyle(color: getColorSkin().white),
        ),
        action: SnackBarAction(
          label: appLocalizations.cart,
          textColor: getColorSkin().white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CartScreen(isFromBottomNav: false),
              ),
            );
          },
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: getColorSkin().primaryRed650,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
