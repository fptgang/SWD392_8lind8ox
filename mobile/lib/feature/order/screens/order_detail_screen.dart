import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/common/widgets/common_loading.dart';
import 'package:mobile/base/common/widgets/error.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/order/blocs/order/order_bloc.dart';
import 'package:mobile/feature/order/blocs/order/order_event.dart';
import 'package:mobile/feature/order/blocs/order/order_state.dart';
import 'package:mobile/feature/order/blocs/video/video_bloc.dart';
import 'package:mobile/feature/order/widgets/order_detail/action_button.dart';
import 'package:mobile/feature/order/widgets/order_detail/delivery_information_card.dart';
import 'package:mobile/feature/order/widgets/order_detail/item_section.dart';
import 'package:mobile/feature/order/widgets/order_detail/payment_information_card.dart';
import 'package:mobile/feature/order/widgets/order_detail/summary_card.dart';
import 'package:mobile/feature/order/widgets/order_detail/timeline.dart';
import 'package:mobile/feature/order/widgets/video/video_upload_section.dart';
import 'package:mobile/utils/enum/enum.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  final OrderStatusEnum status;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
    required this.status,
  });

  static Route<void> route(String orderId, OrderStatusEnum status) {
    return MaterialPageRoute<void>(
        builder: (_) => OrderDetailScreen(orderId: orderId, status: status));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = getIt<OrderBloc>();
            bloc.add(GetOrderById(int.parse(orderId)));
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => getIt<VideoBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: getColorSkin().backgroundColor,
        appBar: AppBar(
          title: Text("Order #$orderId",
              style: const TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          backgroundColor: getColorSkin().primaryRed650,
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoadingState && state.isLoading) {
              return buildLoadingIndicator();
            }

            if (state is OrderLoadingState && state.error != null) {
              return CommonErrorWidget(
                error: state.error!,
                onRetry: () => context.read<OrderBloc>().add(GetOrderById(int.parse(orderId))),
              );
            }

            if (state is OrderDataState && state.order != null) {
              final order = state.order!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderSummaryCard(order: order),
                      const SizedBox(height: 24),
                      OrderTimeline(status: order.latestStatus ?? status),
                      const SizedBox(height: 24),
                      OrderItemsSection(orderDetails: order.orderDetails ?? []),
                      const SizedBox(height: 24),
                      DeliveryInformationCard(order: order),
                      const SizedBox(height: 24),
                      PaymentInformationCard(order: order),
                      const SizedBox(height: 24),
                      // Add the new video upload section
                      VideoUploadSection(
                        accountId: order.account?.accountId,
                        slotId: order.orderDetails?.first.slot?.slotId ?? 1,
                      ),
                      const SizedBox(height: 32),
                      ActionButtons(
                        status: order.latestStatus ?? status,
                        orderId: orderId,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: Text(
                'Order not found',
                style: TextStyle(
                  fontSize: 16,
                  color: getColorSkin().grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}