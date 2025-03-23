import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_event.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_state.dart';

@injectable
@lazySingleton
class ShippingInfoBloc extends Bloc<ShippingInfoEvent, ShippingInfoState> {
  final ShippingInfoRepository _shippingInfoRepository;
  final AccountRepository _accountRepository;
  ShippingInfoDataState _dataState;

  ShippingInfoBloc(this._shippingInfoRepository)
      : _accountRepository = getIt<AccountRepository>(),
        _dataState = const ShippingInfoDataState(),
        super(ShippingInfoLoadingState()) {
    on<GetShippingInfos>(_onGetShippingInfos);
    on<GetShippingInfoById>(_onGetDefaultShippingInfo);
    on<CreateShippingInfo>(_onCreateShippingInfo);
    on<SelectShippingInfo>(_onSelectShippingInfo);
    on<UpdateShippingInfo>(_onUpdateShippingInfo);
    on<DeleteShippingInfo>(_onDeleteShippingInfo);
    on<SetDefaultShippingInfo>(_onSetDefaultShippingInfo);
    on<RefreshShippingInfos>(_onRefreshShippingInfos);
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
      debugPrint('Fetched shipping infos hehe: $shippingInfos');



      _dataState = _dataState.copyWith(
        shippingInfoResponseModel: shippingInfos,
      );
      emit(ShippingInfoLoadingState(isLoading: false));
      emit(_dataState);
    } catch (error) {
      emit(ShippingInfoLoadingState(error: error.toString(), isLoading: false));
    }
  }

  Future<void> _onGetDefaultShippingInfo(
      GetShippingInfoById event, Emitter<ShippingInfoState> emit) async {
    emit(ShippingInfoLoadingState(isLoading: true));

    try {
      final shippingInfo = await _accountRepository.getUser();
      _dataState = _dataState.copyWith(shippingInfo: shippingInfo.defaultShippingInfo);
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

  Future<void> _onUpdateShippingInfo(
    UpdateShippingInfo event,
    Emitter<ShippingInfoState> emit,
  ) async {
    // Implement update logic
  }

  Future<void> _onDeleteShippingInfo(
    DeleteShippingInfo event,
    Emitter<ShippingInfoState> emit,
  ) async {
    // Implement delete logic
  }

  Future<void> _onSetDefaultShippingInfo(
    SetDefaultShippingInfo event,
    Emitter<ShippingInfoState> emit,
  ) async {
    try {
      if (state is ShippingInfoDataState) {
        final currentState = state as ShippingInfoDataState;
        emit(ShippingInfoLoadingState(isLoading: true));
        
        // Set this address as default (implementation depends on your API)
        // await _shippingInfoRepository.setDefaultShippingInfo(event.shippingInfo.shippingInfoId);
        
        // After setting default, refresh the list
        add(RefreshShippingInfos());
      }
    } catch (e) {
      debugPrint('Error setting default shipping info: $e');
      emit(ShippingInfoLoadingState(error: e.toString()));
    }
  }

  Future<void> _onRefreshShippingInfos(
    RefreshShippingInfos event,
    Emitter<ShippingInfoState> emit,
  ) async {
    add(GetShippingInfos());
  }
}
