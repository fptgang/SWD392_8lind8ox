class CartItem {
  final int id;
  final String productName;
  final double price;
  final String image;
  final int quantity;

  CartItem({
    required this.id,
    required this.productName,
    required this.price,
    required this.image,
    required this.quantity,
  });


  CartItem copyWith({
    int? id,
    String? productName,
    double? price,
    String? image,
    int? quantity,
  }) {
    return CartItem(
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


  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productName: json['productName'],
      price: json['price'],
      image: json['image'],
      quantity: json['quantity'],
    );
  }
}