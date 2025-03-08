import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_state.dart';
import '../../../ui/core/theme/theme.dart';

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
    final blindBox = state.blindBox;
    
    if (blindBox.images == null || blindBox.images!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: blindBox.images?.length ?? 0,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final imageUrl = blindBox.images?[index].imageUrl ?? '';
          final isSelected = index == state.selectedImageIndex;
          
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
                backgroundColor: getColorSkin().lightGrey200,
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