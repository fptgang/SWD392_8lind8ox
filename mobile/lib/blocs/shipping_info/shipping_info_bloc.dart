import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/shipping_info/shipping_info_event.dart';
import 'package:mobile/blocs/shipping_info/shipping_info_state.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:openapi/api.dart';
import 'package:hive/hive.dart';

@injectable
@lazySingleton
class ShippingInfoBloc extends Bloc<ShippingInfoEvent, ShippingInfoState> {
  final ShippingInfoRepository _shippingInfoRepository;
  final PagingController<int, ShippingInfoModel> pagingController;

  ShippingInfoPaginationState _paginationState;
  ShippingInfoDataState _dataState;

  ShippingInfoBloc(this._shippingInfoRepository)
      : _paginationState = ShippingInfoPaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const ShippingInfoDataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(ShippingInfoLoadingState()) {
    on<GetShippingInfos>(_onGetShippingInfos);
    on<GetShippingInfoById>(_onGetShippingInfoById);
    on<CreateShippingInfo>(_onCreateShippingInfo);
    // on<SelectShippingInfo>(_onSelectShippingInfo);
  }

  // void _onSelectShippingInfo(
  //     SelectShippingInfo event,
  //     Emitter<ShippingInfoState> emit,
  //     ) {
  //   _dataState = _dataState.copyWith(filter: event.shippingInfo);
  //   emit(_dataState);
  // }

  Future<void> _onGetShippingInfos(
      GetShippingInfos event,
      Emitter<ShippingInfoState> emit,
      ) async {
    emit(ShippingInfoLoadingState(isLoading: true));

    try {
      final pageable = Pageable(
          page: event.pageKey,
          size: 20,
          sort: ['desc']
      );

      final shippingInfos = await _shippingInfoRepository.getShippingInfos(
          pageable,
          _dataState.filter ?? '',
          _dataState.search ?? ''
      );
      debugPrint('shippingInfos: $shippingInfos');

      final isLastPage = shippingInfos.content.length < pageable.size;

      if (isLastPage) {
        pagingController.appendLastPage(shippingInfos.content);
      } else {
        pagingController.appendPage(
            shippingInfos.content,
            event.pageKey + 1
        );
      }

      _paginationState = _paginationState.copyWith(
        pageable: pageable,
        hasReachedEnd: isLastPage,
      );

      _dataState = _dataState.copyWith(shippingInfoResponseModel: shippingInfos);
      emit(_dataState);
    } catch (error) {
      pagingController.error = error;
      emit(ShippingInfoLoadingState(error: error.toString(), isLoading: false));
    }
  }

  Future<void> _onGetShippingInfoById(
      GetShippingInfoById event,
      Emitter<ShippingInfoState> emit,
      ) async {
    emit(ShippingInfoLoadingState(isLoading: true));

    try {
      final shippingInfo = await _shippingInfoRepository.getShippingInfoById(event.id);
      _dataState = _dataState.copyWith(shippingInfo: shippingInfo);
      emit(_dataState);
    } catch (e) {
      emit(ShippingInfoLoadingState(error: e.toString()));
    }
  }

  // Add handler for creating shipping info
  Future<void> _onCreateShippingInfo(
    CreateShippingInfo event,
    Emitter<ShippingInfoState> emit,
  ) async {
    emit(ShippingInfoLoadingState(isLoading: true));

    try {
      final createdShippingInfo = await _shippingInfoRepository.createShippingInfo(
        event.shippingInfoDto,
      );
      _dataState = _dataState.copyWith(shippingInfo: createdShippingInfo);
      debugPrint('token from shipping info bloc: ${Hive.box('authentication').get('loginToken')}');
      debugPrint('Successfully created shipping info: $createdShippingInfo');
      emit(_dataState);
    } catch (e, stackTrace) {
      debugPrint('Error creating shipping info: $e, stackTrace: $stackTrace');
      emit(ShippingInfoLoadingState(error: 'Failed to create shipping address: ${e.toString()}'));
    }
  }
}