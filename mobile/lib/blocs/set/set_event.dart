abstract class SetEvent {}

class SelectSetCategory extends SetEvent {
  final String category;

  SelectSetCategory(this.category);
}

class GetSets extends SetEvent {}

class GetSetById extends SetEvent {
  final int id;

  GetSetById(this.id);
}

class GetNewArrivalSets extends SetEvent {
  final int limit;
  GetNewArrivalSets({this.limit = 10});
}