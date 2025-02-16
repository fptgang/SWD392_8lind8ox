import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/homepage/widget/set_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../cubit/set_cubit/set_cubit.dart';
import '../../../cubit/set_cubit/set_state.dart';
import '../../../di/injection.dart';
import '../../core/theme/theme.dart';

class SetSection extends StatelessWidget {
  const SetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SetCubit>()..getSets(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.selectBySeries,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.seeAll,
                  style: TextStyle(color: getColorSkin().black),
                ),
              ),
            ],
          ),
          BlocBuilder<SetCubit, SetState>(
            builder: (context, state) {
              if (state.isLoading ?? false) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state.error != null) {
                return Center(child: Text(state.error!));
              }
              final sets = state.sets?.content;
              if (sets == null) {
                return const Center(child: Text('No data'));
              }
              return SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sets.length,
                  itemBuilder: (context, index) {
                    final set = sets[index];
                    return buildSetItem(
                      set.setId.toString(),
                      set.imageIds[0].imageUrl ?? '',
                      set.currentPrice,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 16.w),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}