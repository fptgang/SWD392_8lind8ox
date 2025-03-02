class BrandModel {
  final int brandId;
  final String name;
  final String description;
  final bool isVisible;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<int> blindBoxes;

  BrandModel({
    required this.brandId,
    required this.name,
    required this.description,
    required this.isVisible,
    required this.createdAt,
    this.updatedAt,
    this.blindBoxes = const [],
  });

  List<Object?> get props => [
    brandId,
    name,
    description,
    isVisible,
    createdAt,
    updatedAt,
    blindBoxes,
  ];
}