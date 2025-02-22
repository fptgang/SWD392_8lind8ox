import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/voucher/voucher_event.dart';
import 'package:mobile/blocs/voucher/voucher_state.dart';
import 'package:mobile/data/repositories/voucher_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRepository _voucherRepository;

  VoucherBloc(this._voucherRepository)
      : super(VoucherState(pageable: Pageable(page: 1, size: 20))) {
    on<SelectVoucher>(_onSelectVoucher);
    on<GetVouchers>(_onGetVouchers);
    on<GetVoucherById>(_onGetVoucherById);
  }

  void _onSelectVoucher(
      SelectVoucher event,
      Emitter<VoucherState> emit,
      ) {
    emit(state.copyWith(filter: event.vouchers));
  }

  Future<void> _onGetVouchers(
      GetVouchers event,
      Emitter<VoucherState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final vouchers = await _voucherRepository.getVouchers(
          state.pageable,
          state.filter ?? '',
          state.search ?? ''
      );
      debugPrint('vouchers: $vouchers');

      emit(state.copyWith(
        voucherResponseModel: vouchers,
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

  Future<void> _onGetVoucherById(
      GetVoucherById event,
      Emitter<VoucherState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final voucher = await _voucherRepository.getVoucherById(event.id);
      emit(state.copyWith(
          voucher: voucher,
          isLoading: false
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}