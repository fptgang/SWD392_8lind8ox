import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/data/models/sets_response_model.dart';
import 'package:openapi/api.dart';

class SetState {
  Pageable pageable;
  final String? filter;
  final String? search;
  final bool? isLoading;
  final bool? isOutOfStock;
  final SetResponseModel? sets;
  final SetModel? set;
  final String? error;

  SetState({
    Pageable? pageable,
    this.filter,
    this.search,
    this.isLoading,
    this.isOutOfStock,
    this.sets,
    this.set,
    this.error,
  }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

  SetState copyWith({
    Pageable? pageable,
    String? filter,
    String? search,
    bool? isLoading,
    bool? isOutOfStock,
    SetResponseModel? sets,
    SetModel? set,
    String? error,
  }) {
    return SetState(
      pageable: pageable ?? this.pageable,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      isOutOfStock: isOutOfStock ?? this.isOutOfStock,
      sets: sets ?? this.sets,
      set: set ?? this.set,
      error: error ?? this.error,
    );
  }
}
