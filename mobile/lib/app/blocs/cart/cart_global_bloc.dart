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
    debugPrint('🛒 CART: Loading cart from storage');
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      // Load cart items
      final cartJson = _prefs?.getString(_cartKey);
      List<CartItemModel> cartItems = [];

      if (cartJson != null && cartJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cartJson);
        cartItems =
            decoded.map((item) => CartItemModel.fromJson(item)).toList();
        debugPrint('🛒 CART: Loaded ${cartItems.length} items from storage');
      } else {
        debugPrint('🛒 CART: No cart items found in storage');
      }

      // Load selected items
      final selectedItemsJson = _prefs?.getString(_selectedItemsKey);
      Set<int> selectedItemIds = {};

      if (selectedItemsJson != null && selectedItemsJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(selectedItemsJson);
        selectedItemIds = decoded.map<int>((id) => id as int).toSet();
        debugPrint('🛒 CART: Loaded ${selectedItemIds.length} selected items');

        // Validate selected IDs against current cart items
        selectedItemIds = selectedItemIds
            .where((id) => cartItems.any((item) => item.id == id))
            .toSet();
        debugPrint(
            '🛒 CART: After validation, ${selectedItemIds.length} items remain selected');
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
        debugPrint(
            '🛒 CART: Loaded voucher: ${voucher.code} (${voucher.discountRate}%)');
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
        debugPrint('🛒 CART: Loaded shipping info for: ${shippingInfo.name}');
      }

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(cartItems);
      final total = _calculateTotal(cartItems);
      debugPrint(
          '🛒 CART: Calculated totals - Original: \$${originalTotal.toStringAsFixed(2)}, Final: \$${total.toStringAsFixed(2)}');

      emit(state.copyWith(
        items: cartItems,
        selectedItemIds: selectedItemIds,
        originalTotal: originalTotal,
        total: total,
        voucher: voucher,
        shippingInfo: shippingInfo,
        isLoading: false,
      ));
      debugPrint('🛒 CART: Cart loaded successfully');
    } catch (e) {
      debugPrint('❌ CART: Error loading cart: $e');
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
    debugPrint(
        '🛒 CART: Adding item to cart - SKU: ${event.item.skuId}, Slot: ${event.item.slotId}, Product: ${event.item.productName}');
    try {
      // Validate item
      if (event.item.skuId == null || event.item.price <= 0) {
        debugPrint(
            '❌ CART: Invalid item data - SKU: ${event.item.skuId}, Price: ${event.item.price}');
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
        debugPrint(
            '🛒 CART: Item already exists in cart, updating quantity from ${existingItem.quantity} to $newQuantity');

        // Check stock
        if (existingItem.skuId != null &&
            newQuantity <= (event.item.skuId ?? 0)) {
          currentItems[existingItemIndex] = existingItem.copyWith(
            quantity: newQuantity,
          );
        }
      } else {
        // Add new item
        debugPrint(
            '🛒 CART: Adding new item to cart with quantity ${event.item.quantity}');
        currentItems.add(event.item);
      }

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(currentItems);
      final total = _calculateTotal(currentItems);
      debugPrint(
          '🛒 CART: New totals - Original: \$${originalTotal.toStringAsFixed(2)}, Final: \$${total.toStringAsFixed(2)}');

      // Save to SharedPreferences
      await _saveCartItems(currentItems);
      debugPrint(
          '🛒 CART: Cart saved to storage with ${currentItems.length} items');

      emit(state.copyWith(
        items: currentItems,
        originalTotal: originalTotal,
        total: total,
        clearError: true,
      ));
      debugPrint('🛒 CART: Item added successfully');
    } catch (e) {
      debugPrint('❌ CART: Error adding item to cart: $e');
      emit(state.copyWith(
        error: 'Failed to add item to cart: $e',
      ));
    }
  }

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    debugPrint(
        '🛒 CART: Updating quantity - SKU: ${event.skuId}, Slot: ${event.slotId}, New Quantity: ${event.quantity}');
    try {
      final currentItems = List<CartItemModel>.from(state.items);
      final itemIndex = currentItems.indexWhere(
          (item) => item.skuId == event.skuId && item.slotId == event.slotId);
      final skuItem = await _skuRepository.getStockKeepingUnitById(
        event.skuId,
      );
      if (itemIndex == -1) {
        debugPrint('❌ CART: Item not found in cart');
        throw Exception('Item not found in cart');
      }

      final item = currentItems[itemIndex];
      debugPrint(
          '🛒 CART: Found item in cart, current quantity: ${item.quantity}');

      // Validate quantity against stock
      if (event.quantity <= 0) {
        debugPrint('❌ CART: Invalid quantity: ${event.quantity}');
        throw Exception('Invalid quantity');
      }
      // Check if quantity exceeds available stock
      if (event.quantity > (skuItem.stock ?? 0)) {
        debugPrint(
            '❌ CART: Requested quantity ${event.quantity} exceeds available stock: ${skuItem.stock}');
        throw Exception('Requested quantity exceeds available stock');
      }
      // Update item quantity
      currentItems[itemIndex] = item.copyWith(quantity: event.quantity);
      debugPrint(
          '🛒 CART: Updated quantity from ${item.quantity} to ${event.quantity}');

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(currentItems);
      final total = _calculateTotal(currentItems);
      debugPrint(
          '🛒 CART: New totals - Original: \$${originalTotal.toStringAsFixed(2)}, Final: \$${total.toStringAsFixed(2)}');

      // Save to SharedPreferences
      await _saveCartItems(currentItems);
      debugPrint('🛒 CART: Cart saved to storage');

      emit(state.copyWith(
        items: currentItems,
        originalTotal: originalTotal,
        total: total,
        clearError: true,
      ));
      debugPrint('🛒 CART: Item quantity updated successfully');
    } catch (e) {
      debugPrint('❌ CART: Error updating item quantity: $e');
      emit(state.copyWith(
        error: 'Failed to update item quantity: $e',
      ));
    }
  }

  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    debugPrint(
        '🛒 CART: Removing item - SKU: ${event.skuId}, Slot: ${event.slotId}');
    try {
      final currentItems = List<CartItemModel>.from(state.items);
      final itemToRemove = currentItems.firstWhere(
          (item) => item.skuId == event.skuId && item.slotId == event.slotId,
          orElse: () => CartItemModel(
              id: -1, productName: '', price: 0, image: '', quantity: 0));

      if (itemToRemove.id != -1) {
        debugPrint(
            '🛒 CART: Found item to remove: ${itemToRemove.productName}');
      } else {
        debugPrint('⚠️ CART: Item not found, nothing to remove');
      }

      final filteredItems = currentItems
          .where((item) =>
              item.skuId != event.skuId || item.slotId != event.slotId)
          .toList();

      debugPrint(
          '🛒 CART: Items reduced from ${currentItems.length} to ${filteredItems.length}');

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(filteredItems);
      final total = _calculateTotal(filteredItems);
      debugPrint(
          '🛒 CART: New totals - Original: \$${originalTotal.toStringAsFixed(2)}, Final: \$${total.toStringAsFixed(2)}');

      // Save to SharedPreferences
      await _saveCartItems(filteredItems);
      debugPrint('🛒 CART: Cart saved to storage');

      emit(state.copyWith(
        items: filteredItems,
        originalTotal: originalTotal,
        total: total,
        clearError: true,
      ));
      debugPrint('🛒 CART: Item removed successfully');
    } catch (e) {
      debugPrint('❌ CART: Error removing item from cart: $e');
      emit(state.copyWith(
        error: 'Failed to remove item from cart: $e',
      ));
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    debugPrint('🛒 CART: Clearing entire cart');
    try {
      // Clear SharedPreferences
      await _prefs?.remove(_cartKey);
      await _prefs?.remove(_voucherKey);
      await _prefs?.remove(_shippingInfoKey);
      debugPrint('🛒 CART: All cart data removed from storage');

      emit(const CartState());
      debugPrint('🛒 CART: Cart cleared successfully');
    } catch (e) {
      debugPrint('❌ CART: Error clearing cart: $e');
      emit(state.copyWith(
        error: 'Failed to clear cart: $e',
      ));
    }
  }

  Future<void> _onCleanInvalidItems(
    CleanInvalidItems event,
    Emitter<CartState> emit,
  ) async {
    debugPrint('🛒 CART: Cleaning invalid items from cart');
    try {
      final currentItems = List<CartItemModel>.from(state.items);
      debugPrint(
          '🛒 CART: Total items before cleaning: ${currentItems.length}');

      // Filter out invalid items (no SKU, no price, no stock, etc.)
      final validItems = currentItems
          .where((item) =>
              item.skuId != null && item.price > 0 && item.quantity > 0)
          .toList();

      final removedCount = currentItems.length - validItems.length;
      debugPrint('🛒 CART: Removed $removedCount invalid items');

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(validItems);
      final total = _calculateTotal(validItems);
      debugPrint(
          '🛒 CART: New totals - Original: \$${originalTotal.toStringAsFixed(2)}, Final: \$${total.toStringAsFixed(2)}');

      // Save to SharedPreferences
      await _saveCartItems(validItems);
      debugPrint('🛒 CART: Clean cart saved to storage');

      emit(state.copyWith(
        items: validItems,
        originalTotal: originalTotal,
        total: total,
        clearError: true,
      ));
      debugPrint('🛒 CART: Invalid items cleaned successfully');
    } catch (e) {
      debugPrint('❌ CART: Error cleaning invalid items: $e');
      emit(state.copyWith(
        error: 'Failed to clean invalid items: $e',
      ));
    }
  }

  Future<void> _onSetShippingInfo(
    SetShippingInfo event,
    Emitter<CartState> emit,
  ) async {
    debugPrint(
        '🛒 CART: Setting shipping info - Name: ${event.shippingInfo.name}, Phone: ${event.shippingInfo.phoneNumber}');
    try {
      // Validate shipping info
      if (event.shippingInfo.address == null ||
          event.shippingInfo.city == null ||
          event.shippingInfo.name == null ||
          event.shippingInfo.phoneNumber == null) {
        debugPrint('❌ CART: Missing required shipping information');
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
      debugPrint('🛒 CART: Shipping info saved to storage');

      emit(state.copyWith(
        shippingInfo: event.shippingInfo,
        clearError: true,
      ));
      debugPrint('🛒 CART: Shipping info set successfully');
    } catch (e) {
      debugPrint('❌ CART: Error setting shipping info: $e');
      emit(state.copyWith(
        error: 'Failed to set shipping info: $e',
      ));
    }
  }

  Future<void> _onSetVoucher(
    SetVoucher event,
    Emitter<CartState> emit,
  ) async {
    debugPrint(
        '🛒 CART: Setting voucher - Code: ${event.voucher.code}, Discount Rate: ${event.voucher.discountRate}%');
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
      debugPrint('🛒 CART: Voucher saved to storage');

      emit(state.copyWith(
        voucher: event.voucher,
        clearError: true,
      ));
      debugPrint('🛒 CART: Voucher set successfully');
    } catch (e) {
      debugPrint('❌ CART: Error setting voucher: $e');
      emit(state.copyWith(
        error: 'Failed to set voucher: $e',
      ));
    }
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<CartState> emit,
  ) async {
    debugPrint(
        '🛒 CART: Placing order - Payment Method: ${event.paymentMethod}');
    try {
      // Validate cart
      if (state.items.isEmpty) {
        debugPrint('❌ CART: Cart is empty');
        throw Exception('Cart is empty');
      }

      // Validate shipping info
      if (state.shippingInfo == null) {
        debugPrint('❌ CART: Missing shipping information');
        throw Exception('Missing shipping information');
      }

      debugPrint(
          '🛒 CART: Order validation passed, proceeding with ${state.items.length} items');
      emit(state.copyWith(isLoading: true, clearError: true));

      // Check if we're using selected items or all items
      final itemsToOrder =
          state.hasSelectedItems ? state.selectedItems : state.items;
      debugPrint('🛒 CART: Ordering ${itemsToOrder.length} items' +
          (state.hasSelectedItems ? ' (selected items only)' : ' (all items)'));

      // Convert cart to CartModel for API
      final cartModel = CartModel(
        shippingInfoId: state.shippingInfo!.shippingInfoId,
        voucherId: state.voucher?.voucherId,
        items: itemsToOrder
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

      debugPrint(
          '🛒 CART: Created order with payment method: ${event.paymentMethod}');
      debugPrint(
          '🛒 CART: Total order value: \$${state.total.toStringAsFixed(2)}');
      if (state.voucher != null) {
        debugPrint('🛒 CART: Using voucher: ${state.voucher!.code}');
      }

      // Place order using repository
      final OrderResponseModel response =
          await _orderRepository.createOrder(cartModel);
      debugPrint(
          '🛒 CART: Order placed successfully! Order: ${response.order != null ? "#" + response.order.toString() : "created"}');

      // Clear cart if payment was successful and doesn't need external redirect
      if (event.paymentMethod == 'INTERNAL_WALLET') {
        debugPrint('🛒 CART: Internal wallet payment, clearing cart');
        await _prefs?.remove(_cartKey);
        await _prefs?.remove(_voucherKey);
        await _prefs?.remove(_shippingInfoKey);

        emit(const CartState());
      } else {
        // For external payments, return to non-loading state but keep cart
        debugPrint(
            '🛒 CART: External payment (${event.paymentMethod}), keeping cart until confirmation');
        emit(state.copyWith(
          isLoading: false,
          error: null,
          orderResponse: response,
        ));
      }
    } catch (e) {
      debugPrint('❌ CART: Error placing order: $e');
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
    debugPrint('🛒 CART: Toggling selection for item ID: ${event.itemId}');
    try {
      final currentSelectedIds = Set<int>.from(state.selectedItemIds);
      final isCurrentlySelected = currentSelectedIds.contains(event.itemId);

      // Toggle selection
      if (isCurrentlySelected) {
        currentSelectedIds.remove(event.itemId);
        debugPrint('🛒 CART: Item ID ${event.itemId} deselected');
      } else {
        currentSelectedIds.add(event.itemId);
        debugPrint('🛒 CART: Item ID ${event.itemId} selected');
      }

      // Save to SharedPreferences
      _saveSelectedItems(currentSelectedIds);
      debugPrint('🛒 CART: Total selected items: ${currentSelectedIds.length}');

      emit(state.copyWith(
        selectedItemIds: currentSelectedIds,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('❌ CART: Error toggling item selection: $e');
      emit(state.copyWith(
        error: 'Failed to toggle item selection: $e',
      ));
    }
  }

  void _onSelectAllItems(
    SelectAllItems event,
    Emitter<CartState> emit,
  ) {
    debugPrint('🛒 CART: Selecting all items');
    try {
      // Get all item IDs from the cart
      final allItemIds = state.items.map((item) => item.id).toSet();
      debugPrint('🛒 CART: Selecting all ${allItemIds.length} items');

      // Save to SharedPreferences
      _saveSelectedItems(allItemIds);

      emit(state.copyWith(
        selectedItemIds: allItemIds,
        clearError: true,
      ));
      debugPrint('🛒 CART: All items selected successfully');
    } catch (e) {
      debugPrint('❌ CART: Error selecting all items: $e');
      emit(state.copyWith(
        error: 'Failed to select all items: $e',
      ));
    }
  }

  void _onDeselectAllItems(
    DeselectAllItems event,
    Emitter<CartState> emit,
  ) {
    debugPrint('🛒 CART: Deselecting all items');
    try {
      // Clear selected items
      _saveSelectedItems({});
      debugPrint('🛒 CART: Cleared all item selections');

      emit(state.copyWith(
        clearSelectedItems: true,
        clearError: true,
      ));
    } catch (e) {
      debugPrint('❌ CART: Error deselecting all items: $e');
      emit(state.copyWith(
        error: 'Failed to deselect all items: $e',
      ));
    }
  }

  Future<void> _saveSelectedItems(Set<int> selectedIds) async {
    try {
      final jsonString = jsonEncode(selectedIds.toList());
      await _prefs?.setString(_selectedItemsKey, jsonString);
      debugPrint(
          '🛒 CART: Saved ${selectedIds.length} selected items to storage');
    } catch (e) {
      debugPrint('❌ CART: Error saving selected items: $e');
    }
  }

  Future<void> _onRemoveSelectedItems(
    RemoveSelectedItems event,
    Emitter<CartState> emit,
  ) async {
    debugPrint(
        '🛒 CART: Removing all selected items (${state.selectedItems.length})');
    try {
      if (!state.hasSelectedItems) {
        debugPrint('🛒 CART: No items selected, nothing to remove');
        return; // Nothing to remove
      }

      // Filter out selected items
      final remainingItems = state.items
          .where((item) => !state.selectedItemIds.contains(item.id))
          .toList();
      debugPrint(
          '🛒 CART: Items reduced from ${state.items.length} to ${remainingItems.length}');

      // Calculate totals
      final originalTotal = _calculateOriginalTotal(remainingItems);
      final total = _calculateTotal(remainingItems);
      debugPrint(
          '🛒 CART: New totals - Original: \$${originalTotal.toStringAsFixed(2)}, Final: \$${total.toStringAsFixed(2)}');

      // Save to SharedPreferences
      await _saveCartItems(remainingItems);
      debugPrint('🛒 CART: Updated cart saved to storage');

      // Clear selected items
      await _saveSelectedItems({});
      debugPrint('🛒 CART: Cleared selection storage');

      emit(state.copyWith(
        items: remainingItems,
        originalTotal: originalTotal,
        total: total,
        clearSelectedItems: true,
        clearError: true,
      ));

      if (remainingItems.isEmpty) {
        // Clear voucher if cart is empty
        debugPrint('🛒 CART: Cart is now empty, clearing voucher');
        emit(state.copyWith(
          clearVoucher: true,
        ));
      }

      debugPrint('🛒 CART: Selected items removed successfully');
    } catch (e) {
      debugPrint('❌ CART: Error removing selected items: $e');
      emit(state.copyWith(
        error: 'Failed to remove selected items: $e',
      ));
    }
  }

  // Helper methods
  double _calculateOriginalTotal(List<CartItemModel> items) {
    final total =
        items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    debugPrint(
        '🛒 CART: Calculated original total: \$${total.toStringAsFixed(2)}');
    return total;
  }

  double _calculateTotal(List<CartItemModel> items) {
    // If any items have promotional pricing, this would differ from original total
    final total = items.fold(0.0, (sum, item) {
      // Use promotional price if available
      final itemPrice = item.price;
      return sum + (itemPrice * item.quantity);
    });
    debugPrint(
        '🛒 CART: Calculated final total: \$${total.toStringAsFixed(2)}');
    return total;
  }

  Future<void> _saveCartItems(List<CartItemModel> items) async {
    debugPrint('🛒 CART: Saving ${items.length} items to storage');
    final itemsJson = jsonEncode(
      items.map((item) => item.toJson()).toList(),
    );
    await _prefs?.setString(_cartKey, itemsJson);
    debugPrint('🛒 CART: Cart saved successfully');
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
