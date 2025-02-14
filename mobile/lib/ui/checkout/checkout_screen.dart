import 'package:flutter/material.dart';
import 'package:mobile/ui/checkout/widget/address_section.dart';
import 'package:mobile/ui/checkout/widget/order_summary.dart';
import 'package:mobile/ui/checkout/widget/payment_option.dart';
import 'package:mobile/ui/checkout/widget/product_section.dart';
import 'package:mobile/ui/checkout/widget/promotion_section.dart';
import 'package:mobile/ui/checkout/widget/protection_insurance.dart';
import 'package:mobile/ui/checkout/widget/shipping_method.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          buildAddressSection(),
          buildProductSection(),
          buildProtectionInsurance(),
          buildShippingMethod(),
          buildPromotionalSection(),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Phương thức thanh toán',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Xem tất cả',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                buildPaymentOption(
                  title: 'Ví ShopeePay',
                  icon: Icon(Icons.account_balance_wallet, color: Colors.red[400]),
                ),
                buildPaymentOption(
                  title: 'Tiền trong Ví',
                  icon: Icon(Icons.wallet, color: Colors.red[400]),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Nạp tiền',
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ),
                ),
                buildPaymentOption(
                  title: 'MB *2004',
                  icon: Icon(Icons.credit_card, color: Colors.blue[400]),
                  selected: true,
                ),
              ],
            ),
          ),

          // Order Summary Section
          buildSummarySection(),

          // Terms and Conditions
          Padding(
            padding: const EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                children: [
                  const TextSpan(text: 'Nhấn "Đặt hàng" đồng nghĩa với việc bạn đồng ý tuân theo '),
                  TextSpan(
                    text: 'Điều khoản Shopee',
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tổng thanh toán'),
                Text(
                  'đ56.050',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tiết kiệm đ58.950',
                  style: TextStyle(color: Colors.red[400], fontSize: 12),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                'Đặt hàng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}