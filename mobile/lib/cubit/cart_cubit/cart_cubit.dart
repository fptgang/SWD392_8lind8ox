import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final List<dynamic> decodedCart = jsonDecode(cartData);
      final cartItems = decodedCart.map((item) => CartItem.fromJson(item)).toList();
      debugPrint('Cart items: $cartItems');
      emit(state.copyWith(
        items: cartItems,
        isLoading: false,
      ));
    }
  }

  Future<void> addToCart(CartItem item) async {
    final currentItems = List<CartItem>.from(state.items);
    currentItems.add(item);
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
    await prefs.setString('cart', encodedCart);
  }

  Future<void> clearCart() async {
    emit(const CartState());
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
  }

  Future<void> updateQuantity(String blindBoxId, int newQuantity) async {
    if (newQuantity < 1) return;

    final currentItems = List<CartItem>.from(state.items);
    final itemIndex = currentItems.indexWhere((item) => item.id == blindBoxId);

    if (itemIndex != -1) {
      currentItems[itemIndex] = currentItems[itemIndex].copyWith(
        quantity: newQuantity,
      );
      emit(state.copyWith(items: currentItems));
      await _saveCartToLocalStorage(currentItems);
    }
  }

}
