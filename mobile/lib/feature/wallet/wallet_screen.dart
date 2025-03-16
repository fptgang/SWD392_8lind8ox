// lib/feature/wallet/screens/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/common/widgets/common_loading.dart';
import 'package:mobile/base/common/widgets/error.dart';
import 'package:mobile/base/common/widgets/no_data.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/wallet/bloc/wallet_bloc.dart';
import 'package:mobile/feature/wallet/bloc/wallet_event.dart';
import 'package:mobile/feature/wallet/bloc/wallet_state.dart';
import 'package:mobile/feature/wallet/widgets/deposit_dialog.dart';
import 'package:mobile/feature/wallet/widgets/transaction_item.dart';
import 'package:mobile/feature/wallet/widgets/wallet_balance_card.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<WalletBloc>();
        bloc.add(LoadWallet());
        bloc.add(LoadTransactions(0));
        return bloc;
      },
      child: Scaffold(
        backgroundColor: getColorSkin().lightGrey100,
        appBar: AppBar(
          title: const Text('My Wallet'),
          backgroundColor: getColorSkin().primaryRed650,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            // Loading state
            if (state is WalletLoadingState && state.isLoading && state is! WalletDataState) {
              return buildLoadingIndicator();
            }

            // Error state
            if (state is WalletLoadingState && state.error != null && state is! WalletDataState) {
              return CommonErrorWidget(
                error: state.error!,
                onRetry: () {
                  context.read<WalletBloc>().add(RefreshWallet());
                },
              );
            }

            // Data state
            if (state is WalletDataState) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WalletBloc>().add(RefreshWallet());
                },
                child: _buildContent(context, state),
              );
            }

            // Default state
            return buildLoadingIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WalletDataState state) {
    final hasTransactions = state.transactions != null &&
        state.transactions!.content.isNotEmpty;

    return CustomScrollView(
      slivers: [
        // Wallet balance card
        SliverToBoxAdapter(
          child: WalletBalanceCard(
            balance: state.account?.balance ?? 0.0,
            onAddMoney: () => _showDepositDialog(context),
          ),
        ),

        // Transaction filter section
        SliverToBoxAdapter(
          child: _buildFilterSection(context),
        ),

        // Transaction history title
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
            child: Text(
              'Transaction History',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: getColorSkin().primaryRed950,
              ),
            ),
          ),
        ),

        // Empty state
        if (!hasTransactions)
          SliverFillRemaining(
            child: buildEmptyIndicator(context),
          ),

        // Transaction list
        if (hasTransactions)
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index >= state.transactions!.content.length) {
                  if (state is WalletPaginationState) {
                    context.read<WalletBloc>().add(LoadMoreTransactions());
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.h),
                        child: CircularProgressIndicator(
                          color: getColorSkin().primaryRed650,
                        ),
                      ),
                    );
                  }
                  return null;
                }

                final transaction = state.transactions!.content[index];
                return TransactionItem(transaction: transaction);
              },
              childCount: state.transactions!.content.length + 1,
            ),
          ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          _buildFilterChip(context, 'All', ''),
          SizedBox(width: 8.w),
          _buildFilterChip(context, 'Deposits', 'type,eq,DEPOSIT'),
          SizedBox(width: 8.w),
          _buildFilterChip(context, 'Purchases', 'type,eq,ORDER'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String filter) {
    final state = context.watch<WalletBloc>().state;
    final isSelected = state is WalletDataState && state.filter == filter;

    return GestureDetector(
      onTap: () {
        context.read<WalletBloc>().add(FilterTransactions(filter));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? getColorSkin().primaryRed600 : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? getColorSkin().primaryRed600
                : getColorSkin().lightGrey500,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : getColorSkin().darkGrey,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showDepositDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DepositDialog(
          onDeposit: (amount) {
            context.read<WalletBloc>().add(InitiateDeposit(amount));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Processing deposit of \$${amount.toStringAsFixed(2)}'),
                backgroundColor: getColorSkin().tertiaryGreen500,
              ),
            );
          },
        );
      },
    );
  }
}