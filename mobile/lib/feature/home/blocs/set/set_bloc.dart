import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/repositories/image_repository.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/data/repositories/sku_repository.dart';
import 'package:openapi/api.dart';

import 'set_event.dart';
import 'set_state.dart';

class SetBloc extends Bloc<SetEvent, SetState> {
  final SetRepository _setRepository;
  final SkuRepository skuRepository;
  final ImageRepository imageRepository;

  SetBloc(
    this._setRepository, {
    required this.skuRepository,
    required this.imageRepository,
  }) : super(const SetState()) {
    on<FetchSets>(_onFetchSets);
    on<RefreshSets>(_onRefreshSets);
  }

  Future<void> _onFetchSets(
    FetchSets event,
    Emitter<SetState> emit,
  ) async {
    emit(state.copyWith(status: SetStatus.loading));
    try {
      final sets = await _setRepository.getSets(
        event.pageable,
        event.filter,
        event.search,
      );
      emit(state.copyWith(
        status: SetStatus.success,
        sets: sets,
      ));
    } catch (e) {
      debugPrint('Error fetching sets: $e');
      emit(state.copyWith(
        status: SetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshSets(
    RefreshSets event,
    Emitter<SetState> emit,
  ) async {
    try {
      final sets = await _setRepository.getSets(
        event.pageable,
        event.filter,
        event.search,
      );
      emit(state.copyWith(
        status: SetStatus.success,
        sets: sets,
      ));
    } catch (e) {
      debugPrint('Error refreshing sets: $e');
      emit(state.copyWith(
        status: SetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
