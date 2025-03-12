

  import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/image_model.dart';

  class StockKeepingUnitModel{
    final int? skuId;
    final String? name;
    final ImageModel? image;
    final double? price;
    final int? stock;
    final int? specCount;
    final BlindBoxModel? blindBox;
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
      this.blindBox,
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
      blindBox,
      createdAt,
      updatedAt,
      isVisible
    ];
  }