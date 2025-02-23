import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/blocs/set/set_bloc.dart';
import 'package:mobile/blocs/set/set_event.dart';
import 'package:mobile/blocs/set/set_state.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/ui/homepage/widget/set_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../di/injection.dart';
import '../../core/theme/theme.dart';

class SetSection extends StatelessWidget {
  const SetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SetBloc>()..add(GetSets()),
      child: Column(
        children: [
          _buildHeader(context),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.selectBySeries,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          TextButton(
            onPressed: () {
              // Implement see all functionality
            },
            child: Text(
              AppLocalizations.of(context)!.seeAll,
              style: TextStyle(color: getColorSkin().black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<SetBloc, SetState>(
      builder: (context, state) {
        if (state.isLoading == true) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return _buildErrorWidget(context, state.error!);
        }

        final sets = state.sets?.content;
        if (sets == null || sets.isEmpty) {
          return _buildEmptyWidget(context);
        }

        return _buildSetList(sets);
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          ElevatedButton(
            onPressed: () => context.read<SetBloc>().add(GetSets()),
            // child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Text(
        // AppLocalizations.of(context)?.noSetsAvailable ?? 'No sets available',
        'No sets available',
        style: TextStyle(
          color: getColorSkin().grey,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildSetList(List<SetModel> sets) {
    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: sets.length,
        itemBuilder: (context, index) {
          final set = sets[index];
          return SetItem(
            set: set,
            onTap: () {
              context.read<SetBloc>().add(GetSetById(set.setId));
            },
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
      ),
    );
  }
}
