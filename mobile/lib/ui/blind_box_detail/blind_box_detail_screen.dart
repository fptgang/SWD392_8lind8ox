import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/cubit/cart_cubit/cart_state.dart';
import 'package:mobile/di/injection.dart';
import 'package:mobile/ui/cart/cart_screen.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:badges/badges.dart' as badges;

import '../../blocs/blindbox_detail/blindbox_detail_bloc.dart';
import '../../blocs/blindbox_detail/blindbox_detail_event.dart';
import '../../blocs/blindbox_detail/blindbox_detail_state.dart';
import 'widgets/bottom_action_bar.dart';
import 'widgets/image_carousel.dart';
import 'widgets/product_details.dart';
import 'widgets/thumbnails_gallery.dart';

class ProductDetailScreen extends StatelessWidget {
  final int blindBoxId;

  const ProductDetailScreen({super.key, required this.blindBoxId});

  @override
  Widget build(BuildContext context) {
    final cartCubit = getIt<CartCubit>();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BlindBoxDetailBloc>()
            ..add(FetchBlindBoxDetail(blindBoxId)),
        ),
        BlocProvider(
          create: (context) => cartCubit,
        ),
      ],
      child: const _PageControllerProvider(
        child: _ProductDetailView(),
      ),
    );
  }
}

class _PageControllerProvider extends StatefulWidget {
  final Widget child;
  
  const _PageControllerProvider({
    super.key,
    required this.child,
  });
  
  @override
  State<_PageControllerProvider> createState() => _PageControllerProviderState();
}

class _PageControllerProviderState extends State<_PageControllerProvider> {
  final PageController pageController = PageController();
  
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return _PageControllerInherited(
      pageController: pageController,
      child: widget.child,
    );
  }
}

class _PageControllerInherited extends InheritedWidget {
  final PageController pageController;
  
  const _PageControllerInherited({
    super.key,
    required this.pageController,
    required super.child,
  });
  
  static _PageControllerInherited of(BuildContext context) {
    final _PageControllerInherited? result = 
        context.dependOnInheritedWidgetOfExactType<_PageControllerInherited>();
    assert(result != null, 'No _PageControllerInherited found in context');
    return result!;
  }
  
  @override
  bool updateShouldNotify(_PageControllerInherited oldWidget) => 
      pageController != oldWidget.pageController;
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    final pageController = _PageControllerInherited.of(context).pageController;
    
    return BlocBuilder<BlindBoxDetailBloc, BlindBoxDetailState>(
      builder: (context, state) {
        if (state is BlindBoxLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is BlindBoxErrorState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: getColorSkin().primaryRed650,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: getColorSkin().white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: SelectableText.rich(
                TextSpan(
                  text: state.error,
                  style: const TextStyle(color: Colors.red),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is BlindBoxDataState) {
          return _buildLoadedState(context, state, pageController);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Scaffold _buildLoadedState(
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
              // Calculate total items in cart
              final int itemCount = cartState.items.fold(
                0, (sum, item) => sum + item.quantity);
              
              return badges.Badge(
                showBadge: itemCount > 0,
                badgeContent: Text(
                  itemCount.toString(),
                  style: TextStyle(
                    color: getColorSkin().white,
                    fontSize: 10,
                  ),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: getColorSkin().primaryRed200,
                  padding: const EdgeInsets.all(5),
                ),
                position: badges.BadgePosition.topEnd(top: 0, end: 0),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: getColorSkin().white),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(isFromBottomNav: false),
                    ),
                  ),
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
}
