import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';
import 'package:mobile/app/blocs/cart/cart_state.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/detail/blocs/blindbox_detail_state.dart';
import 'package:mobile/feature/detail/widgets/bottom_action_bar.dart';
import 'package:mobile/feature/detail/widgets/image_carousel.dart';
import 'package:mobile/feature/detail/widgets/product_details.dart';
import 'package:mobile/feature/detail/widgets/thumbnails_gallery.dart';

Scaffold buildBlindBoxDetailLoadedState(BuildContext context,
    BlindBoxDataState state, PageController pageController) {
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
        BlocBuilder<CartGlobalBloc, CartState>(builder: (context, cartState) {
          final int itemCount =
              cartState.items.fold(0, (sum, item) => sum + item.quantity);

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
        }),
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
