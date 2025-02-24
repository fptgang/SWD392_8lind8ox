abstract class PromotionEvent {}

class GetPromotions extends PromotionEvent {}

class GetPromotionById extends PromotionEvent {
  final int id;

  GetPromotionById(this.id);
}
