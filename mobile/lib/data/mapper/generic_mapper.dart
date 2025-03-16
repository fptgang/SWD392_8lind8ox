import 'package:mobile/data/models/generic_response_model.dart';

class PaginationResponseMapper {
  static PaginationResponseGeneric<T> toModel<T, D>({
    required D dto,
    required T Function(dynamic) fromDTO,
  }) {
    return PaginationResponseGeneric<T>(
      content: (dto as dynamic).content?.map<T>((e) => fromDTO(e))?.toList() ?? [],
      totalElements: (dto as dynamic).totalElements ?? 0,
      totalPages: (dto as dynamic).totalPages ?? 0,
      last: (dto as dynamic).last ?? false,
      first: (dto as dynamic).first ?? false,
      numberOfElements: (dto as dynamic).numberOfElements ?? 0,
      empty: (dto as dynamic).empty ?? true,
    );
  }
}
