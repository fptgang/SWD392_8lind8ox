import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/data/repositories/voucher_repository.dart';
import 'package:mobile/feature/checkout/blocs/voucher/voucher_event.dart';
import 'package:mobile/feature/checkout/blocs/voucher/voucher_state.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRepository _voucherRepository;
  final PagingController<int, VoucherModel> pagingController;

  VoucherPaginationState _paginationState;
  VoucherDataState _dataState;

  VoucherBloc(this._voucherRepository)
      : _paginationState = VoucherPaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const VoucherDataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(VoucherLoadingState()) {
    on<SelectVoucher>(_onSelectVoucher);
    on<GetVouchers>(_onGetVouchers);
    on<GetVoucherById>(_onGetVoucherById);
    on<GetVoucherByCode>(_onGetVoucherByCode);
  }

  void _onSelectVoucher(
      SelectVoucher event,
      Emitter<VoucherState> emit,
      ) {
    _dataState = _dataState.copyWith(filter: event.vouchers);
    emit(_dataState);
  }

  Future<void> _onGetVouchers(
      GetVouchers event,
      Emitter<VoucherState> emit,
      ) async {
    emit(VoucherLoadingState(isLoading: true));

    try {
      final vouchers = await _voucherRepository.getVouchers(
          _paginationState.pageable,
          _dataState.filter ?? '',
          _dataState.search ?? ''
      );
      debugPrint('vouchers: $vouchers');

      _paginationState = _paginationState.copyWith(
        pageable: Pageable(
          page: _paginationState.pageable.page + 1,
          size: 20,
        ),
      );

      _dataState = _dataState.copyWith(voucherResponseModel: vouchers);
      emit(_dataState);
    } catch (e) {
      emit(VoucherLoadingState(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onGetVoucherById(
      GetVoucherById event,
      Emitter<VoucherState> emit,
      ) async {
    emit(VoucherLoadingState(isLoading: true));

    try {
      final voucher = await _voucherRepository.getVoucherById(event.id);
      _dataState = _dataState.copyWith(voucher: voucher);
      emit(_dataState);
    } catch (e) {
      emit(VoucherLoadingState(error: e.toString()));
    }
  }

  void _onGetVoucherByCode(
      GetVoucherByCode event,
      Emitter<VoucherState> emit,
      ) async {
    emit(VoucherLoadingState(isLoading: true));

    try {
      final voucher = await _voucherRepository.getVoucherById(event.id);
      _dataState = _dataState.copyWith(voucher: voucher);
      emit(_dataState);
    } catch (e) {
      emit(VoucherLoadingState(error: e.toString(), isLoading: false));
    }
  }
}