import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_state.dart';

@injectable
@lazySingleton
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final List<dynamic> decodedCart = jsonDecode(cartData);
      final cartItems = decodedCart.map((item) => CartItem.fromJson(item)).toList();
      debugPrint('Cart items: ${cartItems.toString()}');
      emit(state.copyWith(
        items: cartItems,
        isLoading: false,
      ));
    }
  }

  // Future<void> addToCart(CartItem item) async {
  //   final currentItems = state.items;
  //   currentItems.add(item);
  //   emit(state.copyWith(items: currentItems));
  //   await _saveCartToLocalStorage(currentItems);
  // }

  Future<void> addToCart(CartItem item) async {
    final currentItems = List<CartItem>.from(state.items); // Create a new list to avoid direct state mutation

    final existingItemIndex = currentItems.indexWhere((existingItem) => existingItem.id == item.id);

    if (existingItemIndex != -1) {
      final existingItem = currentItems[existingItemIndex];
      currentItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      debugPrint('Adding new item to cart: $item');
      currentItems.add(item);
    }

    emit(state.copyWith(items: currentItems));
    await _saveCartToLocalStorage(currentItems);
  }

  Future<void> removeFromCart(String uniqueId) async {
    final currentItems = state.items.where((item) => item.id != uniqueId).toList();
    emit(state.copyWith(items: currentItems));
    await _saveCartToLocalStorage(currentItems);
  }

  Future<void> _saveCartToLocalStorage(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedCart = jsonEncode(items.map((item) => item.toJson()).toList());
    debugPrint('Cart length: ${items.length}'); // Add this line to check number of items
    debugPrint('Individual items in cart:'); // Add this line
    items.forEach((item) => debugPrint('Item: ${item.productName}, Quantity: ${item.quantity}')); // Add this line
    debugPrint('Full encoded cart: $encodedCart');
    await prefs.setString('cart', encodedCart);
  }

  Future<void> clearCart() async {
    emit(const CartState());
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
  }

  Future<void> updateQuantity(String blindBoxId, int newQuantity) async {
    debugPrint('Updating quantity for item $blindBoxId to $newQuantity');
    if (newQuantity < 1) {
      debugPrint('Invalid quantity: $newQuantity');
      return;
    }

    final currentItems = List<CartItem>.from(state.items);
    debugPrint('Current items in cart: ${currentItems.length}');

    final itemIndex = currentItems.indexWhere((item) => item.id.toString() == blindBoxId);
    debugPrint('Found item at index: $itemIndex');

    if (itemIndex != -1) {
      final oldQuantity = currentItems[itemIndex].quantity;
      currentItems[itemIndex] = currentItems[itemIndex].copyWith(
        quantity: newQuantity,
      );
      debugPrint('Updated quantity from $oldQuantity to ${currentItems[itemIndex].quantity}');

      emit(state.copyWith(items: currentItems));
      await _saveCartToLocalStorage(currentItems);
    } else {
      debugPrint('Item not found with id: $blindBoxId');
    }
  }
}
