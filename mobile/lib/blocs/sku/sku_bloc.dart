import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/sku/sku_event.dart';
import 'package:mobile/blocs/sku/sku_state.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/repositories/image_repository.dart';
import 'package:mobile/data/repositories/sku_repository.dart';
import 'package:openapi/api.dart';

import '../../data/models/image_model.dart';

@injectable
@lazySingleton
class StockKeepingUnitsBloc extends Bloc<StockKeepingUnitEvent, StockKeepingUnitsState> {
  final SkuRepository _skuRepository;
  final ImageRepository _imageRepository;
  final PagingController<int, StockKeepingUnitModel> pagingController;

  SkuPaginationState _paginationState;
  SkuDataState _dataState;

  StockKeepingUnitsBloc(
      this._skuRepository,
      this._imageRepository,
      ) : _paginationState = SkuPaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const SkuDataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(SkuLoadingState()) {
    pagingController.addPageRequestListener((pageKey) {
      add(GetStockKeepingUnits(pageKey));
    });

    on<GetStockKeepingUnits>(_onGetStockKeepingUnits);
    on<GetNewReleaseStockKeepingUnits>(_onGetNewReleaseStockKeepingUnits);
    on<UpdateFilter>(_onUpdateFilter);
    on<RefreshStockKeepingUnits>(_onRefresh);
  }



    Future<void> _onGetStockKeepingUnits(
        GetStockKeepingUnits event,
        Emitter<StockKeepingUnitsState> emit,
        ) async {
      emit(SkuLoadingState(isLoading: true));

      try {
        final pageable = Pageable(
            page: event.pageKey,
            size: 20,
            sort: ['desc']
        );

        final stockKeepingUnits = await _skuRepository.getStockKeepingUnits(
            pageable,
            _dataState.filter ?? '',
            ''
        );

        final isLastPage = stockKeepingUnits.content.length < pageable.size;

        if (isLastPage) {
          pagingController.appendLastPage(stockKeepingUnits.content);
        } else {
          pagingController.appendPage(
              stockKeepingUnits.content,
              event.pageKey + 1
          );
        }

        _paginationState = _paginationState.copyWith(
          pageable: pageable,
          hasReachedEnd: isLastPage,
        );

        _dataState = _dataState.copyWith(skus: stockKeepingUnits);

        emit(_dataState);

      } catch (error) {
        pagingController.error = error;
        emit(SkuLoadingState(error: error.toString()));
      }
    }
  Future<void> _onGetNewReleaseStockKeepingUnits(
      GetNewReleaseStockKeepingUnits event,
      Emitter<StockKeepingUnitsState> emit,
      ) async {
    emit(SkuLoadingState(isLoading: true));

    try {
      final stockKeepingUnits = await _skuRepository.getStockKeepingUnits(
          _paginationState.pageable,
          _dataState.filter ?? '',
          ''
      );
      final ImageModel imageModel = await _imageRepository.getImageById(stockKeepingUnits.content[0].image?.imageId ?? 1);
      final String imageUrl = imageModel.imageUrl ?? '';
      _paginationState = _paginationState.copyWith(
        pageable: Pageable(
          page: _paginationState.pageable.page,
          size: 10,
          sort: ['createdAt,desc'],
        ),
      );

      _dataState = _dataState.copyWith(skus: stockKeepingUnits, imageUrl: imageUrl);
      emit(_dataState);
    } catch (e) {
      emit(SkuLoadingState(error: e.toString()));
    }
  }

  void _onUpdateFilter(
      UpdateFilter event,
      Emitter<StockKeepingUnitsState> emit,
      ) {
    _dataState = _dataState.copyWith(filter: event.filter);
    _paginationState = _paginationState.copyWith(
      pageable: Pageable(page: 1, size: 20),
    );
    pagingController.refresh();
  }

  void _onRefresh(
      RefreshStockKeepingUnits event,
      Emitter<StockKeepingUnitsState> emit,
      ) {
    pagingController.refresh();
    _paginationState = SkuPaginationState(
        pageable: Pageable(page: 0, size: 20, sort: ['desc'])
    );
  }

}