import 'package:mobile/data/models/generic_response_model.dart';
import 'package:openapi/api.dart';

class PaginationResponseMapper {
  static PaginationResponseGeneric<T> toModel<T, D>({
    required D dto,
    required T Function(dynamic) fromDTO,
  }) {
    // Check if dto is one of the valid response types
    if (!(dto is GetTransactions200Response || dto is GetBlindBoxes200Response || dto is GetVouchers200Response)) {
      throw ArgumentError('DTO must be a valid response type');
    }
    
    // Use null-safe access with null-aware operators
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
