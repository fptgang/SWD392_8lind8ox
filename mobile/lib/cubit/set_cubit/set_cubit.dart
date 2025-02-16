import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/cubit/set_cubit/set_state.dart';
import 'package:openapi/api.dart';

import '../../data/repositories/set_repository.dart';

@injectable
@lazySingleton
class SetCubit extends Cubit<SetState> {
  final SetRepository _setRepository;

  SetCubit(this._setRepository) : super(SetState(pageable: Pageable(page: 1, size: 20,)));

  void selectCategory(String category) {
    emit(state.copyWith(filter: category));
  }

  Future<void> getSets() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final sets = await _setRepository.getSets(
          state.pageable, state.filter ?? '', state.search ?? '');
      debugPrint('setsss: $sets');

      emit(state.copyWith(
        sets: sets, isLoading: false, pageable: Pageable(
        page: state.pageable.page,
        size: 20,
      ),));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> getSetById(int id) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final set = await _setRepository.getSetById(id);
      emit(state.copyWith(
        set: set, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

}
