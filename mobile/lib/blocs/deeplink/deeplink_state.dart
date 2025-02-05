import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DeeplinkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeeplinkInitial extends DeeplinkState {}

class InitialDeepLinkFound extends DeeplinkState {
  final String token;

  InitialDeepLinkFound({required this.token});

  @override
  List<Object?> get props => [token];
}

class DeepLinkError extends DeeplinkState {
  final String error;

  DeepLinkError({required this.error});

  @override
  List<Object?> get props => [error];
}
