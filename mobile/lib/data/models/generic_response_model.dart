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

  static PaginationResponseGeneric<T> fromDTO<T, D>({
    required D dto,
    required T Function(dynamic) fromDTO,
  }) {
    if (dto is! Map<String, dynamic>) {
      throw ArgumentError('DTO must be a Map<String, dynamic>');
    }

    final contentList = dto['content'] as List<dynamic>;

    return PaginationResponseGeneric<T>(
      content: contentList.map((e) => fromDTO(e)).toList(),
      totalElements: dto['totalElements'] as int,
      totalPages: dto['totalPages'] as int,
      last: dto['last'] as bool,
      first: dto['first'] as bool,
      numberOfElements: dto['numberOfElements'] as int,
      empty: dto['empty'] as bool,
    );
  }
}
