import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/promotion/promotion_bloc.dart';
import 'package:mobile/blocs/promotion/promotion_event.dart';
import 'package:mobile/blocs/promotion/promotion_state.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/di/injection.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter/foundation.dart';

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
            try {
              // Get the bloc directly from the dependency injection
              final promotionBloc = getIt<PromotionBloc>();
              // Trigger fetching promotions before showing the dialog
              promotionBloc.add(GetPromotions(1));
              _showVoucherSelectionDialog(
                context: context,
                selectedVoucher: selectedVoucher,
                onVoucherSelected: onVoucherSelected,
                promotionBloc: promotionBloc, // Pass the bloc instance
              );
            } catch (e) {
              debugPrint('Error loading promotions: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to load vouchers. Please try again.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
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
                    color: getColorSkin().white,
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
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: promotionBloc,
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

                if (state is PromotionLoadingState && state.error != null) {
                  debugPrint('Promotion loading error: ${state.error}');
                  String errorMessage = 'Unable to load vouchers';

                  // Try to extract a more user-friendly error message
                  if (state.error!.contains('Cannot get promotion information')) {
                    errorMessage = 'Cannot retrieve promotion information';
                  } else if (state.error!.contains('Failed to map API response')) {
                    errorMessage = 'Error processing promotion data';
                  } else if (state.error!.contains('DTO must be a valid response type')) {
                    errorMessage = 'Invalid promotion data format';
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'There was a problem loading the available vouchers. Please try again later.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PromotionBloc>().add(GetPromotions(1));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: getColorSkin().primaryRed650,
                          ),
                          child: const Text('Retry'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                }

                // Use actual promotions from API if available, otherwise show empty state
                List<PromotionModel> vouchers = [];

                if (state is PromotionDataState &&
                    state.promotionResponseModel != null &&
                    state.promotionResponseModel!.content.isNotEmpty) {
                  vouchers = state.promotionResponseModel!.content;
                  debugPrint('Loaded ${vouchers.length} vouchers successfully');
                } else {
                  debugPrint('No vouchers available or empty data state');
                }

                if (vouchers.isEmpty) {
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
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.confirmation_number_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No vouchers available',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  'There are currently no active promotions or vouchers available for your account.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              if (!(state is PromotionLoadingState))
                                const SizedBox(height: 24),
                              if (!(state is PromotionLoadingState))
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<PromotionBloc>().add(GetPromotions(1));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: getColorSkin().primaryRed650,
                                  ),
                                  child: const Text('Refresh'),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  );
                }

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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Save ${(voucher.discountRate ?? 0) * 100}% on your order'
                                ),
                                if (voucher.description != null && voucher.description!.isNotEmpty)
                                  Text(
                                    voucher.description!,
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (voucher.startDate != null && voucher.endDate != null)
                                  Text(
                                    'Valid: ${_formatDate(voucher.startDate!)} - ${_formatDate(voucher.endDate!)}',
                                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                                  ),
                              ],
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

// Helper function to format dates
String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}