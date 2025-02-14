import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomepageCubit extends Cubit<bool> {
  HomepageCubit() : super(false) {
    scrollController.addListener(_onScroll);
  }

  final ScrollController scrollController = ScrollController();

  void _onScroll() {
    final bool isScrolled = scrollController.offset > 150;
    if (state != isScrolled) {
      emit(isScrolled);
    }
  }

  @override
  Future<void> close() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    return super.close();
  }
}
