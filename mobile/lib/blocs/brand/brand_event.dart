abstract class BrandEvent {}

class GetBrands extends BrandEvent {
  final int pageKey;

  GetBrands(this.pageKey);
}

class GetBrandById extends BrandEvent {
  final int id;

  GetBrandById(this.id);
}
