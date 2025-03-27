import 'package:equatable/equatable.dart';

abstract class BlindBoxDetailEvent extends Equatable {
  const BlindBoxDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchBlindBoxDetail extends BlindBoxDetailEvent {
  final int id;

  const FetchBlindBoxDetail(this.id);

  @override
  List<Object> get props => [id];
}

class OutOfStockBlindBoxDetail extends BlindBoxDetailEvent {
  final int id;

  const OutOfStockBlindBoxDetail(this.id);

  @override
  List<Object> get props => [id];
}

class SelectBlindBoxDetail extends BlindBoxDetailEvent {
  final int id;

  const SelectBlindBoxDetail(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateSelectedImage extends BlindBoxDetailEvent {
  final int index;

  const UpdateSelectedImage(this.index);

  @override
  List<Object> get props => [index];
}

class IncrementQuantity extends BlindBoxDetailEvent {}

class DecrementQuantity extends BlindBoxDetailEvent {}

class SelectSku extends BlindBoxDetailEvent {
  final int skuId;

  const SelectSku({required this.skuId});

  @override
  List<Object> get props => [skuId];
}

class ToggleDescriptionExpansion extends BlindBoxDetailEvent {}
