import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:mobile/feature/order/blocs/video/video_bloc.dart';
import 'package:mobile/feature/order/blocs/video/video_event.dart';
import 'package:mobile/feature/order/blocs/video/video_state.dart';
import 'package:mobile/feature/order/widgets/order_detail/item_section.dart';
import 'package:path/path.dart' as path;

class VideoUploadSection extends StatefulWidget {
  final int? accountId;
  final int? slotId;
  final int? orderDetailId;

  const VideoUploadSection({
    super.key,
    this.accountId,
    this.slotId,
    this.orderDetailId,
  });

  @override
  State<VideoUploadSection> createState() => _VideoUploadSectionState();
}

class _VideoUploadSectionState extends State<VideoUploadSection> {
  File? _selectedVideo;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _remainingTime = "";
  List<String> _recentUploads = [];
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoStatus();
  }

  void _initializeVideoStatus() {
    if (!_isDisposed && widget.slotId != null) {
      final videoBloc = context.read<VideoBloc>();
      if (!videoBloc.isClosed) {
        videoBloc.add(GetVideoStatus(
          slotId: widget.slotId.toString(),
        ));
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _pickVideo() async {
    if (widget.slotId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No slot available for video upload'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );

    if (video != null && !_isDisposed) {
      setState(() {
        _selectedVideo = File(video.path);
        _isUploading = true;
        _uploadProgress = 0.0;
        _remainingTime = "Calculating...";

        _simulateUploadProgress();
      });
    }
  }

  void _simulateUploadProgress() {
    if (_isDisposed) return;
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isUploading && _uploadProgress < 1.0 && !_isDisposed) {
        setState(() {
          _uploadProgress += 0.01;
          final remainingSecs = ((1.0 - _uploadProgress) * 100).toInt();
          _remainingTime = "$remainingSecs sec";
        });

        if (_uploadProgress < 1.0) {
          _simulateUploadProgress();
        } else {
          _completeUpload();
        }
      }
    });
  }

  void _completeUpload() {
    if (_isDisposed) return;
    
    if (_selectedVideo != null && widget.orderDetailId != null && widget.slotId != null) {
      final fileName = path.basename(_selectedVideo!.path);

      setState(() {
        _isUploading = false;
        _recentUploads.insert(0, fileName);
        if (_recentUploads.length > 5) {
          _recentUploads = _recentUploads.sublist(0, 5);
        }
      });

      _uploadVideoToServer();
    }
  }

  Future<void> _uploadVideoToServer() async {
    if (_isDisposed) return;
    
    if (_selectedVideo == null ||
        widget.accountId == null || 
        widget.slotId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing required information for video upload'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final videoBloc = context.read<VideoBloc>();
      if (!videoBloc.isClosed) {
        videoBloc.add(
          UploadVideo(
            accountId: widget.accountId!,
            file: XFile(_selectedVideo!.path),
            slotId: widget.slotId!,
          ),
        );
      }
    } catch (e) {
      if (!_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _cancelUpload() {
    if (_isDisposed) return;
    
    setState(() {
      _isUploading = false;
      _selectedVideo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slotId == null) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator(color: getColorSkin().primaryRed650));
        }

        if (state.error != null) {
          if (state.error!.contains('existingVideo is null')) {
            return _buildUploadSection();
          }
          
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: TextStyle(color: getColorSkin().errorRed),
            ),
          );
        }

        // Filter videos by slotId
        final slotVideos = state.videos.where((video) => 
          video.slotId == widget.slotId
        ).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Upload Video',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: getColorSkin().darkGrey,
                ),
              ),
            ),

            if (slotVideos.isEmpty && _recentUploads.isEmpty)
              _buildUploadSection(),

            if (_isUploading && _selectedVideo != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Uploading video',
                      style: TextStyle(
                        fontSize: 14,
                        color: getColorSkin().darkGrey,
                      ),
                    ),
                    Icon(
                      Icons.fullscreen,
                      color: getColorSkin().primaryRed650,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: getColorSkin().white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.videocam,
                      color: getColorSkin().black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: getColorSkin().lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(getColorSkin().accent),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time remaining: $_remainingTime',
                      style: TextStyle(
                        fontSize: 12,
                        color: getColorSkin().primaryRed650,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.pause,
                            color: getColorSkin().primaryRed650,
                            size: 20,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: getColorSkin().errorRed,
                            size: 20,
                          ),
                          onPressed: _cancelUpload,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            if (slotVideos.isNotEmpty || _recentUploads.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Uploaded Videos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: getColorSkin().darkGrey,
                      ),
                    ),
                    Text(
                      '${slotVideos.length} item${slotVideos.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: getColorSkin().grey,
                      ),
                    ),
                  ],
                ),
              ),

              ...slotVideos.map((video) => _buildVideoItem(
                video,
                onDelete: () => _showDeleteConfirmationDialog(context, video.videoId!),
              )),

              ..._recentUploads.map((fileName) => _buildRecentVideoItem(
                fileName,
                'Just now',
                null,
              )),
            ],
          ],
        );
      },
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: getColorSkin().primaryRed650,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 40,
            color: getColorSkin().primaryRed650,
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your video here',
            style: TextStyle(
              color: getColorSkin().primaryRed650,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: _pickVideo,
            child: Text(
              'Browse',
              style: TextStyle(
                color: getColorSkin().primaryRed650,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItem(VideoModel video, {VoidCallback? onDelete}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return VideoPlayerDialog(videoUrl: video.url ?? '');
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: getColorSkin().lightBlue200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.videocam,
                color: getColorSkin().deepBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.url?.split('/').last ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '~10 MB',
                    style: TextStyle(
                      fontSize: 12,
                      color: getColorSkin().grey,
                    ),
                  ),
                  Text(
                    video.createdAt?.toString().substring(0, 10) ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: getColorSkin().grey,
                    ),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: getColorSkin().grey,
                ),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentVideoItem(String fileName, String date, int? videoId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: getColorSkin().lightBlue200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.videocam,
              color: getColorSkin().deepBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '~10 MB',
                  style: TextStyle(
                    fontSize: 12,
                    color: getColorSkin().grey,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: getColorSkin().grey,
                  ),
                ),
              ],
            ),
          ),
          if (videoId != null)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: getColorSkin().grey,
              ),
              onPressed: () => _showDeleteConfirmationDialog(context, videoId),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int videoId) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Video',
            style: TextStyle(
              color: getColorSkin().primaryRed800,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this video? This action cannot be undone.',
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
                final videoBloc = context.read<VideoBloc>();
                if (!videoBloc.isClosed) {
                  videoBloc.add(DeleteVideo(
                    videoId: videoId,
                    slotId: widget.slotId!,
                  ));
                }
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Deleting video...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyle(color: getColorSkin().errorRed),
              ),
            ),
          ],
        );
      },
    );
  }
}