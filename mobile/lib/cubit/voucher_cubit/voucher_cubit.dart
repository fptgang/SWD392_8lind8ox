import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/cubit/voucher_cubit/voucher_state.dart';
import 'package:mobile/data/repositories/voucher_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class VoucherCubit extends Cubit<VoucherState> {
  final VoucherRepository _voucherRepository;

  VoucherCubit(this._voucherRepository)
      : super(VoucherState(
            pageable: Pageable(
          page: 1,
          size: 20,
        )));

  void selectVoucher(String vouchers) {
    emit(state.copyWith(filter: vouchers));
  }

  Future<void> getVouchers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final vouchers = await _voucherRepository.getVouchers(
          state.pageable, state.filter ?? '', state.search ?? '');
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

  Future<void> getVoucherById(int id) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final voucher = await _voucherRepository.getVoucherById(id);
      emit(state.copyWith(voucher: voucher, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
