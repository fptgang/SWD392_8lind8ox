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
    final bool? hasReachedEnd;

    BlindBoxesState({
      Pageable? pageable,
      this.filter,
      this.search,
      this.isLoading,
      this.isOutOfStock,
      this.blindBoxes,
      this.error,
      this.hasReachedEnd,
    }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

    BlindBoxesState copyWith({
      Pageable? pageable,
      String? filter,
      String? search,
      bool? isLoading,
      bool? isOutOfStock,
      BlindBoxesResponseModel? blindBoxes,
      String? error,
      bool? hasReachedEnd,
    }) {
      return BlindBoxesState(
        pageable: pageable ?? this.pageable,
        filter: filter ?? this.filter,
        search: search ?? this.search,
        isLoading: isLoading ?? this.isLoading,
        isOutOfStock: isOutOfStock ?? this.isOutOfStock,
        blindBoxes: blindBoxes ?? this.blindBoxes,
        error: error ?? this.error,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      );
    }
  }
