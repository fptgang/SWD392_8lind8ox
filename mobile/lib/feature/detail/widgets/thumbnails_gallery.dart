import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';

import '../blocs/blindbox_detail_state.dart';

class ThumbnailsGallery extends StatelessWidget {
  final PageController pageController;
  final BlindBoxDataState state;

  const ThumbnailsGallery({
    Key? key,
    required this.pageController,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the combined images list from the state
    final images = state.images;

    if (images == null || images.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: images.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final imageUrl = images[index];
          final isSelected = index == state.selectedImageIndex;

          // Highlight the selected image (first one should be SKU image)
          final bool isSkuImage = index == 0 &&
              state.skuImages != null &&
              state.skuImages!.isNotEmpty;

          return GestureDetector(
            onTap: () {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: getColorSkin().primaryRed650, width: 2)
                    : null,
              ),
              padding: isSelected ? const EdgeInsets.all(2) : EdgeInsets.zero,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: isSkuImage && isSelected
                    ? getColorSkin()
                        .primaryRed100 // Special highlight for selected SKU image
                    : getColorSkin().lightGrey200,
                child: (imageUrl.isNotEmpty)
                    ? ClipOval(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/jpg/blind_box.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )
                    : Image.asset('assets/jpg/blind_box.jpg'),
              ),
            ),
          );
        },
      ),
    );
  }
}
