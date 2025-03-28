import 'package:equatable/equatable.dart';
import 'package:openapi/api.dart';

abstract class SetEvent extends Equatable {
  const SetEvent();

  @override
  List<Object?> get props => [];
}

class FetchSets extends SetEvent {
  final Pageable pageable;
  final String filter;
  final String search;

  const FetchSets({
    required this.pageable,
    this.filter = '',
    this.search = '',
  });

  @override
  List<Object?> get props => [pageable, filter, search];
}

class RefreshSets extends SetEvent {
  final Pageable pageable;
  final String filter;
  final String search;

  const RefreshSets({
    required this.pageable,
    this.filter = '',
    this.search = '',
  });

  @override
  List<Object?> get props => [pageable, filter, search];
}

class LoadMoreSets extends SetEvent {
  final Pageable pageable;
  final String filter;
  final String search;

  const LoadMoreSets({
    required this.pageable,
    this.filter = '',
    this.search = '',
  });

  @override
  List<Object?> get props => [pageable, filter, search];
}
