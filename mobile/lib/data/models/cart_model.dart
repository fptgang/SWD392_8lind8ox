import 'package:equatable/equatable.dart';
import 'package:mobile/enum/enum.dart';

class CartModel extends Equatable {
  final CartPaymentMethodEnum? paymentMethod;
  final int? shippingInfoId;
  final int? voucherId;
  final List<CartItemModel>? items;

  const CartModel({
    this.paymentMethod,
    this.shippingInfoId,
    this.voucherId,
    this.items,
  });

  @override
  List<Object?> get props => [paymentMethod, shippingInfoId, voucherId, items];

  CartModel copyWith({
    CartPaymentMethodEnum? paymentMethod,
    int? shippingInfoId,
    int? voucherId,
    List<CartItemModel>? items,
  }) {
    return CartModel(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingInfoId: shippingInfoId ?? this.shippingInfoId,
      voucherId: voucherId ?? this.voucherId,
      items: items ?? this.items,
    );
  }
}

class CartItemModel extends Equatable {
  final int id;
  final String productName;
  final double price;
  final String image;
  final int quantity;
  final int? skuId;

  const CartItemModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.image,
    required this.quantity,
    this.skuId,
  });

  @override
  List<Object?> get props => [id, productName, price, image, quantity, skuId];

  CartItemModel copyWith({
    int? id,
    String? productName,
    double? price,
    String? image,
    int? quantity,
    int? skuId,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      skuId: skuId ?? this.skuId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productName": productName,
      "price": price,
      "image": image,
      "quantity": quantity,
      "skuId": skuId,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      productName: json['productName'],
      price: json['price'],
      image: json['image'],
      quantity: json['quantity'],
      skuId: json['skuId'],
    );
  }

  @override
  String toString() {
    return 'CartItemModel{id: $id, productName: $productName, price: $price, image: $image, quantity: $quantity, skuId: $skuId}';
  }
}

// Local display model for cart items in the UI
// This is separate from the API models to handle UI-specific needs
class CartDisplayItem {
  final int id;
  final String productName;
  final double price;
  final String image;
  final int quantity;

  const CartDisplayItem({
    required this.id,
    required this.productName,
    required this.price,
    required this.image,
    required this.quantity,
  });

  // Convert from CartItem from CartState
  static CartDisplayItem fromCartItem(dynamic cartItem) {
    return CartDisplayItem(
      id: cartItem.id,
      productName: cartItem.productName,
      price: cartItem.price,
      image: cartItem.image,
      quantity: cartItem.quantity,
    );
  }

  CartDisplayItem copyWith({
    int? id,
    String? productName,
    double? price,
    String? image,
    int? quantity,
  }) {
    return CartDisplayItem(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productName": productName,
      "price": price,
      "image": image,
      "quantity": quantity,
    };
  }
}
