import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/cubit/blindbox_list_cubit/blindbox_list_cubit.dart';
import 'package:mobile/cubit/blindbox_list_cubit/blindbox_list_state.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlindBoxesCubit, BlindBoxesState>(
      builder: (context, state) {
        if (state.recentSearches.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tìm kiếm gần đây',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<BlindBoxesCubit>().clearRecentSearches();
                    },
                    child: const Text('Xóa tất cả'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...state.recentSearches.map((search) => _buildRecentItem(context, search)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              context.read<BlindBoxesCubit>().removeRecentSearch(text);
            },
          ),
        ],
      ),
    );
  }
}
