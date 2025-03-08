class BrandModel {
  final int brandId;
  final String name;
  final String description;
  final bool isVisible;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BrandModel({
    required this.brandId,
    required this.name,
    required this.description,
    required this.isVisible,
    required this.createdAt,
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