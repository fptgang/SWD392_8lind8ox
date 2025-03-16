import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/common/widgets/common_loading.dart';
import 'package:mobile/base/common/widgets/error.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/order/blocs/order/order_bloc.dart';
import 'package:mobile/feature/order/blocs/order/order_event.dart';
import 'package:mobile/feature/order/blocs/order/order_state.dart';
import 'package:mobile/feature/order/widgets/order_history/order_list_item.dart';


class MyOrdersScreen extends StatefulWidget {
  final String? highlightOrderId;
  
  const MyOrdersScreen({
    super.key,
    this.highlightOrderId,
  });

  static Route<void> route({String? highlightOrderId}) {
    return MaterialPageRoute<void>(
      builder: (_) => MyOrdersScreen(
        highlightOrderId: highlightOrderId,
      ),
    );
  }

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String? _highlightedOrderId;
  
  @override
  void initState() {
    super.initState();
    _highlightedOrderId = widget.highlightOrderId;
    
    // Clear the highlight after 3 seconds
    if (_highlightedOrderId != null) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _highlightedOrderId = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<OrderBloc>();
        bloc.add(GetOrders());
        return bloc;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: getColorSkin().primaryRed650,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'My Orders',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => context.read<OrderBloc>().add(RefreshOrders()),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoadingState && state.isLoading) {
          return buildLoadingIndicator();
        }

        if (state is OrderLoadingState && state.error != null) {
          return CommonErrorWidget(
            error: state.error!,
            onRetry: () => context.read<OrderBloc>().add(RefreshOrders()),
          );
        }

        if (state is OrderDataState && state.orders != null) {
          final orders = state.orders!.content;

          if (orders.isEmpty) {
            return Center(
              child: Text(
                'No orders found',
                style: TextStyle(
                  fontSize: 16,
                  color: getColorSkin().grey,
                ),
              ),
            );
          }

          return Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(0),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = orders[index];
                final bool isHighlighted = order.orderId == _highlightedOrderId;
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  color: isHighlighted 
                    ? getColorSkin().primaryRed100.withOpacity(0.3)
                    : Colors.transparent,
                  child: OrderListItem(order: order),
                );
              },
            ),
          );
        }

        return Center(
          child: Text(
            'No orders available',
            style: TextStyle(
              fontSize: 16,
              color: getColorSkin().grey,
            ),
          ),
        );
      },
    );
  }
}