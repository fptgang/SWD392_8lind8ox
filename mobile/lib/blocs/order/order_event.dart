
abstract class OrderEvent  {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrder extends OrderEvent {
  final String address;
  final String phoneNumber;
  final String note;

  PlaceOrder(this.address, this.phoneNumber, this.note);

  @override
  List<Object> get props => [address, phoneNumber, note];
}

class FetchOrders extends OrderEvent {}

class CancelOrder extends OrderEvent {
  final String orderId;

  CancelOrder(this.orderId);

  @override
  List<Object> get props => [orderId];
}

// class FetchOrderDetail extends OrderEvent {
//   final String orderId;
//
//   FetchOrderDetail(this.orderId);
//
//   @override
//   List<Object> get props => [orderId];
// }
//
// class FetchOrderHistory extends OrderEvent {}
//
// class FetchOrderHistoryDetail extends OrderEvent {
//   final String orderId;
//
//   FetchOrderHistoryDetail(this.orderId);
//
//   @override
//   List<Object> get props => [orderId];
// }