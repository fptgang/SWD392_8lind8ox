import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:openapi/api.dart';
import 'package:http/http.dart';
import 'package:http/src/multipart_file.dart';

@injectable
@Singleton()
abstract class VideoRepository {
  Future<VideoModel?> getVideoById(int id);
  Future<VideoModel> uploadVideo(int accountID, int slotId, MultipartFile videoBlob, bool isVisible);
  Future<PaginationResponseGeneric<VideoModel>> getVideos(Pageable pageable, String filter, String search);
  Future<void> deleteVideo(int id);
  Future<List<VideoModel>> getVideosByOrderDetailId(int orderDetailId);
  // Future<List<VideoModel>> getAllVideos();
}