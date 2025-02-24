import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/shipping_info/shipping_info_event.dart';
import 'package:mobile/blocs/shipping_info/shipping_info_state.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class ShippingInfoBloc extends Bloc<ShippingInfoEvent, ShippingInfoState> {
  final ShippingInfoRepository _shippingInfoRepository;

  ShippingInfoBloc(this._shippingInfoRepository)
      : super(ShippingInfoState(pageable: Pageable(page: 1, size: 20))) {
    on<GetShippingInfos>(_onGetShippingInfos);
    on<GetShippingInfoById>(_onGetShippingInfoById);
  }

  Future<void> _onGetShippingInfos(
      GetShippingInfos event,
      Emitter<ShippingInfoState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final shippingInfos = await _shippingInfoRepository.getShippingInfos(
          state.pageable,
          state.filter ?? '',
          state.search ?? ''
      );
      debugPrint('shippingInfo: $shippingInfos');

      emit(state.copyWith(
        shippingInfoResponseModel: shippingInfos,
        isLoading: false,
        pageable: Pageable(
          page: state.pageable.page,
          size: 20,
        ),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onGetShippingInfoById(
      GetShippingInfoById event,
      Emitter<ShippingInfoState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final shippingInfo = await _shippingInfoRepository.getShippingInfoById(event.id);
      emit(state.copyWith(
          shippingInfo: shippingInfo,
          isLoading: false
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}