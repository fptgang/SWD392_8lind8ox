

  import 'package:mobile/data/models/image_model.dart';

  class StockKeepingUnitModel{
    final int? skuId;
    final String? name;
    final ImageModel? image;
    final double? price;
    final int? stock;
    final int? specCount;
    final int? blindBoxId;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final bool? isVisible;


    StockKeepingUnitModel({
      this.skuId,
      this.name,
      this.image,
      this.price,
      this.stock,
      this.specCount,
      this.blindBoxId,
      this.createdAt,
      this.updatedAt,
      this.isVisible
    });

    List<Object?> get props => [
      skuId,
      name,
      image,
      price,
      stock,
      specCount,
      blindBoxId,
      createdAt,
      updatedAt,
      isVisible
    ];
  }