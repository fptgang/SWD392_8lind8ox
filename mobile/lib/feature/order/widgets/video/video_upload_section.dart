import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/order/blocs/video/video_bloc.dart';
import 'package:mobile/feature/order/blocs/video/video_event.dart';
import 'package:mobile/feature/order/blocs/video/video_state.dart';
import 'package:path/path.dart' as path;

class VideoUploadSection extends StatefulWidget {
  final int? accountId;
  final int? slotId;

  const VideoUploadSection({
    super.key,
    this.accountId,
    this.slotId,
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

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );

    if (video != null) {
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
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isUploading && _uploadProgress < 1.0) {
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
    if (_selectedVideo != null) {
      final fileName = path.basename(_selectedVideo!.path);

      setState(() {
        _isUploading = false;
        _recentUploads.insert(0, fileName);
        if (_recentUploads.length > 5) {
          _recentUploads = _recentUploads.sublist(0, 5);
        }
      });

      // This would be the actual upload to the server
      _uploadVideoToServer();
    }
  }

  Future<void> _uploadVideoToServer() async {
    if (_selectedVideo == null) return;

    try {
      final videoBytes = await _selectedVideo!.readAsBytes();
      final fileName = path.basename(_selectedVideo!.path);

      final multipartFile = http.MultipartFile.fromBytes(
        'videoBlob',
        videoBytes,
        filename: fileName,
      );

      context.read<VideoBloc>().add(
        UploadVideo(
          accountId: widget.accountId,
          slotId: widget.slotId,
          videoBlob: multipartFile,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload: $e')),
      );
    }
  }

  void _cancelUpload() {
    setState(() {
      _isUploading = false;
      _selectedVideo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        // Handle loading state
        if (state is VideoLoadingState && state.isLoading) {
          return Center(child: CircularProgressIndicator(color: getColorSkin().primaryRed650,));
        }

        if (state is VideoLoadingState && state.error != null) {
          return Center(
            child: Text(
              'Error: ${state.error}',
              style: TextStyle(color: getColorSkin().errorRed),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Upload Video',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: getColorSkin().darkGrey,
                ),
              ),
            ),

            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: getColorSkin().accent,
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
                    color: getColorSkin().accent,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload your video here',
                    style: TextStyle(
                      color: getColorSkin().accent,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: _pickVideo,
                    child: Text(
                      'Browse',
                      style: TextStyle(
                        color: getColorSkin().accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

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
                      color: getColorSkin().grey,
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
                      color: getColorSkin().lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.videocam,
                      color: Colors.white,
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
                        color: getColorSkin().grey,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.pause,
                            color: getColorSkin().grey,
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

            // Recent uploads section
            if (_recentUploads.isNotEmpty || (state is VideoDataState && state.videoResponseModel?.content.isNotEmpty == true)) ...[
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent uploaded',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: getColorSkin().darkGrey,
                      ),
                    ),
                    if (state is VideoDataState && state.videoResponseModel != null)
                      Text(
                        '${state.videoResponseModel?.content.length ?? 0} items',
                        style: TextStyle(
                          fontSize: 14,
                          color: getColorSkin().grey,
                        ),
                      ),
                  ],
                ),
              ),

              if (state is VideoDataState && state.videoResponseModel?.content.isNotEmpty == true)
                ...state.videoResponseModel!.content.map((video) => _buildRecentVideoItem(
                    video.url ?? 'Unknown',
                    video.createdAt?.toString().substring(0, 10) ?? '',
                    video.videoId
                )),

              ...(_recentUploads.where((fileName) {
                if (state is VideoDataState && state.videoResponseModel?.content.isNotEmpty == true) {
                  return !state.videoResponseModel!.content.any((v) => v.url == fileName);
                }
                return true;
              })).map((fileName) => _buildRecentVideoItem(
                  fileName,
                  'Just now',
                  null
              )),
            ],
          ],
        );
      },
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
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: getColorSkin().grey,
            ),
            onPressed: videoId != null ? () {
              _showDeleteConfirmationDialog(context, videoId);
            } : null,
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int videoId) {
    showDialog(
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
              'Are you sure you want to delete this video? This action cannot be undone.'),
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
                context.read<VideoBloc>().add(DeleteVideo(videoId));
                Navigator.pop(context);

                // Show deletion in progress feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleting video...'),
                    duration: const Duration(seconds: 2),
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