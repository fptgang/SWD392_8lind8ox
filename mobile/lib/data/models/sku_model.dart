

class StockKeepingUnitModel{
  final int skuId;
  final String name;
  final int imageId;
  final double price;
  final int stock;
  final int specCount;
  final int blindBoxId;
  final DateTime createdAt;
  final DateTime? updatedAt;


  StockKeepingUnitModel({
    required this.skuId,
    required this.name,
    required this.imageId,
    required this.price,
    required this.stock,
    required this.specCount,
    required this.blindBoxId,
    required this.createdAt,
    this.updatedAt,
  });

  List<Object?> get props => [
    skuId,
    name,
    imageId,
    price,
    stock,
    specCount,
    blindBoxId,
    createdAt,
    updatedAt,
  ];
}