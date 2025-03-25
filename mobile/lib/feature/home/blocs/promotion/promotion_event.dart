import 'package:equatable/equatable.dart';
import 'package:openapi/api.dart';

abstract class PromotionEvent extends Equatable {
  const PromotionEvent();

  @override
  List<Object?> get props => [];
}

class FetchPromotions extends PromotionEvent {
  final Pageable pageable;
  final String filter;
  final String search;

  const FetchPromotions({
    required this.pageable,
    this.filter = '',
    this.search = '',
  });

  @override
  List<Object?> get props => [pageable, filter, search];
}

class RefreshPromotions extends PromotionEvent {
  final Pageable pageable;
  final String filter;
  final String search;

  const RefreshPromotions({
    required this.pageable,
    this.filter = '',
    this.search = '',
  });

  @override
  List<Object?> get props => [pageable, filter, search];
}
