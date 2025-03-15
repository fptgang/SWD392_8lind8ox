import 'package:mobile/data/models/set_model.dart';

abstract class SetEvent {}

class SelectSetCategory extends SetEvent {
  final String category;

  SelectSetCategory(this.category);
}

class GetSets extends SetEvent {
  final int pageKey;

  GetSets(this.pageKey);
}

class GetSetById extends SetEvent {
  final int id;

  GetSetById(this.id);
}

class GetNewArrivalSets extends SetEvent {
  final int limit;
  GetNewArrivalSets({this.limit = 10});
}

class GetSkuById extends SetEvent {
  final int id;

  GetSkuById(this.id);
}

class GetSkusForSet extends SetEvent {
  final List<int> skuIds;

  GetSkusForSet(this.skuIds);
}

class SelectSku extends SetEvent {
  final int skuId;

  SelectSku(this.skuId);
}

class LoadSetImages extends SetEvent {
  final List<SetModel>? sets;
  
  LoadSetImages(this.sets);
}

class LoadSetImage extends SetEvent {
  final SetModel set;
  
  LoadSetImage(this.set);
}