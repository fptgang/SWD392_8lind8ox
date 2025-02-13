
import 'package:mobile/data/models/sets_response_model.dart';
import 'package:openapi/api.dart';

import '../models/set_model.dart';

class SetMapper{
  static SetModel toModel(SetDto dto){
    return SetModel(
      setId: dto.setId,
      currentPrice: dto.currentPrice,
      imageIds: dto.imageIds,
      isVisible: dto.isVisible,
      slots: dto.slots,
      blindBox: dto.blindBox,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static SetResponseModel toModels(GetSets200Response dto) {
    return SetResponseModel(
      content: dto.content.map((e) => SetMapper.toModel(e)).toList(),
      totalElements: dto.totalElements!,
      totalPages: dto.totalPages!,
      last: dto.last!,
      first: dto.first!,
      numberOfElements: dto.numberOfElements!,
      empty: dto.empty!,
    );
  }
}