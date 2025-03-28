import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/set_model.dart';

enum SetStatus { initial, loading, success, failure }

class SetState extends Equatable {
  final SetStatus status;
  final PaginationResponseGeneric<SetModel>? sets;
  final String? errorMessage;
  final int currentPage;
  final bool isLoading;

  const SetState({
    this.status = SetStatus.initial,
    this.sets,
    this.errorMessage,
    this.currentPage = 0,
    this.isLoading = false,
  });

  SetState copyWith({
    SetStatus? status,
    PaginationResponseGeneric<SetModel>? sets,
    String? errorMessage,
    int? currentPage,
    bool? isLoading,
  }) {
    return SetState(
      status: status ?? this.status,
      sets: sets ?? this.sets,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props =>
      [status, sets, errorMessage, currentPage, isLoading];
}
