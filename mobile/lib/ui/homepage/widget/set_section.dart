import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/blocs/set/set_bloc.dart';
import 'package:mobile/blocs/set/set_event.dart';
import 'package:mobile/blocs/set/set_state.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/ui/common/error.dart';
import 'package:mobile/ui/common/header.dart';
import 'package:mobile/ui/common/no_data.dart';
import 'package:mobile/ui/homepage/widget/set_item.dart';

class SetSection extends StatelessWidget {
  const SetSection({super.key});

  @override
  Widget build(BuildContext context) {
    final setBloc = context.read<SetBloc>();
    return BlocBuilder<SetBloc, SetState>(
      bloc: setBloc,
      builder: (context, state) {
        if (state.isLoading == true) {
          setBloc.add(GetSets());
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return CommonErrorWidget(
            error: state.error!,
            onRetry: () => context.read<SetBloc>().add(GetSets()),
          );
        }
        return Column(
          children: [
            SectionHeader(
                title: AppLocalizations.of(context)?.selectBySeries ?? "Recommended",
                onSeeAllPressed: () {
                  context.push('/blind-boxes');
                }),
            _buildContent(),
          ],
        );
      },
    );
  }

  Widget _buildContent() {
    return BlocBuilder<SetBloc, SetState>(
      builder: (context, state) {
        if (state.isLoading == true) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return CommonErrorWidget(
            error: state.error!,
            onRetry: () => context.read<SetBloc>().add(GetSets()),
          );
        }

        final sets = state.sets?.content;
        if (sets == null || sets.isEmpty) {
          return buildEmptyIndicator(context);
        }
        return _buildSetList(sets);
      },
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
