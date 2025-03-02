abstract class BrandEvent {}

class GetBrands extends BrandEvent {}

class GetBrandById extends BrandEvent {
  final int id;

  GetBrandById(this.id);
}
