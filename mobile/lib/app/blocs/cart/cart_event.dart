// cart_event.dart
import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/models/voucher_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddItemToCart extends CartEvent {
  final CartItemModel item;

  const AddItemToCart(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateItemQuantity extends CartEvent {
  final int skuId;
  final int quantity;
  final int? slotId;

  const UpdateItemQuantity({
    required this.skuId,
    required this.quantity,
    this.slotId,
  });

  @override
  List<Object?> get props => [skuId, quantity, slotId];
}

class RemoveItemFromCart extends CartEvent {
  final int skuId;
  final int? slotId;

  const RemoveItemFromCart({
    required this.skuId,
    this.slotId,
  });

  @override
  List<Object?> get props => [skuId, slotId];
}

class ClearCart extends CartEvent {}

class CleanInvalidItems extends CartEvent {}

class SetShippingInfo extends CartEvent {
  final ShippingInfoModel shippingInfo;

  const SetShippingInfo(this.shippingInfo);

  @override
  List<Object?> get props => [shippingInfo];
}

class SetVoucher extends CartEvent {
  final VoucherModel voucher;

  const SetVoucher(this.voucher);

  @override
  List<Object?> get props => [voucher];
}

class LoadCart extends CartEvent {}

class PlaceOrder extends CartEvent {
  final String paymentMethod;

  const PlaceOrder({required this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

// New events for item selection
class ToggleItemSelection extends CartEvent {
  final int itemId;

  const ToggleItemSelection(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class SelectAllItems extends CartEvent {}

class DeselectAllItems extends CartEvent {}

class RemoveSelectedItems extends CartEvent {}
