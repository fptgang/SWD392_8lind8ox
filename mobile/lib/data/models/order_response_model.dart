

import 'package:mobile/data/models/order_model.dart';

class OrderResponseModel {
  OrderModel? order;

  String? paymentRedirectUrl;

  OrderResponseModel({this.order, this.paymentRedirectUrl});

  List<Object?> get props => [order, paymentRedirectUrl];
}