class BrandModel {
  final int? brandId;
  final String? name;
  final String? description;
  final bool? isVisible;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BrandModel({
    this.brandId,
    this.name,
    this.description,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
  });

  List<Object?> get props => [
    brandId,
    name,
    description,
    isVisible,
    createdAt,
    updatedAt,
  ];
}