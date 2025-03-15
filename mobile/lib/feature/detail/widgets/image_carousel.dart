import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/feature/detail/blocs/blindbox_detail_event.dart';

import '../../../feature/detail/blocs/blindbox_detail_bloc.dart';
import '../../../feature/detail/blocs/blindbox_detail_state.dart';

class ImageCarousel extends StatefulWidget {
  final PageController pageController;
  final BlindBoxDataState state;

  const ImageCarousel({
    Key? key,
    required this.pageController,
    required this.state,
  }) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    // Set the initial page to match the selected image index in state
    if (widget.state.selectedImageIndex > 0 &&
        widget.pageController.hasClients &&
        (widget.state.images?.length ?? 0) > widget.state.selectedImageIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.pageController.jumpToPage(widget.state.selectedImageIndex);
      });
    }
  }

  @override
  void didUpdateWidget(ImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update page if the selected image index changed but the page hasn't
    if (oldWidget.state.selectedImageIndex != widget.state.selectedImageIndex &&
        widget.pageController.hasClients &&
        widget.pageController.page?.round() !=
            widget.state.selectedImageIndex) {
      widget.pageController.animateToPage(
        widget.state.selectedImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final images = widget.state.images ?? [];

    return SizedBox(
      height: 300.h,
      child: PageView.builder(
        controller: widget.pageController,
        onPageChanged: (index) {
          context.read<BlindBoxDetailBloc>().add(UpdateSelectedImage(index));
        },
        itemCount: images.isNotEmpty ? images.length : 1,
        itemBuilder: (context, index) {
          if (images.isNotEmpty) {
            final imageUrl = images[index];
            return Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/jpg/blind_box.jpg',
                  fit: BoxFit.contain,
                );
              },
            );
          } else {
            return Image.asset(
              'assets/jpg/blind_box.jpg',
              fit: BoxFit.contain,
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
