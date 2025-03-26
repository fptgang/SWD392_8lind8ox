import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';

enum PromotionStatus { initial, loading, success, failure }

class PromotionState extends Equatable {
  final PromotionStatus status;
  final PaginationResponseGeneric<PromotionModel>? promotions;
  final String? errorMessage;

  const PromotionState({
    this.status = PromotionStatus.initial,
    this.promotions,
    this.errorMessage,
  });

  PromotionState copyWith({
    PromotionStatus? status,
    PaginationResponseGeneric<PromotionModel>? promotions,
    String? errorMessage,
  }) {
    return PromotionState(
      status: status ?? this.status,
      promotions: promotions ?? this.promotions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, promotions, errorMessage];
}
