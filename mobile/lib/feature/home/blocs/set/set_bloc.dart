import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/repositories/image_repository.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/data/repositories/sku_repository.dart';
import 'package:mobile/feature/home/blocs/set/set_event.dart';
import 'package:mobile/feature/home/blocs/set/set_state.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class SetBloc extends Bloc<SetEvent, SetState> {
  final SetRepository _setRepository;
  final SkuRepository _skuRepository;
  final ImageRepository _imageRepository;
  final PagingController<int, SetModel> pagingController;

  SetPaginationState _paginationState;
  SetDataState _dataState;

  @factoryMethod
  SetBloc(
    this._setRepository, {
    required SkuRepository skuRepository,
    required ImageRepository imageRepository,
  })  : _skuRepository = skuRepository,
        _imageRepository = imageRepository,
        _paginationState =
            SetPaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const SetDataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(SetLoadingState()) {
    on<SelectSetCategory>(_onSelectCategory);
    on<GetSets>(_onGetSets);
    on<GetSetById>(_onGetSetById);
    on<GetNewArrivalSets>(_onGetNewArrivalSets);
    on<GetSkuById>(_onGetSkuById);
    on<GetSkusForSet>(_onGetSkusForSet);
    on<SelectSku>(_onSelectSku);
    on<LoadSetImages>(_onLoadSetImages);
    on<LoadSetImage>(_onLoadSetImage);
  }

  void _onSelectCategory(
    SelectSetCategory event,
    Emitter<SetState> emit,
  ) {
    _dataState = _dataState.copyWith(filter: event.category);
    emit(_dataState);
  }

  Future<void> _onGetSets(
    GetSets event,
    Emitter<SetState> emit,
  ) async {
    emit(SetLoadingState(isLoading: true));

    try {
      final pageable = Pageable(page: event.pageKey, size: 20, sort: ['desc']);

      final sets = await _setRepository.getSets(
          pageable, _dataState.filter ?? '', _dataState.search ?? '');
      debugPrint('setsss: $sets');

      final isLastPage = sets.content.length < pageable.size;

      if (isLastPage) {
        pagingController.appendLastPage(sets.content);
      } else {
        pagingController.appendPage(sets.content, event.pageKey + 1);
      }

      _paginationState = _paginationState.copyWith(
        pageable: pageable,
        hasReachedEnd: isLastPage,
      );

      _dataState = _dataState.copyWith(sets: sets);
      emit(_dataState);

      // Load images for the sets
      if (sets.content.isNotEmpty) {
        add(LoadSetImages(sets.content));
      }
    } catch (error) {
      pagingController.error = error;
      emit(SetLoadingState(error: error.toString(), isLoading: false));
    }
  }

  Future<void> _onGetSetById(
    GetSetById event,
    Emitter<SetState> emit,
  ) async {
    emit(SetLoadingState(isLoading: true));

    try {
      final set = await _setRepository.getSetById(event.id);
      _dataState = _dataState.copyWith(set: set);

      // Fetch the SKU from the set
      if (set.sku.skuId != null) {
        add(GetSkuById(set.sku.skuId!));
      }

      // Load the image for this set
      add(LoadSetImage(set));

      emit(_dataState);
    } catch (e) {
      emit(SetLoadingState(error: e.toString()));
    }
  }

  Future<void> _onGetNewArrivalSets(
    GetNewArrivalSets event,
    Emitter<SetState> emit,
  ) async {
    emit(SetLoadingState(isLoading: true));

    try {
      final pageable = Pageable(
        page: 0,
        size: event.limit,
        sort: ['createdAt,desc'],
      );

      final sets = await _setRepository.getSets(
        pageable,
        _dataState.filter ?? '',
        _dataState.search ?? '',
      );

      _dataState = _dataState.copyWith(sets: sets);
      emit(_dataState);

      // Load images for new arrival sets
      if (sets.content.isNotEmpty) {
        add(LoadSetImages(sets.content));
      }
    } catch (e) {
      emit(SetLoadingState(error: e.toString()));
    }
  }

  Future<void> _onGetSkuById(
    GetSkuById event,
    Emitter<SetState> emit,
  ) async {
    emit(SetLoadingState(isLoading: true));

    try {
      final sku = await _skuRepository.getStockKeepingUnitById(event.id);
      final currentSkus = _dataState.skus?.toList() ?? [];

      // Check if we already have this SKU
      final existingIndex = currentSkus.indexWhere((s) => s.skuId == sku.skuId);
      if (existingIndex != -1) {
        currentSkus[existingIndex] = sku;
      } else {
        currentSkus.add(sku);
      }

      _dataState = _dataState.copyWith(
        skus: currentSkus,
        selectedSku: _dataState.selectedSku ?? sku,
      );

      emit(_dataState);
    } catch (e) {
      emit(SetLoadingState(error: e.toString()));
    }
  }

  Future<void> _onGetSkusForSet(
    GetSkusForSet event,
    Emitter<SetState> emit,
  ) async {
    emit(SetLoadingState(isLoading: true));

    try {
      final List<StockKeepingUnitModel> skus = [];

      // Fetch each SKU one by one
      for (final skuId in event.skuIds) {
        try {
          final sku = await _skuRepository.getStockKeepingUnitById(skuId);
          skus.add(sku);
        } catch (e) {
          debugPrint('Error fetching SKU $skuId: $e');
          // Continue to the next SKU even if one fails
        }
      }

      _dataState = _dataState.copyWith(
        skus: skus,
        selectedSku: skus.isNotEmpty ? skus.first : null,
      );

      emit(_dataState);
    } catch (e) {
      emit(SetLoadingState(error: e.toString(), isLoading: false));
    }
  }

  void _onSelectSku(
    SelectSku event,
    Emitter<SetState> emit,
  ) {
    final skus = _dataState.skus;
    if (skus != null) {
      final selectedSku = skus.firstWhere(
        (sku) => sku.skuId == event.skuId,
        orElse: () => _dataState.selectedSku!,
      );

      _dataState = _dataState.copyWith(selectedSku: selectedSku);
      emit(_dataState);
    }
  }

  Future<void> _onLoadSetImages(
    LoadSetImages event,
    Emitter<SetState> emit,
  ) async {
    if (event.sets == null || event.sets!.isEmpty) return;

    try {
      final Map<int, String> setImages = Map.from(_dataState.setImages ?? {});

      // Process each set to get its image
      for (final set in event.sets!) {
        if (set.setId != null && !setImages.containsKey(set.setId)) {
          // Try to get image from the set's SKU
          if (set.sku.image != null && set.sku.image!.imageUrl != null) {
            setImages[set.setId] = set.sku.image!.imageUrl!;
          }
        }
      }

      if (setImages.isNotEmpty) {
        _dataState = _dataState.copyWith(setImages: setImages);
        emit(_dataState);
      }
    } catch (e) {
      debugPrint('Error loading set images: $e');
      // Don't emit error state here to avoid disrupting the UI
    }
  }

  Future<void> _onLoadSetImage(
    LoadSetImage event,
    Emitter<SetState> emit,
  ) async {
    try {
      final set = event.set;
      if (set.setId == null) return;

      final Map<int, String> setImages = Map.from(_dataState.setImages ?? {});

      // Try to get image from the set's SKU
      if (set.sku.image != null && set.sku.image!.imageUrl != null) {
        setImages[set.setId] = set.sku.image!.imageUrl!;

        _dataState = _dataState.copyWith(setImages: setImages);
        emit(_dataState);
      }
    } catch (e) {
      debugPrint('Error loading set image: $e');
      // Don't emit error state here to avoid disrupting the UI
    }
  }
}
