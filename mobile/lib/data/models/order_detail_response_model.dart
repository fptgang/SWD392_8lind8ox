

import 'package:mobile/data/models/brand_model.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:openapi/api.dart';

class OrderDetailResponseModel {
  final List<OrderDetailModel> content;
  final int? totalElements;
  final int? totalPages;
  final bool? last;
  final bool? first;
  final int? numberOfElements;
  final bool? empty;

  OrderDetailResponseModel({
    this.content = const [],
    this.totalElements,
    this.totalPages,
    this.last,
    this.first,
    this.numberOfElements,
    this.empty,
  });

  List<Object> get props => [
    content,
    totalElements ?? 0,
    totalPages ?? 0,
    last ?? false,
    first ?? false,
    numberOfElements ?? 0,
    empty ?? false,
  ];

}