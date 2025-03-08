import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/data/models/sets_response_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:openapi/api.dart';

abstract class SetState {}

class SetPaginationState implements SetState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const SetPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  SetPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return SetPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class SetLoadingState implements SetState {
  final bool isLoading;
  final bool isOutOfStock;
  final String? error;

  const SetLoadingState({
    this.isLoading = false,
    this.isOutOfStock = false,
    this.error,
  });

  SetLoadingState copyWith({
    bool? isLoading,
    bool? isOutOfStock,
    String? error,
  }) {
    return SetLoadingState(
      isLoading: isLoading ?? this.isLoading,
      isOutOfStock: isOutOfStock ?? this.isOutOfStock,
      error: error ?? this.error,
    );
  }
}

class SetDataState implements SetState {
  final PaginationResponseGeneric<SetModel>? sets;
  final SetModel? set;
  final String? filter;
  final String? search;
  final List<StockKeepingUnitModel>? skus;
  final StockKeepingUnitModel? selectedSku;
  final Map<int, String>? setImages; // Maps set ID to primary image URL

  const SetDataState({
    this.sets,
    this.set,
    this.filter,
    this.search,
    this.skus,
    this.selectedSku,
    this.setImages,
  });

  SetDataState copyWith({
    PaginationResponseGeneric<SetModel>? sets,
    SetModel? set,
    String? filter,
    String? search,
    List<StockKeepingUnitModel>? skus,
    StockKeepingUnitModel? selectedSku,
    Map<int, String>? setImages,
  }) {
    return SetDataState(
      sets: sets ?? this.sets,
      set: set ?? this.set,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      skus: skus ?? this.skus,
      selectedSku: selectedSku ?? this.selectedSku,
      setImages: setImages ?? this.setImages,
    );
  }
  
  // Helper method to get the image URL for a specific set
  String? getSetImageUrl(int setId) {
    return setImages?[setId];
  }
}