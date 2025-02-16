import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/di/injection.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_bloc.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_event.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_state.dart';

class ProductDetailScreen extends StatelessWidget {
  final int blindBoxId;

  const ProductDetailScreen({super.key, required this.blindBoxId});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final cartCubit = getIt<CartCubit>();
    debugPrint('blindBoxId: $blindBoxId');
    int quantity = 1;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BlindBoxDetailBloc>()..add(FetchBlindBoxDetail(blindBoxId)),
        ),
        BlocProvider(
          create: (context) => cartCubit,
        ),
      ],
      child: BlocBuilder<BlindBoxDetailBloc, BlindBoxDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          if( state.blindBox == null) {
            return const Center(child: Text('No data'));
          }

          final blindBox = state.blindBox;

          debugPrint('Blind box: ${blindBox.toString()}');
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
                  icon:
                      Icon(Icons.favorite_border, color: getColorSkin().white),
                  onPressed: () {},
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Carousel
                  SizedBox(
                    height: 300,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index) {
                        context.read<BlindBoxDetailBloc>()
                            .add(UpdateSelectedImage(index));
                      },
                      children: (blindBox?.images.isNotEmpty ?? false)
                          ? blindBox!.images.map((image) =>
                          Image.network(
                            image.imageUrl ?? '',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/jpg/blind_box.jpg',
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                      ).toList()
                          : [
                        Image.asset(
                          'assets/jpg/blind_box.jpg',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 80.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: blindBox?.images.length ?? 0,
                      separatorBuilder: (context, index) => SizedBox(width: 16.w),
                      itemBuilder: (context, index) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: getColorSkin().lightGrey200,
                          child: blindBox?.images.isNotEmpty ?? false
                              ? Image.network(
                                  blindBox?.images[index].imageUrl ?? '',
                                  fit: BoxFit.cover,
                                )
                              : Image.asset('assets/jpg/blind_box.jpg'),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blindBox?.name ?? '',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: getColorSkin().black),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              "\$${blindBox?.skus.map((sku) => sku.price)}",
                              style: TextStyle(
                                  fontSize: 16, color: getColorSkin().black),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: getColorSkin().primaryRed200),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      size: 20,
                                      color: getColorSkin().primaryRed800,
                                    ),
                                    onPressed: () {
                                      context.read<BlindBoxDetailBloc>().add(DecrementQuantity());
                                    },
                                  ),
                                  Text(
                                    state.quantity.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: getColorSkin().primaryRed800,
                                    ),
                                    onPressed: () {
                                      context.read<BlindBoxDetailBloc>().add(IncrementQuantity());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...["La", "Bu", "Bu", "Baby", "Three"].map((type) {
                              return ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: type == "Baby"
                                      ? getColorSkin().primaryRed600
                                      : getColorSkin().primaryRed50,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(16),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: type == "Baby"
                                        ? Colors.white
                                        : getColorSkin().primaryRed950,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          AppLocalizations.of(context)!.description,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          blindBox?.description ??
                              'Không có mô tả cho sản phẩm này',
                          style: TextStyle(color: getColorSkin().grey),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(AppLocalizations.of(context)!.readMore,
                              style: TextStyle(
                                  color: getColorSkin().primaryRed950)),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: getColorSkin().white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final product = CartItem(
                            id: blindBoxId,
                            productName: blindBox?.name ?? 'Unnamed Box',
                            price: blindBox?.skus.map((sku) => sku.price).first ?? 0,
                            image: blindBox?.images.first.imageUrl ?? '',
                            quantity: state.quantity,
                          );
                          cartCubit.addToCart(product);
                          // context.push('/cart');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.addToCart,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getColorSkin().white,
                          side: BorderSide(color: getColorSkin().primaryRed200),
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.addToCart,
                          style: TextStyle(color: getColorSkin().primaryRed950),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/checkout');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getColorSkin().primaryRed650,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.shopNow,
                          style: TextStyle(color: getColorSkin().white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
