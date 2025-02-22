import 'package:mobile/data/models/generic_response_model.dart';
import 'package:openapi/api.dart';

class PaginationResponseMapper {
  static PaginationResponseGeneric<T> fromDTO<T, D>({
    required D dto,
    required T Function(dynamic) fromDTO,
  }) {
    if (dto is! GetTransactions200Response || dto is! GetBlindBoxes200Response || dto is! GetVouchers200Response) {
      throw ArgumentError('DTO must be a valid response type');
    }
    return PaginationResponseGeneric<T>(
      content: dto.content.map((e) => fromDTO(e)).toList(),
      totalElements: dto.totalElements ?? 0,
      totalPages: dto.totalPages ?? 0,
      last: dto.last ?? false,
      first: dto.first ?? false,
      numberOfElements: dto.numberOfElements ?? 0,
      empty: dto.empty ?? true,
    );
  }
}
