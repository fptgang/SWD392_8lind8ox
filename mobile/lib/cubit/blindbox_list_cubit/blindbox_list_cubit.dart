import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/cubit/blindbox_list_cubit/blindbox_list_state.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:openapi/api.dart';


@injectable
class BlindBoxesCubit extends Cubit<BlindBoxesState> {
  final BlindBoxRepository _blindBoxRepository;

  BlindBoxesCubit(this._blindBoxRepository) : super(BlindBoxesState());

  Future<void> getBlindBoxes() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final blindBoxes = await _blindBoxRepository.getBlindBoxes(state.pageable, state.filter ?? '', state.search ?? '');
      emit(state.copyWith(blindBoxes: blindBoxes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void updateFilter(String filter) {
    emit(state.copyWith(
      filter: filter,
      pageable: Pageable(page: 0, size: 10),
    ));
    getBlindBoxes();
  }

  void updateSearch(String search) {
    emit(state.copyWith(
      search: search,
      pageable: Pageable(page: 0, size: 10),
    ));
    getBlindBoxes();
  }

  void loadNextPage() {
    final nextPage = state.pageable.page + 1;
    emit(state.copyWith(
      pageable: Pageable(
        page: nextPage,
        size: state.pageable.size,
      ),
    ));
    getBlindBoxes();
  }

  void refresh() {
    emit(state.copyWith(
      pageable: Pageable(page: 0, size: 10),
      filter: null,
      search: null,
    ));
    getBlindBoxes();
  }
}