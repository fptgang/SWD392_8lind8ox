import 'package:flutter/material.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:mobile/feature/payment/vnpay_webview_screen.dart';

class VNPayService {
  static Future<bool> processPayment(
    BuildContext context, {
    required OrderResponseModel orderResponse,
  }) async {
    if (orderResponse.paymentRedirectUrl == null ||
        orderResponse.paymentRedirectUrl!.isEmpty) {
      _showMessage(context, 'No payment URL provided');
      return false;
    }

    if (orderResponse.order == null) {
      _showMessage(context, 'Order information missing');
      return false;
    }
    try {
      final result = await Navigator.of(context).push<bool>(
        VNPayWebViewScreen.route(
            paymentUrl: orderResponse.paymentRedirectUrl!,
            onPaymentCompleted: (success, transactionId) {
              debugPrint(
                  'Payment completed: success=$success, transaction=$transactionId');
              if (success) {
                _showMessage(context, 'Payment successful');
              } else {
                _showMessage(context, 'Payment failed');
              }
            }),
      );

      return result ?? false;
    } catch (e) {
      debugPrint('Error processing VNPay payment: $e');
      return false;
    }
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
