import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final Function(bool success, String? transactionId)? onPaymentCompleted;

  static Route<bool> route({
    required String paymentUrl,
    Function(bool success, String? transactionId)? onPaymentCompleted,
  }) {
    return MaterialPageRoute(
      builder: (_) => VNPayWebViewScreen(
        paymentUrl: paymentUrl,
        onPaymentCompleted: onPaymentCompleted,
      ),
    );
  }

  const VNPayWebViewScreen({
    super.key,
    required this.paymentUrl,
    this.onPaymentCompleted,
  });

  @override
  State<VNPayWebViewScreen> createState() => _VNPayWebViewScreenState();
}

class _VNPayWebViewScreenState extends State<VNPayWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _initWebView();
    
    // Set a timeout for the payment (5 minutes)
    _timeoutTimer = Timer(const Duration(minutes: 5), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment timed out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        _completePayment(false);
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            
            // Check if the URL is the callback URL
            // This should match the callback URL configured in your backend
            if (url.contains('payment_success') || url.contains('vnp_ResponseCode')) {
              _handlePaymentCallback(url);
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentCallback(String url) {
    _timeoutTimer?.cancel();
    
    // Parse URL to determine if payment was successful
    bool isSuccess = false;
    String? transactionId;
    
    try {
      final uri = Uri.parse(url);
      final queryParams = uri.queryParameters;
      
      // VNPay response code '00' means success
      isSuccess = queryParams['vnp_ResponseCode'] == '00' || 
                 url.contains('payment_success');
      
      // Extract transaction ID if available
      transactionId = queryParams['vnp_TransactionNo'] ?? 
                      queryParams['vnp_TxnRef'];
      
      debugPrint('Payment result: success=$isSuccess, transactionId=$transactionId');
    } catch (e) {
      debugPrint('Error parsing payment response: $e');
      isSuccess = false;
    }
    
    _completePayment(isSuccess, transactionId);
  }
  
  void _completePayment(bool success, [String? transactionId]) {
    // Call the callback if provided
    widget.onPaymentCompleted?.call(success, transactionId);
    
    // Close the WebView and return result
    if (mounted) {
      Navigator.of(context).pop(success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VNPay Payment'),
        backgroundColor: getColorSkin().primaryRed650,
        foregroundColor: getColorSkin().white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Show confirmation dialog before canceling
            _showCancelConfirmationDialog();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: getColorSkin().primaryRed650,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading payment page...',
                    style: TextStyle(
                      color: getColorSkin().darkGrey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Payment?',
          style: TextStyle(
            color: getColorSkin().primaryRed800,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to cancel this payment? The transaction will not be completed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continue Payment',
              style: TextStyle(color: getColorSkin().grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _completePayment(false); // Complete with failure
            },
            child: Text(
              'Cancel Payment',
              style: TextStyle(color: getColorSkin().warningRed),
            ),
          ),
        ],
      ),
    );
  }
} 