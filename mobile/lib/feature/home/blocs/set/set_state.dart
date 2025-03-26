import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/set_model.dart';

enum SetStatus { initial, loading, success, failure }

class SetState extends Equatable {
  final SetStatus status;
  final PaginationResponseGeneric<SetModel>? sets;
  final String? errorMessage;

  const SetState({
    this.status = SetStatus.initial,
    this.sets,
    this.errorMessage,
  });

  SetState copyWith({
    SetStatus? status,
    PaginationResponseGeneric<SetModel>? sets,
    String? errorMessage,
  }) {
    return SetState(
      status: status ?? this.status,
      sets: sets ?? this.sets,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sets, errorMessage];
}
