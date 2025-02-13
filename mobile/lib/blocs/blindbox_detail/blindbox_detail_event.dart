

    abstract class BlindBoxDetailEvent {
      const BlindBoxDetailEvent();

      @override
      List<Object> get props => [];
    }

    class FetchBlindBoxDetail extends BlindBoxDetailEvent {
      final int id;

      FetchBlindBoxDetail(this.id);

      @override
      List<Object> get props => [id];
    }

    class OutOfStockBlindBoxDetail extends BlindBoxDetailEvent {
      final String id;

      OutOfStockBlindBoxDetail(this.id);

      @override
      List<Object> get props => [id];
    }

    class SelectBlindBoxDetail extends BlindBoxDetailEvent {
      final String id;

      SelectBlindBoxDetail(this.id);

      @override
      List<Object> get props => [id];
    }

    class UpdateSelectedImage extends BlindBoxDetailEvent {
      final int index;
      UpdateSelectedImage(this.index);
    }

    class IncrementQuantity extends BlindBoxDetailEvent {}
    class DecrementQuantity extends BlindBoxDetailEvent {}