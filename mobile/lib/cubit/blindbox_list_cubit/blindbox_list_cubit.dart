import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/cubit/blindbox_list_cubit/blindbox_list_state.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:openapi/api.dart';

import '../../data/models/blindbox_model.dart';
import '../../data/models/blindboxes_response_model.dart';


@injectable
class BlindBoxesCubit extends Cubit<BlindBoxesState> {
  final BlindBoxRepository _blindBoxRepository;
  final PagingController<int, BlindBoxModel> pagingController = PagingController(firstPageKey: 1);

  BlindBoxesCubit(this._blindBoxRepository) : super(BlindBoxesState(pageable: Pageable(page: 1, size: 20))) {
    pagingController.addPageRequestListener((pageKey) {
      getBlindBoxes(pageKey);
    });
  }

  Future<void> getBlindBoxes(int pageKey) async {
    emit(state.copyWith(isLoading: true, error: null));
    debugPrint('page from get blind boxes before try: ${state.pageable.page}');

    try {
      final pageable = Pageable(
          page: pageKey,
          size: 20,
          sort: ['desc']
      );
      final blindBoxes = await _blindBoxRepository.getBlindBoxes(pageable, state.filter ?? '', state.search ?? '');

      final isLastPage = blindBoxes.content.length < pageable.size;

      if (isLastPage) {
        pagingController.appendLastPage(blindBoxes.content);
      } else {
        pagingController.appendPage(
            blindBoxes.content,
            pageKey + 1
        );
      }

      emit(state.copyWith(
        blindBoxes: blindBoxes,
        isLoading: false,
        pageable: pageable,
        hasReachedEnd: isLastPage,
      ));

      debugPrint(
          'page from get blind boxes after try: ${state.blindBoxes?.content
              .length}');
      debugPrint('page from get blind boxes: ${state.pageable.page}');
    } catch (error) {
      pagingController.error = error;
      emit(state.copyWith(error: error.toString(), isLoading: false));
    }
  }
  Future<void> getNewReleaseBlindBoxes() async {
    emit(state.copyWith(isLoading: true, error: null));
    debugPrint('page from get blind boxes before try: ${state.pageable.page}');

    try {
      final blindBoxes = await _blindBoxRepository.getBlindBoxes(state.pageable, state.filter ?? '', state.search ?? '');
      emit(state.copyWith(blindBoxes: blindBoxes, isLoading: false, pageable: Pageable(
        page: state.pageable.page,
        size: 10,
        sort: ['createdAt,desc'],
      ),));
      debugPrint('page from get blind boxes after try: ${state.blindBoxes?.content.length}');
      debugPrint('page from get blind boxes: ${state.pageable.page}');
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void updateFilter(String filter) {
    emit(state.copyWith(
        filter: filter,
        pageable: Pageable(
          page: 1,
          size: 20,
        )),
    );
    pagingController.refresh();
  }

  void updateSearch(String search) {
    emit(state.copyWith(
        search: search,
        pageable: Pageable(
          page: 1,
          size: 20,
        )),
    );
    pagingController.refresh();
  }


  void refresh() {
    pagingController.refresh();
    emit(state.copyWith(
      pageable: Pageable(page: 0, size: 20, sort: ['desc']),
      filter: null,
      search: null,
      hasReachedEnd: false,
    ));
  }
  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }

}