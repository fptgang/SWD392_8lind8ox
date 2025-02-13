import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/blindbox_model.dart';

class BlindBoxDetailState extends Equatable {
  final BlindBoxModel? blindBox;
  final bool isLoading;
  final String? error;
  final int id;
  final int selectedImageIndex;
  final int quantity;

  const BlindBoxDetailState({
    this.blindBox,
    this.isLoading = false,
    this.error,
    required this.id,
    this.selectedImageIndex = 0,
    this.quantity = 1,
  });

  BlindBoxDetailState copyWith({
    BlindBoxModel? blindBox,
    bool? isLoading,
    String? error,
    int? id,
    int? selectedImageIndex,
    int? quantity,
  }) {
    return BlindBoxDetailState(
      blindBox: blindBox ?? this.blindBox,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      id: id ?? this.id,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'BlindBoxDetailState(id: $id, isLoading: $isLoading, error: $error, blindBox: ${blindBox?.name})';
  }

  @override
  List<Object?> get props => [blindBox, isLoading, error, id, selectedImageIndex, quantity];
}