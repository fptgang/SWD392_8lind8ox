// cart_global_bloc.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/blocs/cart/cart_event.dart';
import 'package:mobile/app/blocs/cart/cart_state.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:mobile/data/repositories/sku_repository.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
@lazySingleton
class CartGlobalBloc extends Bloc<CartEvent, CartState> {
  final OrderRepository _orderRepository;
  final SkuRepository _skuRepository;
  SharedPreferences? _prefs;
  final String _cartKey = 'cart_items';
  final String _voucherKey = 'cart_voucher';
  final String _shippingInfoKey = 'cart_shipping_info';
  final String _selectedItemsKey = 'cart_selected_items';

  CartGlobalBloc(OrderRepository orderRepository, SkuRepository skuRepository)
      : _orderRepository = orderRepository,
        _skuRepository = skuRepository,
        super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);
    on<CleanInvalidItems>(_onCleanInvalidItems);
    on<SetShippingInfo>(_onSetShippingInfo);
    on<SetVoucher>(_onSetVoucher);
    on<PlaceOrder>(_onPlaceOrder);
    on<ToggleItemSelection>(_onToggleItemSelection);
    on<SelectAllItems>(_onSelectAllItems);
    on<DeselectAllItems>(_onDeselectAllItems);
    on<RemoveSelectedItems>(_onRemoveSelectedItems);

    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    add(LoadCart());
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      // Load cart items
      final cartJson = _prefs?.getString(_cartKey);
      List<CartItemModel> cartItems = [];

      if (cartJson != null && cartJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cartJson);
        cartItems =
            decoded.map((item) => CartItemModel.fromJson(item)).toList();
      }

      // Load selected items
      final selectedItemsJson = _prefs?.getString(_selectedItemsKey);
      Set<int> selectedItemIds = {};
      
      if (selectedItemsJson != null && selectedItemsJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(selectedItemsJson);
        selectedItemIds = decoded.map<int>((id) => id as int).toSet();
        
        // Validate selected IDs against current cart items
        selectedItemIds = selectedItemIds
            .where((id) => cartItems.any((item) => item.id == id))
            .toSet();
      }

      // Load voucher
      final voucherJson = _prefs?.getString(_voucherKey);
      VoucherModel? voucher;
      if (voucherJson != null && voucherJson.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(voucherJson);
        voucher = VoucherModel(
          voucherId: decoded['voucherId'],
          code: decoded['code'],
          discountRate: decoded['discountRate'],
          limitAmount: decoded['limitAmount'],
          status: _mapVoucherStatus(decoded['status']),
        );
      }

      // Load shipping info
      final shippingInfoJson = _prefs?.getString(_shippingInfoKey);
      ShippingInfoModel? shippingInfo;
      if (shippingInfoJson != null && shippingInfoJson.isNotEmpty) {
        final Map<String, dynamic> decoded = jsonDecode(shippingInfoJson);
        shippingInfo = ShippingInfoModel(
          shippingInfoId: decoded['shippingInfoId'],
          address: decoded['address'],
          ward: decoded['ward'],
          district: decoded['district'],
          city: decoded['city'],
          name: decoded['name'],
          phoneNumber: decoded['phoneNumber'],
        );
      }

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(cartItems);
      final total = _calculateTotal(cartItems);

      emit(state.copyWith(
        items: cartItems,
        selectedItemIds: selectedItemIds,
        originalTotal: originalTotal,
        total: total,
        voucher: voucher,
        shippingInfo: shippingInfo,
        isLoading: false,
      ));
    } catch (e) {
      debugPrint('Error loading cart: $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load cart: $e',
      ));
    }
  }

  Future<void> _onAddItemToCart(
    AddItemToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Validate item
      if (event.item.skuId == null || event.item.price <= 0) {
        throw Exception('Invalid item data');
      }

      // Check if item already exists
      final currentItems = List<CartItemModel>.from(state.items);
      final existingItemIndex = currentItems.indexWhere((item) =>
          item.skuId == event.item.skuId && item.slotId == event.item.slotId);

      if (existingItemIndex != -1) {
        // Update existing item
        final existingItem = currentItems[existingItemIndex];
        final newQuantity = existingItem.quantity + event.item.quantity;

        // Check stock
        if (existingItem.skuId != null &&
            newQuantity <= (event.item.skuId ?? 0)) {
          currentItems[existingItemIndex] = existingItem.copyWith(
            quantity: newQuantity,
          );
        }
      } else {
        // Add new item
        currentItems.add(event.item);
      }

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(currentItems);
      final total = _calculateTotal(currentItems);

      // Save to SharedPreferences
      await _saveCartItems(currentItems);

      emit(state.copyWith(
        items: currentItems,
        originalTotal: originalTotal,
        total: total,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('Error adding item to cart: $e');
      emit(state.copyWith(
        error: 'Failed to add item to cart: $e',
      ));
    }
  }

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentItems = List<CartItemModel>.from(state.items);
      final itemIndex = currentItems.indexWhere(
          (item) => item.skuId == event.skuId && item.slotId == event.slotId);
      final skuItem = await _skuRepository.getStockKeepingUnitById(
        event.skuId,
      );
      if (itemIndex == -1) {
        throw Exception('Item not found in cart');
      }

      final item = currentItems[itemIndex];

      // Validate quantity against stock
      if (event.quantity <= 0) {
        throw Exception('Invalid quantity');
      }
// Check if quantity exceeds available stock
      if (event.quantity > (skuItem.stock ?? 0)) {
        throw Exception('Requested quantity exceeds available stock');
      }
      // Update item quantity
      currentItems[itemIndex] = item.copyWith(quantity: event.quantity);

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(currentItems);
      final total = _calculateTotal(currentItems);

      // Save to SharedPreferences
      await _saveCartItems(currentItems);

      emit(state.copyWith(
        items: currentItems,
        originalTotal: originalTotal,
        total: total,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('Error updating item quantity: $e');
      emit(state.copyWith(
        error: 'Failed to update item quantity: $e',
      ));
    }
  }

  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentItems = List<CartItemModel>.from(state.items);
      final filteredItems = currentItems
          .where((item) =>
              item.skuId != event.skuId || item.slotId != event.slotId)
          .toList();

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(filteredItems);
      final total = _calculateTotal(filteredItems);

      // Save to SharedPreferences
      await _saveCartItems(filteredItems);

      emit(state.copyWith(
        items: filteredItems,
        originalTotal: originalTotal,
        total: total,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('Error removing item from cart: $e');
      emit(state.copyWith(
        error: 'Failed to remove item from cart: $e',
      ));
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Clear SharedPreferences
      await _prefs?.remove(_cartKey);
      await _prefs?.remove(_voucherKey);
      await _prefs?.remove(_shippingInfoKey);

      emit(const CartState());
    } catch (e) {
      debugPrint('Error clearing cart: $e');
      emit(state.copyWith(
        error: 'Failed to clear cart: $e',
      ));
    }
  }

  Future<void> _onCleanInvalidItems(
    CleanInvalidItems event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentItems = List<CartItemModel>.from(state.items);

      // Filter out invalid items (no SKU, no price, no stock, etc.)
      final validItems = currentItems
          .where((item) =>
              item.skuId != null && item.price > 0 && item.quantity > 0)
          .toList();

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(validItems);
      final total = _calculateTotal(validItems);

      // Save to SharedPreferences
      await _saveCartItems(validItems);

      emit(state.copyWith(
        items: validItems,
        originalTotal: originalTotal,
        total: total,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('Error cleaning invalid items: $e');
      emit(state.copyWith(
        error: 'Failed to clean invalid items: $e',
      ));
    }
  }

  Future<void> _onSetShippingInfo(
    SetShippingInfo event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Validate shipping info
      if (event.shippingInfo.address == null ||
          event.shippingInfo.city == null ||
          event.shippingInfo.name == null ||
          event.shippingInfo.phoneNumber == null) {
        throw Exception('Missing required shipping information');
      }

      // Save to SharedPreferences
      final shippingInfoJson = jsonEncode({
        'shippingInfoId': event.shippingInfo.shippingInfoId,
        'address': event.shippingInfo.address,
        'ward': event.shippingInfo.ward,
        'district': event.shippingInfo.district,
        'city': event.shippingInfo.city,
        'name': event.shippingInfo.name,
        'phoneNumber': event.shippingInfo.phoneNumber,
      });
      await _prefs?.setString(_shippingInfoKey, shippingInfoJson);

      emit(state.copyWith(
        shippingInfo: event.shippingInfo,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('Error setting shipping info: $e');
      emit(state.copyWith(
        error: 'Failed to set shipping info: $e',
      ));
    }
  }

  Future<void> _onSetVoucher(
    SetVoucher event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Save to SharedPreferences
      final voucherJson = jsonEncode({
        'voucherId': event.voucher.voucherId,
        'code': event.voucher.code,
        'discountRate': event.voucher.discountRate,
        'limitAmount': event.voucher.limitAmount,
        'status': _voucherStatusToString(event.voucher.status),
      });
      await _prefs?.setString(_voucherKey, voucherJson);

      emit(state.copyWith(
        voucher: event.voucher,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('Error setting voucher: $e');
      emit(state.copyWith(
        error: 'Failed to set voucher: $e',
      ));
    }
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Validate cart
      if (state.items.isEmpty) {
        throw Exception('Cart is empty');
      }

      // Validate shipping info
      if (state.shippingInfo == null) {
        throw Exception('Missing shipping information');
      }

      emit(state.copyWith(isLoading: true, clearError: true));

      // Convert cart to CartModel for API
      final cartModel = CartModel(
        shippingInfoId: state.shippingInfo!.shippingInfoId,
        voucherId: state.voucher?.voucherId,
        items: state.hasSelectedItems
            ? state.selectedItems
                .map((item) => CartItemModel(
                      id: item.id,
                      productName: item.productName,
                      price: item.price,
                      image: item.image,
                      quantity: item.quantity,
                      skuId: item.skuId,
                      slotId: item.slotId,
                    ))
                .toList()
            : state.items
                .map((item) => CartItemModel(
                      id: item.id,
                      productName: item.productName,
                      price: item.price,
                      image: item.image,
                      quantity: item.quantity,
                      skuId: item.skuId,
                      slotId: item.slotId,
                    ))
                .toList(),
        paymentMethod: _mapPaymentMethod(event.paymentMethod),
      );

      // Place order using repository
      final OrderResponseModel response =
          await _orderRepository.createOrder(cartModel);

      // Clear cart if payment was successful and doesn't need external redirect
      if (event.paymentMethod == 'INTERNAL_WALLET') {
        await _prefs?.remove(_cartKey);
        await _prefs?.remove(_voucherKey);
        await _prefs?.remove(_shippingInfoKey);

        emit(const CartState());
      } else {
        // For external payments, return to non-loading state but keep cart
        emit(state.copyWith(
          isLoading: false,
          error: null,
        ));
      }
    } catch (e) {
      debugPrint('Error placing order: $e');
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to place order: $e',
      ));
    }
  }

  void _onToggleItemSelection(
    ToggleItemSelection event,
    Emitter<CartState> emit,
  ) {
    try {
      final currentSelectedIds = Set<int>.from(state.selectedItemIds);
      
      // Toggle selection
      if (currentSelectedIds.contains(event.itemId)) {
        currentSelectedIds.remove(event.itemId);
      } else {
        currentSelectedIds.add(event.itemId);
      }
      
      // Save to SharedPreferences
      _saveSelectedItems(currentSelectedIds);
      
      emit(state.copyWith(
        selectedItemIds: currentSelectedIds,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('Error toggling item selection: $e');
      emit(state.copyWith(
        error: 'Failed to toggle item selection: $e',
      ));
    }
  }
  
  void _onSelectAllItems(
    SelectAllItems event,
    Emitter<CartState> emit,
  ) {
    try {
      // Get all item IDs from the cart
      final allItemIds = state.items.map((item) => item.id).toSet();
      
      // Save to SharedPreferences
      _saveSelectedItems(allItemIds);
      
      emit(state.copyWith(
        selectedItemIds: allItemIds,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('Error selecting all items: $e');
      emit(state.copyWith(
        error: 'Failed to select all items: $e',
      ));
    }
  }
  
  void _onDeselectAllItems(
    DeselectAllItems event,
    Emitter<CartState> emit,
  ) {
    try {
      // Clear selected items
      _saveSelectedItems({});
      
      emit(state.copyWith(
        clearSelectedItems: true,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('Error deselecting all items: $e');
      emit(state.copyWith(
        error: 'Failed to deselect all items: $e',
      ));
    }
  }
  
  Future<void> _saveSelectedItems(Set<int> selectedIds) async {
    try {
      final jsonString = jsonEncode(selectedIds.toList());
      await _prefs?.setString(_selectedItemsKey, jsonString);
    } catch (e) {
      debugPrint('Error saving selected items: $e');
    }
  }

  Future<void> _onRemoveSelectedItems(
    RemoveSelectedItems event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (!state.hasSelectedItems) {
        return; // Nothing to remove
      }
      
      // Filter out selected items
      final remainingItems = state.items
          .where((item) => !state.selectedItemIds.contains(item.id))
          .toList();
          
      // Calculate totals
      final originalTotal = _calculateOriginalTotal(remainingItems);
      final total = _calculateTotal(remainingItems);
      
      // Save to SharedPreferences
      await _saveCartItems(remainingItems);
      
      // Clear selected items
      await _saveSelectedItems({});
      
      emit(state.copyWith(
        items: remainingItems,
        originalTotal: originalTotal,
        total: total,
        clearSelectedItems: true,
        clearError: true,
      ));
      
      if (remainingItems.isEmpty) {
        // Clear voucher if cart is empty
        emit(state.copyWith(
          clearVoucher: true,
        ));
      }
    } catch (e) {
      debugPrint('Error removing selected items: $e');
      emit(state.copyWith(
        error: 'Failed to remove selected items: $e',
      ));
    }
  }

  // Helper methods
  double _calculateOriginalTotal(List<CartItemModel> items) {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double _calculateTotal(List<CartItemModel> items) {
    // If any items have promotional pricing, this would differ from original total
    return items.fold(0.0, (sum, item) {
      // Use promotional price if available
      final itemPrice = item.price;
      return sum + (itemPrice * item.quantity);
    });
  }

  Future<void> _saveCartItems(List<CartItemModel> items) async {
    final itemsJson = jsonEncode(
      items.map((item) => item.toJson()).toList(),
    );
    await _prefs?.setString(_cartKey, itemsJson);
  }

  String _voucherStatusToString(VoucherStatusEnum? status) {
    if (status == null) return 'AVAILABLE';

    switch (status) {
      case VoucherStatusEnum.USED:
        return 'USED';
      case VoucherStatusEnum.RESERVED:
        return 'RESERVED';
      case VoucherStatusEnum.AVAILABLE:
        return 'AVAILABLE';
    }
  }

  VoucherStatusEnum _mapVoucherStatus(String? status) {
    if (status == null) return VoucherStatusEnum.AVAILABLE;
    switch (status) {
      case 'USED':
        return VoucherStatusEnum.USED;
      case 'RESERVED':
        return VoucherStatusEnum.RESERVED;
      case 'AVAILABLE':
      default:
        return VoucherStatusEnum.AVAILABLE;
    }
  }

  CartPaymentMethodEnum _mapPaymentMethod(String paymentMethod) {
    switch (paymentMethod) {
      case 'INTERNAL_WALLET':
        return CartPaymentMethodEnum.INTERNAL_WALLET;
      case 'PAYPAL':
        return CartPaymentMethodEnum.PAYPAL;
      case 'VNPAY':
      default:
        return CartPaymentMethodEnum.VNPAY;
    }
  }
}
