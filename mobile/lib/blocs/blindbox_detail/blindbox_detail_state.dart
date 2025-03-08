import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/image_model.dart';
import 'package:mobile/data/models/sku_model.dart';

abstract class BlindBoxDetailState extends Equatable {
  final int id;

  const BlindBoxDetailState({required this.id});

  @override
  List<Object?> get props => [id];
}

class BlindBoxLoadingState extends BlindBoxDetailState {
  final bool isLoading;
  final bool isOutOfStock;
  final String? error;

  const BlindBoxLoadingState({
    required super.id,
    this.isLoading = true,
    this.isOutOfStock = false,
    this.error,
  });

  @override
  List<Object?> get props => [id, isLoading, isOutOfStock, error];

  @override
  String toString() => 'BlindBoxLoadingState(id: $id)';
}

class BlindBoxDataState extends BlindBoxDetailState {
  final BlindBoxModel blindBox;
  final StockKeepingUnitModel? sku;
  final List<ImageModel>? skuImages;
  final int selectedImageIndex;
  final int quantity;
  final List<String>? images;
  final bool isExpandedDescription;

  const BlindBoxDataState({
    required super.id,
    required this.blindBox,
    this.sku,
    this.skuImages,
    this.selectedImageIndex = 0,
    this.quantity = 1,
    this.images,
    this.isExpandedDescription = false,
  });

  BlindBoxDataState copyWith({
    int? id,
    BlindBoxModel? blindBox,
    StockKeepingUnitModel? sku,
    List<ImageModel>? skuImages,
    int? selectedImageIndex,
    int? quantity,
    List<String>? images,
    bool? isExpandedDescription,
  }) {
    return BlindBoxDataState(
      id: id ?? this.id,
      blindBox: blindBox ?? this.blindBox,
      sku: sku ?? this.sku,
      skuImages: skuImages ?? this.skuImages,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      quantity: quantity ?? this.quantity,
      images: images ?? this.images,
      isExpandedDescription: isExpandedDescription ?? this.isExpandedDescription,
    );
  }

  @override
  List<Object?> get props => [
        id,
        blindBox,
        sku,
        skuImages,
        selectedImageIndex,
        quantity,
        images,
        isExpandedDescription,
      ];

  @override
  String toString() => 'BlindBoxLoadedState(id: $id, blindBox: ${blindBox.name}, selectedImageIndex: $selectedImageIndex, quantity: $quantity, images: $images, sku: $sku, skuImages: $skuImages)';
}

class BlindBoxErrorState extends BlindBoxDetailState {
  final String error;

  const BlindBoxErrorState({
    required super.id,
    required this.error,
  });

  @override
  List<Object?> get props => [id, error];

  @override
  String toString() => 'BlindBoxErrorState(id: $id, error: $error)';
}

