import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_state.dart';

// Ensure we use the CartDisplayItem from cart_model.dart
export 'package:mobile/data/models/cart_model.dart';

@injectable
@lazySingleton
class CartCubit extends Cubit<CartState> {
  bool _isClosed = false;
  SharedPreferences? _prefs;

  CartCubit() : super(const CartState()) {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await loadCart();
  }

  @override
  void emit(CartState state) {
    if (!_isClosed) {
      super.emit(state);
    } else {
      debugPrint('Warning: Attempted to emit state after CartCubit was closed');
    }
  }

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  Future<void> loadCart() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();

      final cartData = _prefs!.getString('cart');
      if (cartData != null) {
        final List<dynamic> decodedCart = jsonDecode(cartData);

        // Convert JSON to CartDisplayItem objects
        final List<CartDisplayItem> cartItems = decodedCart.map((item) {
          return CartDisplayItem(
            id: item['id'],
            productName: item['productName'],
            price: (item['price'] is int)
                ? (item['price'] as int).toDouble()
                : item['price'],
            image: item['image'],
            quantity: item['quantity'],
            skuId: item['skuId'],
            slotId: item['slotId'],
          );
        }).toList();
        debugPrint('Cart items loaded: ${cartItems.toString()}');
        debugPrint('Cart items loaded: ${cartItems.length}');

        if (!_isClosed) {
          emit(state.copyWith(items: cartItems));
        }
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> addToCart(CartDisplayItem item) async {
    try {
      // Ensure we have preferences
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }

      // Get current cart data
      final cartData = _prefs!.getString('cart');
      List<CartDisplayItem> currentItems = [];

      if (cartData != null) {
        final List<dynamic> decodedCart = jsonDecode(cartData);

        // Convert JSON to CartDisplayItem objects
        currentItems = decodedCart.map((item) {
          return CartDisplayItem(
            id: item['id'],
            productName: item['productName'],
            price: (item['price'] is int)
                ? (item['price'] as int).toDouble()
                : item['price'],
            image: item['image'],
            quantity: item['quantity'],
            skuId: item['skuId'],
            slotId: item['slotId'],
          );
        }).toList();
      }

      // Check if item already exists
      final existingItemIndex =
          currentItems.indexWhere((existingItem) => existingItem.id == item.id);

      if (existingItemIndex != -1) {
        final existingItem = currentItems[existingItemIndex];
        currentItems[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
        );
        debugPrint('Updated quantity for existing item: ${item.productName}');
      } else {
        debugPrint('Adding new item to cart: ${item.productName}');
        currentItems.add(item);
      }

      // Save to SharedPreferences - but persist even if cubit is closed
      final encodedCart =
          jsonEncode(currentItems.map((item) => item.toJson()).toList());
      await _prefs!.setString('cart', encodedCart);

      // Only emit if the cubit is not closed
      if (!_isClosed) {
        emit(state.copyWith(items: currentItems));
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }

      final cartData = _prefs!.getString('cart');

      if (cartData != null) {
        final List<dynamic> decodedCart = jsonDecode(cartData);

        // Convert and filter items
        final List<CartDisplayItem> currentItems = decodedCart
            .map((item) {
              return CartDisplayItem(
                id: item['id'],
                productName: item['productName'],
                price: (item['price'] is int)
                    ? (item['price'] as int).toDouble()
                    : item['price'],
                image: item['image'],
                quantity: item['quantity'],
                skuId: item['skuId'],
                slotId: item['slotId'],
              );
            })
            .where((item) => item.id != itemId)
            .toList();

        final encodedCart =
            jsonEncode(currentItems.map((item) => item.toJson()).toList());
        await _prefs!.setString('cart', encodedCart);

        if (!_isClosed) {
          emit(state.copyWith(items: currentItems));
        }
      }
    } catch (e) {
      debugPrint('Error removing from cart: $e');
    }
  }

  Future<void> updateQuantity(int itemId, int newQuantity) async {
    try {
      if (newQuantity < 1) {
        debugPrint('Invalid quantity: $newQuantity');
        return;
      }

      _prefs ??= await SharedPreferences.getInstance();

      final cartData = _prefs!.getString('cart');

      if (cartData != null) {
        final List<dynamic> decodedCart = jsonDecode(cartData);

        // Convert JSON to CartDisplayItem objects
        final List<CartDisplayItem> currentItems = decodedCart.map((item) {
          return CartDisplayItem(
            id: item['id'],
            productName: item['productName'],
            price: (item['price'] is int)
                ? (item['price'] as int).toDouble()
                : item['price'],
            image: item['image'],
            quantity: item['quantity'],
            skuId: item['skuId'],
            slotId: item['slotId'],
          );
        }).toList();
        debugPrint('currentItems: $currentItems');
        final itemIndex = currentItems.indexWhere((item) => item.id == itemId);
        if (itemIndex != -1) {
          currentItems[itemIndex] =
              currentItems[itemIndex].copyWith(quantity: newQuantity);

          final encodedCart =
              jsonEncode(currentItems.map((item) => item.toJson()).toList());
          await _prefs!.setString('cart', encodedCart);
          if (!_isClosed) {
            emit(state.copyWith(items: currentItems));
          }
        }
      }
    } catch (e) {
      debugPrint('Error updating quantity: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();

      await _prefs!.remove('cart');

      if (!_isClosed) {
        emit(const CartState());
      }
    } catch (e) {
      debugPrint('Error clearing cart: $e');
    }
  }

  // Make sure cart is in sync with storage, call after navigation
  Future<void> refreshCart() async {
    if (!_isClosed) {
      await loadCart();
    }
  }

  // Toggle selection of a specific item
  void toggleItemSelection(int itemId) {
    try {
      final currentSelectedIds = List<int>.from(state.selectedItemIds);

      if (currentSelectedIds.contains(itemId)) {
        currentSelectedIds.remove(itemId);
      } else {
        currentSelectedIds.add(itemId);
      }

      emit(state.copyWith(selectedItemIds: currentSelectedIds));
      debugPrint(
          'Item $itemId selection toggled. Now selected: ${currentSelectedIds.contains(itemId)}');
    } catch (e) {
      debugPrint('Error toggling item selection: $e');
    }
  }

  // Select all items
  void selectAllItems() {
    try {
      final allItemIds = state.items.map((item) => item.id).toList();
      emit(state.copyWith(selectedItemIds: allItemIds as List<int>));
      debugPrint('All ${allItemIds.length} items selected');
    } catch (e) {
      debugPrint('Error selecting all items: $e');
    }
  }

  // Deselect all items
  void deselectAllItems() {
    try {
      emit(state.copyWith(selectedItemIds: <int>[]));
      debugPrint('All items deselected');
    } catch (e) {
      debugPrint('Error deselecting all items: $e');
    }
  }

  // Toggle select all/none
  void toggleSelectAll() {
    try {
      if (state.selectedItemIds.length == state.items.length) {
        deselectAllItems();
      } else {
        selectAllItems();
      }
    } catch (e) {
      debugPrint('Error toggling select all: $e');
    }
  }
}
