class BrandModel {
  int? brandId;
  String? name;
  String? description;
  bool? isVisible;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<int> blindBoxes;

  BrandModel({
    this.brandId,
    this.name,
    this.description,
    this.isVisible,
    this.createdAt,
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