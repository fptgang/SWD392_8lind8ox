import 'blindbox_model.dart';

class BlindBoxesResponseModel {
  final List<BlindBoxModel> content;
  final int totalElements;
  final int totalPages;
  final bool last;
  final bool first;
  final int numberOfElements;
  final bool empty;

  BlindBoxesResponseModel({
    this.content = const [],
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  List<Object> get props => [
    content,
    totalElements,
    totalPages,
    last,
    first,
    numberOfElements,
    empty,
  ];
}