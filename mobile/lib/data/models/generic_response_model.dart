class PaginationResponseGeneric<T> {
  final List<T> content;
  final int totalElements;
  final int totalPages;
  final bool last;
  final bool first;
  final int numberOfElements;
  final bool empty;

  PaginationResponseGeneric({
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

  static PaginationResponseGeneric<T> fromDTO<T>({
    required D dto,
    required T Function(dynamic) fromDTO,
  }) {
    final dtoMap = dto as Map<String, dynamic>;
    final contentList = dtoMap['content'] as List<dynamic>;

    return PaginationResponseGeneric<T>(
      content: contentList.map((e) => fromDTO(e)).toList(),
      totalElements: dtoMap['totalElements'] as int,
      totalPages: dtoMap['totalPages'] as int,
      last: dtoMap['last'] as bool,
      first: dtoMap['first'] as bool,
      numberOfElements: dtoMap['numberOfElements'] as int,
      empty: dtoMap['empty'] as bool,
    );
  }
}