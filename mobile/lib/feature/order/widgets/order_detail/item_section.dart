import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:mobile/feature/order/blocs/video/video_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../blocs/video/video_event.dart';
import '../../blocs/video/video_state.dart';

class OrderItemsSection extends StatefulWidget {
  final List<OrderDetailModel> orderDetails;

  const OrderItemsSection({
    super.key,
    required this.orderDetails,
  });

  @override
  State<OrderItemsSection> createState() => _OrderItemsSectionState();
}

class _OrderItemsSectionState extends State<OrderItemsSection> {
  @override
  void initState() {
    super.initState();
    context.read<VideoBloc>().add(GetVideoStatus(slotId: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Order Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: getColorSkin().darkGrey,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.orderDetails.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final orderDetail = widget.orderDetails[index];
            return _OrderDetailItem(orderDetail: orderDetail);
          },
        ),
      ],
    );
  }
}

class _OrderDetailItem extends StatelessWidget {
  final OrderDetailModel orderDetail;

  const _OrderDetailItem({
    required this.orderDetail,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.network(
                orderDetail.sku?.image?.imageUrl ?? "",
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    color: getColorSkin().grey,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderDetail.sku?.blindBox?.name ?? 'Unknown Item',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Quantity: ${orderDetail.quantity}',
                  style: TextStyle(
                    fontSize: 14,
                    color: getColorSkin().grey,
                  ),
                ),
              ],
            ),
          ),
          if (orderDetail.slot != null)
            BlocBuilder<VideoBloc, VideoState>(
              builder: (context, state) {
                debugPrint('Video state: $state');
                debugPrint('OrderDetail slotId: ${orderDetail.slot?.slotId}');
                debugPrint('Videos slot Id: ${state.videos.map((video) => video.slotId).toList()}');
                final videos = state.videos.where((video) => 
                  video.slotId == orderDetail.slot?.slotId
                ).toList();

                if (videos.isNotEmpty) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.videocam),
                        onPressed: () => _showVideoDialog(context, videos),
                        tooltip: 'View Videos (${videos.length})',
                      ),
                      Text(
                        '${videos.length}',
                        style: TextStyle(
                          color: getColorSkin().primaryRed650,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price: \$${orderDetail.unitPrice?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(fontSize: 14),
              ),
              if (orderDetail.promotionalCampaign != null) ...[
                Text(
                  'Promotion: ${orderDetail.promotionalCampaign?.title ?? 'No Promotion'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: getColorSkin().accent,
                  ),
                ),
              ],
              Text(
                'Subtotal: \$${orderDetail.subTotal?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Final Total: \$${orderDetail.finalTotal?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showVideoDialog(BuildContext context, List<VideoModel> videos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Videos for ${orderDetail.sku?.name ?? 'Item'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return ListTile(
                      leading: const Icon(Icons.videocam),
                      title: Text('Video ${index + 1}'),
                      subtitle: Text(
                        video.isVerified == true ? 'Verified' : 'Pending',
                        style: TextStyle(
                          color: video.isVerified == true 
                            ? Colors.green 
                            : Colors.orange,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => VideoPlayerDialog(
                            videoUrl: video.url ?? '',
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VideoPlayerDialog extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerDialog({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Video Player',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          if (_isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                ],
              ),
            )
          else
             Center(
              child: CircularProgressIndicator(color: getColorSkin().primaryRed650,),
            ),
        ],
      ),
    );
  }
}