import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';

enum BlindBoxesListStatus { initial, loading, success, failure }

class BlindBoxesListState extends Equatable {
  final BlindBoxesListStatus status;
  final PaginationResponseGeneric<BlindBoxModel>? blindBoxes;
  final String? errorMessage;

  const BlindBoxesListState({
    this.status = BlindBoxesListStatus.initial,
    this.blindBoxes,
    this.errorMessage,
  });

  BlindBoxesListState copyWith({
    BlindBoxesListStatus? status,
    PaginationResponseGeneric<BlindBoxModel>? blindBoxes,
    String? errorMessage,
  }) {
    return BlindBoxesListState(
      status: status ?? this.status,
      blindBoxes: blindBoxes ?? this.blindBoxes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, blindBoxes, errorMessage];
}
