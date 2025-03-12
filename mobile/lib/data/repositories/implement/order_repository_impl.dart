import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/data/mapper/cart_mapper.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/order_mapper.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:openapi/api.dart';

import '../../../di/injection.dart';

class OrderRepositoryImpl implements OrderRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  OrderRepositoryImpl(){
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
      debugPrint('token from order repo: ${box.get('loginToken')}');
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
      
      debugPrint('Making placeOrder request with:');
      debugPrint('- AccountId: $accountId');
      debugPrint('- CartDto payment method: ${cartDto.paymentMethod}');
      debugPrint('- CartDto shipping info ID: ${cartDto.shippingInfoId}');
      debugPrint('- CartDto items count: ${cartDto.items.length}');
      debugPrint('- CartDto first item skuId: ${cartDto.items.isNotEmpty ? cartDto.items.first.skuId : "N/A"}');
      debugPrint('- CartDto first item quantity: ${cartDto.items.isNotEmpty ? cartDto.items.first.quantity : "N/A"}');
      debugPrint('token from order repo create: ${box.get('loginToken')}');
      debugPrint('Calling API placeOrder endpoint...');
      final response = await _apiService.placeOrder(cartDto, accountId: accountId);
      debugPrint('API call completed, response: $response, accountId: $accountId');
      debugPrint('Received response from placeOrder');

      if (response == null) {
        throw Exception('Failed to create order: null response');
      }
      
      final orderId = CartMapper.extractOrderId(response);
      
      if (orderId == null) {
        throw Exception('Failed to extract order ID from response');
      }
      
      debugPrint('Successfully extracted orderId: $orderId');
      final orderModel = await getOrderById(orderId);
      
      return OrderResponseModel(
        order: orderModel,
        paymentRedirectUrl: _extractPaymentUrl(response),
      );
    } catch (e) {
      if (e is ApiException) {
        final apiError = e;
        debugPrint('API Exception during createOrder:');
        debugPrint('- Status code: ${apiError.code}');
        debugPrint('- Message: ${apiError.message}');
        debugPrint('- Response: ${apiError.toString()}');
        // Check if there are specific error codes that indicate auth issues
        if (apiError.code == 401) {
          debugPrint('Authentication failure - token may be expired or invalid');
        }
      }
      
      debugPrint('F ailed to create order: $e');
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
