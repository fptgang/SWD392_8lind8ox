import 'package:equatable/equatable.dart';
import 'package:openapi/api.dart';

abstract class BlindBoxesListEvent extends Equatable {
  const BlindBoxesListEvent();

  @override
  List<Object?> get props => [];
}

class FetchBlindBoxes extends BlindBoxesListEvent {
  final Pageable pageable;
  final String filter;
  final String search;

  const FetchBlindBoxes({
    required this.pageable,
    this.filter = '',
    this.search = '',
  });

  @override
  List<Object?> get props => [pageable, filter, search];
}

class RefreshBlindBoxes extends BlindBoxesListEvent {
  final Pageable pageable;
  final String filter;
  final String search;

  const RefreshBlindBoxes({
    required this.pageable,
    this.filter = '',
    this.search = '',
  });

  @override
  List<Object?> get props => [pageable, filter, search];
}
