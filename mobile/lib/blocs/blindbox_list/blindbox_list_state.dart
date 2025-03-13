  import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:openapi/api.dart';


  abstract class BlindBoxesState {}

  class PaginationState implements BlindBoxesState {
    final Pageable pageable;
    final bool hasReachedEnd;

    const PaginationState({
      required this.pageable,
      this.hasReachedEnd = false,
    });

    PaginationState copyWith({
      Pageable? pageable,
      bool? hasReachedEnd,
    }) {
      return PaginationState(
        pageable: pageable ?? this.pageable,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      );
    }
  }

  class LoadingState implements BlindBoxesState{
    final bool isLoading;
    final String? error;
    final bool isOutOfStock;

    const LoadingState({
      this.isLoading = false,
      this.error,
      this.isOutOfStock = false,
    });

    LoadingState copyWith({
      bool? isLoading,
      String? error,
      bool? isOutOfStock,
    }) {
      return LoadingState(
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        isOutOfStock: isOutOfStock ?? this.isOutOfStock,
      );
    }
  }

  class DataState implements BlindBoxesState{
    final PaginationResponseGeneric<BlindBoxModel>? blindBoxes;
    final String? filter;

    const DataState({
      this.blindBoxes,
      this.filter,
    });

    DataState copyWith({
      PaginationResponseGeneric<BlindBoxModel>? blindBoxes,
      String? filter
    }) {
      return DataState(
        blindBoxes: blindBoxes ?? this.blindBoxes,
        filter: filter ?? this.filter,
      );
    }
  }

  // class BlindBoxesState {
  //   final PaginationState paginationState;
  //   final SearchState searchState;
  //   final LoadingState loadingState;
  //   final DataState dataState;
  //
  //   const BlindBoxesState({
  //     required this.paginationState,
  //     this.searchState = const SearchState(),
  //     this.loadingState = const LoadingState(),
  //     this.dataState = const DataState(),
  //   });
  //
  //   BlindBoxesState copyWith({
  //     PaginationState? paginationState,
  //     SearchState? searchState,
  //     LoadingState? loadingState,
  //     DataState? dataState,
  //   }) {
  //     return BlindBoxesState(
  //       paginationState: paginationState ?? this.paginationState,
  //       searchState: searchState ?? this.searchState,
  //       loadingState: loadingState ?? this.loadingState,
  //       dataState: dataState ?? this.dataState,
  //     );
  //   }
  // }

  // class BlindBoxesState {
  //   Pageable pageable; /
  //   final String? filter;/
  //   final String? search;/
  //   final bool? isLoading;/
  //   final bool? isOutOfStock;/
  //   final BlindBoxesResponseModel? blindBoxes;
  //   final String? error;/
  //   final bool? hasReachedEnd;/
  //
  //   BlindBoxesState({
  //     Pageable? pageable,
  //     this.filter,
  //     this.search,
  //     this.isLoading,
  //     this.isOutOfStock,
  //     this.blindBoxes,
  //     this.error,
  //     this.hasReachedEnd,
  //   }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);
  //
  //   BlindBoxesState copyWith({
  //     Pageable? pageable,
  //     String? filter,
  //     String? search,
  //     bool? isLoading,
  //     bool? isOutOfStock,
  //     BlindBoxesResponseModel? blindBoxes,
  //     String? error,
  //     bool? hasReachedEnd,
  //   }) {
  //     return BlindBoxesState(
  //       pageable: pageable ?? this.pageable,
  //       filter: filter ?? this.filter,
  //       search: search ?? this.search,
  //       isLoading: isLoading ?? this.isLoading,
  //       isOutOfStock: isOutOfStock ?? this.isOutOfStock,
  //       blindBoxes: blindBoxes ?? this.blindBoxes,
  //       error: error ?? this.error,
  //       hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
  //     );
  //   }
  // }
