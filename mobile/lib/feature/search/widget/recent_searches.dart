import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/search/blocs/search_bloc.dart';
import 'package:mobile/feature/search/blocs/search_event.dart';
import 'package:mobile/feature/search/blocs/search_state.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        // Only show recent searches in QueryState and if there are items
        if (state is! SearchQueryState || state.recentSearches.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 8.h),
              ...state.recentSearches
                  .map((search) => _buildRecentItem(context, search)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          // AppLocalizations.of(context)?.recentSearches ?? 'Recent Searches',
          'Recent Searches',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: getColorSkin().black,
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<SearchBloc>().add(ClearRecentSearches());
          },
          child: Text(
            // AppLocalizations.of(context)?.clearAll ?? 'Clear All',
            'Clear All',
            style: TextStyle(
              color: getColorSkin().primaryRed650,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentItem(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        context.read<SearchBloc>().add(SubmitSearch(text));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(
              Icons.history,
              color: getColorSkin().grey,
              size: 20.r,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: getColorSkin().black,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: getColorSkin().grey,
                size: 20.r,
              ),
              onPressed: () {
                context.read<SearchBloc>().add(RemoveRecentSearch(text));
              },
            ),
          ],
        ),
      ),
    );
  }
}
