

import 'package:mobile/data/mapper/account_mapper.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:openapi/api.dart';

class VideoMapper{
  static VideoModel toModel(VideoDto dto){
    return VideoModel(
      videoId: dto.videoId!,
      account: AccountMapper.toModel(dto.account ?? AccountDto()),
      url: dto.url,
      description: dto.description,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
      isVisible: dto.isVisible!,
      isVerified: dto.isVerified,
      slotId: dto.slotId,
    );
  }
}