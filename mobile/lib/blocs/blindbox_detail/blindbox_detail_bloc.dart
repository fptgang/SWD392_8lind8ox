import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/blindbox_detail/blindbox_detail_event.dart';
import 'package:mobile/blocs/blindbox_detail/blindbox_detail_state.dart';
import 'package:mobile/data/models/image_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/repositories/blindbox_campaign_repository.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:mobile/data/repositories/image_repository.dart';
import 'package:mobile/data/repositories/implement/blindbox_campaign_repository_impl.dart';
import 'package:mobile/data/repositories/sku_repository.dart';

@injectable
class BlindBoxDetailBloc
    extends Bloc<BlindBoxDetailEvent, BlindBoxDetailState> {
  final BlindBoxRepository _blindBoxRepository;
  final SkuRepository _skuRepository;
  final ImageRepository _imageRepository;
  final BlindBoxCampaignRepository _blindBoxCampaignRepository;

  @factoryMethod
  BlindBoxDetailBloc({
    required BlindBoxRepository blindBoxRepository,
    required SkuRepository skuRepository,
    required ImageRepository imageRepository,
    BlindBoxCampaignRepository? blindBoxCampaignRepository,
  })  : _blindBoxRepository = blindBoxRepository,
        _skuRepository = skuRepository,
        _imageRepository = imageRepository,
        _blindBoxCampaignRepository =
            blindBoxCampaignRepository ?? BlindBoxCampaignRepositoryImpl(),
        super(const BlindBoxLoadingState(id: 0)) {
    on<FetchBlindBoxDetail>(_onFetchBlindBoxDetail);
    on<OutOfStockBlindBoxDetail>(_onOutOfStockBlindBoxDetail);
    on<SelectBlindBoxDetail>(_onSelectBlindBoxDetail);
    on<UpdateSelectedImage>(_onUpdateSelectedImage);
    on<IncrementQuantity>(_onIncrementQuantity);
    on<DecrementQuantity>(_onDecrementQuantity);
    on<SelectSku>(_onSelectSku);
    on<ToggleDescriptionExpansion>(_onToggleDescriptionExpansion);
  }

  Future<void> _onFetchBlindBoxDetail(
    FetchBlindBoxDetail event,
    Emitter<BlindBoxDetailState> emit,
  ) async {
    emit(BlindBoxLoadingState(id: event.id));
    try {
      final blindBox = await _blindBoxRepository.getBlindBoxById(event.id);

      final StockKeepingUnitModel? selectedSku =
          (blindBox.skus != null && blindBox.skus!.isNotEmpty) 
            ? blindBox.skus!.first 
            : null;

      final combinedImageUrls = <String>[];
      
      // Add blindbox images
      if (blindBox.images != null) {
        combinedImageUrls.addAll(
          blindBox.images!
              .map((img) => img.imageUrl ?? '')
              .where((url) => url.isNotEmpty),
        );
      }

      // Add sku image if available
      final skuImageList = <ImageModel>[];
      if (selectedSku?.image != null && selectedSku!.image!.imageUrl != null) {
        skuImageList.add(selectedSku.image!);
        final skuImageUrl = selectedSku.image!.imageUrl!;
        if (skuImageUrl.isNotEmpty) {
          combinedImageUrls.add(skuImageUrl);
        }
      }

      emit(
        BlindBoxDataState(
          id: event.id,
          blindBox: blindBox,
          sku: selectedSku,
          skuImages: skuImageList,
          selectedImageIndex: 0,
          quantity: 1,
          images: combinedImageUrls,
        ),
      );
      
      // Log success
      debugPrint('Loaded BlindBox id: ${event.id}, name: ${blindBox.name}');
      
    } catch (e) {
      debugPrint('Error loading BlindBox id: ${event.id}: $e');
      emit(BlindBoxErrorState(id: event.id, error: e.toString()));
    }
  }

  void _onOutOfStockBlindBoxDetail(
    OutOfStockBlindBoxDetail event,
    Emitter<BlindBoxDetailState> emit,
  ) {
    emit(BlindBoxErrorState(
      id: state.id,
      error: "Blind box #${event.id} is out of stock.",
    ));
  }

  void _onSelectBlindBoxDetail(
    SelectBlindBoxDetail event,
    Emitter<BlindBoxDetailState> emit,
  ) {
    if (state is! BlindBoxDataState) {
      add(FetchBlindBoxDetail(event.id));
      return;
    }
    
    // Re-fetch details for the selected blind box
    add(FetchBlindBoxDetail(event.id));
  }

  void _onUpdateSelectedImage(
    UpdateSelectedImage event,
    Emitter<BlindBoxDetailState> emit,
  ) {
    if (state is BlindBoxDataState) {
      final dataState = state as BlindBoxDataState;
      if (event.index >= 0 && event.index < (dataState.images?.length ?? 0)) {
        emit(dataState.copyWith(selectedImageIndex: event.index));
      }
    }
  }

  void _onIncrementQuantity(
    IncrementQuantity event,
    Emitter<BlindBoxDetailState> emit,
  ) {
    if (state is BlindBoxDataState) {
      final dataState = state as BlindBoxDataState;
      final newQuantity = dataState.quantity + 1;
      // Optional: Add maximum quantity check if needed
      // final maxQuantity = 10; // Example max
      // if (newQuantity > maxQuantity) return;
      
      emit(dataState.copyWith(quantity: newQuantity));
    }
  }

  void _onDecrementQuantity(
    DecrementQuantity event,
    Emitter<BlindBoxDetailState> emit,
  ) {
    if (state is BlindBoxDataState) {
      final dataState = state as BlindBoxDataState;
      if (dataState.quantity > 1) {
        emit(dataState.copyWith(quantity: dataState.quantity - 1));
      }
    }
  }
  
  Future<void> _onSelectSku(
    SelectSku event,
    Emitter<BlindBoxDetailState> emit,
  ) async {
    if (state is! BlindBoxDataState) return;
    
    final dataState = state as BlindBoxDataState;
    final blindBox = dataState.blindBox;
    
    if (blindBox.skus == null || blindBox.skus!.isEmpty) {
      debugPrint('No SKUs available for BlindBox id: ${blindBox.blindBoxId}');
      return;
    }
    
    // Find the selected SKU by ID
    final selectedSku = blindBox.skus!.firstWhere(
      (sku) => sku.skuId == event.skuId,
      orElse: () => blindBox.skus!.first,
    );
    
    // Update images
    final combinedImageUrls = <String>[];
    final skuImageList = <ImageModel>[];
    
    // First add blind box images
    if (blindBox.images != null) {
      combinedImageUrls.addAll(
        blindBox.images!
            .map((img) => img.imageUrl ?? '')
            .where((url) => url.isNotEmpty),
      );
    }
    
    // Then add the SKU image if available
    if (selectedSku.image != null && selectedSku.image!.imageUrl != null) {
      skuImageList.add(selectedSku.image!);
      final imageUrl = selectedSku.image!.imageUrl!;
      if (imageUrl.isNotEmpty) {
        combinedImageUrls.add(imageUrl);
      }
    }
    
    debugPrint('Selected SKU: ${selectedSku.skuId}, name: ${selectedSku.name}, images: ${combinedImageUrls.length}');
    
    // Emit the updated state
    emit(dataState.copyWith(
      sku: selectedSku,
      skuImages: skuImageList,
      images: combinedImageUrls,
      selectedImageIndex: 0, // Reset image selection when SKU changes
    ));
  }
  
  void _onToggleDescriptionExpansion(
    ToggleDescriptionExpansion event,
    Emitter<BlindBoxDetailState> emit,
  ) {
    if (state is BlindBoxDataState) {
      final dataState = state as BlindBoxDataState;
      emit(dataState.copyWith(
        isExpandedDescription: !dataState.isExpandedDescription,
      ));
      debugPrint('Description expanded: ${!dataState.isExpandedDescription}');
    }
  }
}
