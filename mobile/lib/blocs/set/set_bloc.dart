import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/set/set_event.dart';
import 'package:mobile/blocs/set/set_state.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class SetBloc extends Bloc<SetEvent, SetState> {
  final SetRepository _setRepository;

  SetBloc(this._setRepository)
      : super(SetState(pageable: Pageable(page: 1, size: 20))) {
    on<SelectSetCategory>(_onSelectCategory);
    on<GetSets>(_onGetSets);
    on<GetSetById>(_onGetSetById);
    on<GetNewArrivalSets>(_onGetNewArrivalSets);
  }

  void _onSelectCategory(
      SelectSetCategory event,
      Emitter<SetState> emit,
      ) {
    emit(state.copyWith(filter: event.category));
  }

  Future<void> _onGetSets(
      GetSets event,
      Emitter<SetState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final sets = await _setRepository.getSets(
          state.pageable,
          state.filter ?? '',
          state.search ?? ''
      );
      debugPrint('setsss: $sets');

      emit(state.copyWith(
        sets: sets,
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

  Future<void> _onGetSetById(
      GetSetById event,
      Emitter<SetState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final set = await _setRepository.getSetById(event.id);
      emit(state.copyWith(
          set: set,
          isLoading: false
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onGetNewArrivalSets(
      GetNewArrivalSets event,
      Emitter<SetState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final pageable = Pageable(
        page: 0,
        size: event.limit,
        sort: ['createdAt,desc'],
      );

      final sets = await _setRepository.getSets(
        pageable,
        state.filter ?? '',
        state.search ?? '',
      );

      emit(state.copyWith(
        sets: sets,
        isLoading: false,
        pageable: pageable,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}