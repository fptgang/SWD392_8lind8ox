import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/blindbox_detail/blindbox_detail_event.dart';
import 'package:mobile/blocs/blindbox_detail/blindbox_detail_state.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';

@injectable
class BlindBoxDetailBloc extends Bloc<BlindBoxDetailEvent, BlindBoxDetailState> {
  final BlindBoxRepository _blindBoxRepository;

  @factoryMethod
  BlindBoxDetailBloc({required BlindBoxRepository blindBoxRepository})
      : _blindBoxRepository = blindBoxRepository,
        super(const BlindBoxDetailState(id: 1)){
    on<FetchBlindBoxDetail>(_onFetchBlindBoxDetail);
    on<OutOfStockBlindBoxDetail>(_onOutOfStockBlindBoxDetail);
    on<SelectBlindBoxDetail>(_onSelectBlindBoxDetail);
    on<UpdateSelectedImage>(_onUpdateSelectedImage);
    on<IncrementQuantity>(_onIncrementQuantity);
    on<DecrementQuantity>(_onDecrementQuantity);
  }

  void _onFetchBlindBoxDetail(FetchBlindBoxDetail event, Emitter<BlindBoxDetailState> emit) async {
    debugPrint('Starting fetch for ID: ${event.id}');
    emit(state.copyWith(isLoading: true, id: event.id));

    try {
      debugPrint('Calling repository for ID: ${event.id}');
      final blindBox = await _blindBoxRepository.getBlindBoxById(event.id);

      debugPrint('Repository returned data:');
      debugPrint('Blind box: $blindBox');
      debugPrint('Blind box name: ${blindBox.name}');
      debugPrint('Blind box description: ${blindBox.description}');
      debugPrint('Blind box SKUs: ${blindBox.skus}');
      debugPrint('Blind box images: ${blindBox.images}');

      debugPrint('Emitting new state with blind box data');
      final newState = state.copyWith(
        isLoading: false,
        id: event.id,
        blindBox: blindBox,
      );
      debugPrint('New state to emit: $newState');
      emit(newState);
      debugPrint('State emitted successfully');

    } catch (e) {
      debugPrint('Error in fetch: $e');
      emit(state.copyWith(
          error: e.toString(),
          isLoading: false,
          id: event.id
      ));
    }
  }


  void _onOutOfStockBlindBoxDetail(OutOfStockBlindBoxDetail event, Emitter<BlindBoxDetailState> emit) {
    emit(state.copyWith(
      id: int.tryParse(event.id) ?? state.id,
    ));
  }

  void _onSelectBlindBoxDetail(
    SelectBlindBoxDetail event,
    Emitter<BlindBoxDetailState> emit,
  ) {
    emit(state.copyWith(id: state.id, blindBox: state.blindBox));
  }

  void _onUpdateSelectedImage(UpdateSelectedImage event, Emitter<BlindBoxDetailState> emit) {
    emit(state.copyWith(selectedImageIndex: event.index));
  }

  void _onIncrementQuantity(IncrementQuantity event, Emitter<BlindBoxDetailState> emit) {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void _onDecrementQuantity(DecrementQuantity event, Emitter<BlindBoxDetailState> emit) {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }
}
