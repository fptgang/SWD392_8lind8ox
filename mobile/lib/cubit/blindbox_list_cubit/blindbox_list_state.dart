import 'package:mobile/data/models/blindbox_model.dart';
import 'package:openapi/api.dart';

import '../../data/models/blindboxes_response_model.dart';

class BlindBoxesState {
  Pageable pageable;
  final String? filter;
  final String? search;
  final bool? isLoading;
  final bool? isOutOfStock;
  final BlindBoxesResponseModel? blindBoxes;
  final String? error;

  BlindBoxesState({
    Pageable? pageable,
    this.filter,
    this.search,
    this.isLoading,
    this.isOutOfStock,
    this.blindBoxes,
    this.error,
  }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

  BlindBoxesState copyWith({
    Pageable? pageable,
    String? filter,
    String? search,
    bool? isLoading,
    bool? isOutOfStock,
    BlindBoxesResponseModel? blindBoxes,
    String? error,
  }) {
    return BlindBoxesState(
      pageable: pageable ?? this.pageable,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      isOutOfStock: isOutOfStock ?? this.isOutOfStock,
      blindBoxes: blindBoxes ?? this.blindBoxes,
      error: error ?? this.error,
    );
  }
}
