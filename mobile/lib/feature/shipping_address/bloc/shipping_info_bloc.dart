import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_event.dart';
import 'package:mobile/feature/shipping_address/bloc/shipping_info_state.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class ShippingInfoBloc extends Bloc<ShippingInfoEvent, ShippingInfoState> {
  final ShippingInfoRepository _shippingInfoRepository;
  ShippingInfoDataState _dataState;

  ShippingInfoBloc(this._shippingInfoRepository)
      : _dataState = const ShippingInfoDataState(),
        super(ShippingInfoLoadingState()) {
    on<GetShippingInfos>(_onGetShippingInfos);
    on<GetShippingInfoById>(_onGetShippingInfoById);
    on<CreateShippingInfo>(_onCreateShippingInfo);
    on<SelectShippingInfo>(_onSelectShippingInfo);
    // on<UpdateShippingInfo>(_onUpdateShippingInfo);
    // on<DeleteShippingInfo>(_onDeleteShippingInfo);
    // on<SetDefaultShippingInfo>(_onSetDefaultShippingInfo);
  }

  void _onSelectShippingInfo(
      SelectShippingInfo event, Emitter<ShippingInfoState> emit) {
    if (_dataState.shippingInfoResponseModel != null) {
      _dataState = _dataState.copyWith(
        selectedShippingInfo: event.shippingInfo,
      );
      emit(_dataState);
    }
  }

  Future<void> _onGetShippingInfos(
      GetShippingInfos event, Emitter<ShippingInfoState> emit) async {
    emit(ShippingInfoLoadingState(isLoading: true));

    try {
      debugPrint('Fetching all shipping infos...');
      final shippingInfos = await _shippingInfoRepository.getShippingInfos();
      debugPrint('Fetched shipping infos: $shippingInfos');

      // Set the first shipping info as selected by default
      ShippingInfoModel? selectedShippingInfo;
      if (shippingInfos.content.isNotEmpty) {
        selectedShippingInfo = shippingInfos.content.firstWhere(
              (info) => info.isVisible == true,
          orElse: () => shippingInfos.content.first,
        );
      }

      _dataState = _dataState.copyWith(
        shippingInfoResponseModel: shippingInfos,
        selectedShippingInfo: selectedShippingInfo,
      );

      emit(_dataState);
    } catch (error) {
      emit(ShippingInfoLoadingState(error: error.toString(), isLoading: false));
    }
  }

  Future<void> _onGetShippingInfoById(
      GetShippingInfoById event, Emitter<ShippingInfoState> emit) async {
    emit(ShippingInfoLoadingState(isLoading: true));

    try {
      final shippingInfo =
      await _shippingInfoRepository.getShippingInfoById(event.id);
      _dataState = _dataState.copyWith(shippingInfo: shippingInfo);
      emit(_dataState);
    } catch (e) {
      emit(ShippingInfoLoadingState(error: e.toString()));
    }
  }

  Future<void> _onCreateShippingInfo(CreateShippingInfo event, Emitter<ShippingInfoState> emit) async {
    emit(ShippingInfoLoadingState(isLoading: true));

    try {
      final createdShippingInfo = await _shippingInfoRepository.createShippingInfo(
        event.createShippingInfoModel,
      );
      debugPrint('Created shipping info: ${event.createShippingInfoModel}');

      // add(GetShippingInfos());

      _dataState = _dataState.copyWith(
        shippingInfo: createdShippingInfo,
        selectedShippingInfo: createdShippingInfo,
      );

      emit(_dataState);
    } catch (e, stackTrace) {
      debugPrint('Error creating shipping info: $e, stackTrace: $stackTrace');
      emit(ShippingInfoLoadingState(
          error: 'Failed to create shipping address: ${e.toString()}'));
    }
  }
  //
  // Future<void> _onUpdateShippingInfo(
  //     UpdateShippingInfo event, Emitter<ShippingInfoState> emit) async {
  //   emit(ShippingInfoLoadingState(isLoading: true));
  //
  //   try {
  //     // Update shipping info
  //     await _shippingInfoRepository.updateShippingInfo(
  //       event.id,
  //       event.updateShippingInfoModel,
  //     );
  //
  //     // Refresh the list
  //     add(GetShippingInfos());
  //
  //     emit(_dataState);
  //   } catch (e) {
  //     emit(ShippingInfoLoadingState(
  //         error: 'Failed to update shipping address: ${e.toString()}'));
  //   }
  // }

  // Future<void> _onDeleteShippingInfo(
  //     DeleteShippingInfo event, Emitter<ShippingInfoState> emit) async {
  //   emit(ShippingInfoLoadingState(isLoading: true));
  //
  //   try {
  //     // Delete shipping info
  //     await _shippingInfoRepository.deleteShippingInfo(event.id);
  //
  //     // Refresh the list
  //     add(GetShippingInfos());
  //
  //     emit(_dataState);
  //   } catch (e) {
  //     emit(ShippingInfoLoadingState(
  //         error: 'Failed to delete shipping address: ${e.toString()}'));
  //   }
  // }
  //
  // Future<void> _onSetDefaultShippingInfo(
  //     SetDefaultShippingInfo event, Emitter<ShippingInfoState> emit) async {
  //   emit(ShippingInfoLoadingState(isLoading: true));
  //
  //   try {
  //     // Set default shipping info
  //     await _shippingInfoRepository.setDefaultShippingInfo(event.id);
  //
  //     // Refresh the list
  //     add(GetShippingInfos());
  //
  //     emit(_dataState);
  //   } catch (e) {
  //     emit(ShippingInfoLoadingState(
  //         error: 'Failed to set default shipping address: ${e.toString()}'));
  //   }
  // }
}
