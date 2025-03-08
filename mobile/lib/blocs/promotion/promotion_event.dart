abstract class PromotionEvent {}

class GetPromotions extends PromotionEvent {
  final int pageKey;

  GetPromotions(this.pageKey);
}

class GetPromotionById extends PromotionEvent {
  final int id;

  GetPromotionById(this.id);
}

class SelectPromotion extends PromotionEvent {
  final String promotion;

  SelectPromotion(this.promotion);
}