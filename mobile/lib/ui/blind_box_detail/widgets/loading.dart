import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/blocs/blindbox_detail/blindbox_detail_state.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/cubit/cart_cubit/cart_state.dart';
import 'package:mobile/ui/blind_box_detail/widgets/bottom_action_bar.dart';
import 'package:mobile/ui/blind_box_detail/widgets/image_carousel.dart';
import 'package:mobile/ui/blind_box_detail/widgets/product_details.dart';
import 'package:mobile/ui/blind_box_detail/widgets/thumbnails_gallery.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:badges/badges.dart' as badges;

Scaffold buildBlindBoxDetailLoadedState(
    BuildContext context,
    BlindBoxDataState state,
    PageController pageController
    ) {
  return Scaffold(
    backgroundColor: getColorSkin().white,
    appBar: AppBar(
      backgroundColor: getColorSkin().primaryRed650,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: getColorSkin().white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.favorite_border, color: getColorSkin().white),
          onPressed: () {},
        ),
        BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              final int itemCount = cartState.items.fold(
                  0, (sum, item) => sum + item.quantity);

              return badges.Badge(
                showBadge: itemCount > 0,
                badgeContent: Text(
                  itemCount.toString(),
                  style: TextStyle(
                    color: getColorSkin().primaryRed950,
                    fontSize: 10,
                  ),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: getColorSkin().white,
                  padding: const EdgeInsets.all(5),
                ),
                position: badges.BadgePosition.topEnd(top: 0, end: 0),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: getColorSkin().white),
                  onPressed: () => context.push('/cart'),
                ),
              );
            }
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageCarousel(
            pageController: pageController,
            state: state,
          ),
          const SizedBox(height: 16),
          ThumbnailsGallery(
            pageController: pageController,
            state: state,
          ),
          const SizedBox(height: 16),
          ProductDetails(state: state),
        ],
      ),
    ),
    bottomNavigationBar: BottomActionBar(state: state),
  );
}