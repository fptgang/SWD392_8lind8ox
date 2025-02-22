import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

/// Base interface for all view events
abstract class ViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Base interface for all view states
abstract class ViewState extends Equatable {
  /// Abstract copyWith method that must be implemented by all states
  ViewState copyWith();

  @override
  List<Object?> get props => [];
}

/// Base interface for all view model states
abstract class ViewModelState extends Equatable {
  /// Abstract copyWith method that must be implemented by all view model states
  ViewModelState copyWith();

  @override
  List<Object?> get props => [];
}

/// Sealed class for handling result states
sealed class Result<T> {
  const Result();

  const factory Result.init([dynamic initData]) = Init;
  const factory Result.success(T data) = Success;
  const factory Result.error(String message) = Error;
  const factory Result.done() = Done;
}

class Init<T> extends Result<T> {
  final dynamic initData;
  const Init([this.initData]);
}

class Success<T> extends Result<T> {
  final T successData;
  final bool isCached;
  const Success(this.successData, {this.isCached = false});
}

class Error<T> extends Result<T> {
  final String message;
  const Error(this.message);
}

class Done<T> extends Result<T> {
  const Done();
}

/// Base Bloc class that provides common functionality for all blocs
abstract class BaseBloc<E extends ViewEvent, S extends ViewState, VS extends ViewModelState>
    extends Bloc<E, S> {
  BaseBloc(VS initialState) : super(initialState.copyWith() as S) {
    on<E>((event, emit) => onTriggerEvent(event, emit));
  }

  /// Handle incoming events
  void onTriggerEvent(E event, Emitter<S> emit);

  /// Helper method to handle Result types
  void reduce<T>(Result<T> result, {
    void Function(dynamic)? onInit,
    required void Function(bool, T) onSuccess,
    required void Function(String) onError,
    void Function()? onDone,
  }) {
    switch (result) {
      case Init<T>():
        onInit?.call(result.initData);
      case Success<T>():
        onSuccess(result.isCached, result.successData);
      case Error<T>():
        onError(result.message);
      case Done<T>():
        onDone?.call();
    }
  }
}