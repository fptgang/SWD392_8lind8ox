import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/promotion/promotion_bloc.dart';
import 'package:mobile/blocs/promotion/promotion_state.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/di/injection.dart';

Widget buildPromotionalSection({
  required BuildContext context,
  PromotionModel? selectedVoucher,
  required Function(PromotionModel?) onVoucherSelected,
}) {
  return Container(
    color: Colors.white,
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vouchers & Promotions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            // Get the bloc directly from the dependency injection
            final promotionBloc = getIt<PromotionBloc>();
            _showVoucherSelectionDialog(
              context: context, 
              selectedVoucher: selectedVoucher,
              onVoucherSelected: onVoucherSelected,
              promotionBloc: promotionBloc, // Pass the bloc instance
            );
          },
          child: Row(
            children: [
              Icon(Icons.confirmation_number_outlined, color: Colors.red[400]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedVoucher != null 
                    ? '${selectedVoucher.title} (${(selectedVoucher.discountRate ?? 0) * 100}% off)'
                    : 'Select Voucher',
                ),
              ),
              if (selectedVoucher != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-\$${calculateDiscount(selectedVoucher).toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                )
              else 
                const Text('No voucher applied', style: TextStyle(color: Colors.grey)),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    ),
  );
}

// Helper to calculate discount amount based on rate
double calculateDiscount(PromotionModel voucher) {
  // In a real app, this would be calculated based on the order total
  // For simplicity, we'll assume a fixed discount amount
  return (voucher.discountRate ?? 0) * 100; // Just an example value
}

void _showVoucherSelectionDialog({
  required BuildContext context,
  required PromotionModel? selectedVoucher,
  required Function(PromotionModel?) onVoucherSelected,
  required PromotionBloc promotionBloc, // Add this parameter
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: promotionBloc, // Use the passed bloc instance
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return BlocBuilder<PromotionBloc, PromotionState>(
              builder: (context, state) {
                if (state is PromotionLoadingState && state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // This would normally be populated from state.promotions
                // For demo purposes, we'll create some sample vouchers
                final List<PromotionModel> vouchers = _getSampleVouchers();
                
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Select Voucher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: vouchers.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final voucher = vouchers[index];
                          final isSelected = selectedVoucher?.campaignId == voucher.campaignId;
                          
                          return ListTile(
                            leading: Icon(
                              Icons.confirmation_number,
                              color: Colors.red[400],
                            ),
                            title: Text(voucher.title ?? 'Untitled Voucher'),
                            subtitle: Text(
                              'Save ${(voucher.discountRate ?? 0) * 100}% on your order'
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check_circle, color: Colors.green[600])
                                : null,
                            selected: isSelected,
                            onTap: () {
                              onVoucherSelected(voucher);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          onVoucherSelected(null);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Remove Voucher'),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );
}

// Sample vouchers for demonstration
List<PromotionModel> _getSampleVouchers() {
  return [
    PromotionModel(
      campaignId: 1,
      title: 'New User Discount',
      description: 'Special discount for new users',
      discountRate: 0.15, // 15%
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      isVisible: true,
    ),
    PromotionModel(
      campaignId: 2,
      title: 'Weekend Sale',
      description: 'Special discount for weekend shoppers',
      discountRate: 0.10, // 10%
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
      isVisible: true,
    ),
    PromotionModel(
      campaignId: 3,
      title: 'Free Shipping',
      description: 'Free shipping on your order',
      discountRate: 0.05, // 5% (representing shipping cost)
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 14)),
      isVisible: true,
    ),
  ];
}