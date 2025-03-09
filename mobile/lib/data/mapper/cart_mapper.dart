import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

/// CartMapper class to map between CartDto and CartModel
class CartMapper {
  static CartModel toModel(CartDto dto) {
    final items = dto.items.map((item) => _cartItemDtoToModel(item)).toList();

    return CartModel(
      paymentMethod: toCartPaymentEnumModel(dto.paymentMethod ?? CartDtoPaymentMethodEnum.VNPAY),
      shippingInfoId: dto.shippingInfoId,
      voucherId: dto.voucherId,
      items: items,
    );
  }


  static CartPaymentMethodEnum toCartPaymentEnumModel(CartDtoPaymentMethodEnum dto) {
    switch (dto) {
      case CartDtoPaymentMethodEnum.VNPAY:
        return CartPaymentMethodEnum.VNPAY;
      case CartDtoPaymentMethodEnum.INTERNAL_WALLET:
        return CartPaymentMethodEnum.INTERNAL_WALLET;
      case CartDtoPaymentMethodEnum.PAYPAL:
        return CartPaymentMethodEnum.PAYPAL;
      default:
        throw Exception('Unknown order status: $dto');
    }
  }
  /// Converts CartModel from domain to CartDto for API use
  static CartDto toDto(CartModel model) {
    final cartDto = CartDto();

    // Set shipping info ID if available
    if (model.shippingInfoId != null) {
      _setDynamicProperty(cartDto, 'shippingInfoId', model.shippingInfoId);
    }
    
    // Set voucher ID if available
    if (model.voucherId != null) {
      _setDynamicProperty(cartDto, 'voucherId', model.voucherId);
    }
    
    // Convert cart items if available
    if (model.items != null && model.items!.isNotEmpty) {
      final cartItems = model.items!
          .map((item) => _cartItemModelToDto(item))
          .toList();
          
      _setDynamicProperty(cartDto, 'cartItems', cartItems);
    }
    
    return cartDto;
  }
  
  static void _setDynamicProperty(dynamic object, String propertyName, dynamic value) {
    if (object == null) return;
    
    try {
      // Use dynamic to bypass type checking
      (object as dynamic).$propertyName = value;
    } catch (_) {
      // Property not found, try some common alternatives
      switch(propertyName) {
        case 'accountId':
          try { (object as dynamic).userId = value; } catch (_) {}
          break;
        case 'cartItems':
          try { (object as dynamic).items = value; } catch (_) {}
          break;
      }
    }
  }
  
  /// Extracts order ID from placeOrder response
  static int? extractOrderId(PlaceOrder200Response response) {
    // Extract order ID from response
    try {
      // Try different property access patterns to find the ID
      dynamic result;
      
      try { result = (response as dynamic).orderId; } catch (_) {}
      if (result != null) return _toInt(result);
      
      try { result = (response as dynamic).id; } catch (_) {}
      if (result != null) return _toInt(result);
      
      try { result = (response as dynamic).order?.id; } catch (_) {}
      if (result != null) return _toInt(result);
      
      return null;
    } catch (e) {
      print('Error extracting order ID: $e');
      return null;
    }
  }
  
  /// Helper to convert any value to int
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return int.tryParse(value.toString());
  }

  /// Converts CartItemDto to CartItemModel
  static CartItemModel _cartItemDtoToModel(CartItemDto dto) {
    // Extract values using dynamic access to avoid type errors
    int id = 0;
    int? skuId;
    int quantity = 1;
    
    try { id = _toInt((dto as dynamic).id) ?? 0; } catch (_) {}
    try { skuId = _toInt((dto as dynamic).skuId); } catch (_) {}
    try { quantity = _toInt((dto as dynamic).quantity) ?? 1; } catch (_) {}
    
    return CartItemModel(
      id: id,
      skuId: skuId,
      quantity: quantity,
      productName: '',
      price: 0.0,
      image: '',
    );
  }

  static CartItemDto _cartItemModelToDto(CartItemModel model) {
    final cartItemDto = CartItemDto();
    
    // Use dynamic property access to set fields
    _setDynamicProperty(cartItemDto, 'skuId', model.skuId);
    _setDynamicProperty(cartItemDto, 'quantity', model.quantity);
    
    return cartItemDto;
  }
} 