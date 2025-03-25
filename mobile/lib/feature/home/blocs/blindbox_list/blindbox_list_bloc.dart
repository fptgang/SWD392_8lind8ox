import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:openapi/api.dart';

import 'blindbox_list_event.dart';
import 'blindbox_list_state.dart';

class BlindBoxesListBloc
    extends Bloc<BlindBoxesListEvent, BlindBoxesListState> {
  final BlindBoxRepository _blindBoxRepository;

  BlindBoxesListBloc(this._blindBoxRepository)
      : super(const BlindBoxesListState()) {
    on<FetchBlindBoxes>(_onFetchBlindBoxes);
    on<RefreshBlindBoxes>(_onRefreshBlindBoxes);
  }

  Future<void> _onFetchBlindBoxes(
    FetchBlindBoxes event,
    Emitter<BlindBoxesListState> emit,
  ) async {
    emit(state.copyWith(status: BlindBoxesListStatus.loading));
    try {
      final blindBoxes = await _blindBoxRepository.getBlindBoxes(
        event.pageable,
        event.filter,
        event.search,
      );
      emit(state.copyWith(
        status: BlindBoxesListStatus.success,
        blindBoxes: blindBoxes,
      ));
    } catch (e) {
      debugPrint('Error fetching blind boxes: $e');
      emit(state.copyWith(
        status: BlindBoxesListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshBlindBoxes(
    RefreshBlindBoxes event,
    Emitter<BlindBoxesListState> emit,
  ) async {
    try {
      final blindBoxes = await _blindBoxRepository.getBlindBoxes(
        event.pageable,
        event.filter,
        event.search,
      );
      emit(state.copyWith(
        status: BlindBoxesListStatus.success,
        blindBoxes: blindBoxes,
      ));
    } catch (e) {
      debugPrint('Error refreshing blind boxes: $e');
      emit(state.copyWith(
        status: BlindBoxesListStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
