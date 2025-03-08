import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/order_mapper.dart';
import 'package:mobile/data/mapper/cart_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

import '../../../di/injection.dart';

class OrderRepositoryImpl implements OrderRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  OrderRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    try{
      OrderDto? orderDto = await _apiService.getOrderById(orderId);
      if(orderDto == null){
        debugPrint('Cannot get order information: , orderDto: $orderDto');
        throw Exception('Cannot get order information');
      }
      OrderModel orderModel = OrderMapper.toModel(orderDto);
      return orderModel;
    } catch(e){
      debugPrint('Cannot get order information: $e');
      throw Exception('Cannot get order information');
    }
  }

  @override
  Future<PaginationResponseGeneric<OrderModel>> getOrders(Pageable pageable, String filter, String search) async {
    try{
      GetOrders200Response? response = await _apiService.getOrders(pageable: pageable, filter: filter, search: search);
      if(response == null){
        debugPrint('Cannot get order information: , response: $response');
        throw Exception('Cannot get order information');
      }
      PaginationResponseGeneric<OrderModel>? orderModels = PaginationResponseMapper.toModel(dto: response, fromDTO: (data) => OrderMapper.toModel(data));
      return orderModels;
    } catch(e){
      debugPrint('Cannot get order information: $e');
      throw Exception('Cannot get order information');
    }
  }

  @override
  Future<OrderResponseModel> createOrder(CartModel cartModel, int accountId) async {
    try {
      final cartDto = CartMapper.toDto(cartModel);
      
      final response = await _apiService.placeOrder(cartDto, accountId: accountId);

      if (response == null) {
        throw Exception('Failed to create order');
      }
      
      final orderId = CartMapper.extractOrderId(response);
      
      if (orderId == null) {
        throw Exception('Failed to extract order ID from response');
      }
      
      final orderModel = await getOrderById(orderId);
      
      return OrderResponseModel(
        order: orderModel,
        paymentRedirectUrl: _extractPaymentUrl(response),
      );
    } catch (e) {
      debugPrint('Failed to create order: $e');
      throw Exception('Failed to create order: $e');
    }
  }
  
  /// Extract payment URL from the response
  String? _extractPaymentUrl(PlaceOrder200Response response) {
    try {
      return (response as dynamic).paymentRedirectUrl as String?;
    } catch (e) {
      debugPrint('Error extracting payment URL: $e');
      return null;
    }
  }
}
