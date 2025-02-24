import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/blocs/set/set_bloc.dart';
import 'package:mobile/blocs/set/set_event.dart';
import 'package:mobile/blocs/set/set_state.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/new_release/widget/blindbox_item.dart';
import 'package:mobile/ui/new_release/widget/category_drawer.dart';
import '../../di/injection.dart';

class NewReleasesScreen extends StatelessWidget {
  const NewReleasesScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => NewReleasesScreen());
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SetBloc>()..add(GetSets()),
      child: Scaffold(
        drawer: const CategoryDrawer(),
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: getColorSkin().primaryRed650,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: getColorSkin().white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Text(
        "New Releases",
        style: TextStyle(
          color: getColorSkin().white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: BlocBuilder<SetBloc, SetState>(
        builder: (context, state) {
          if (state.isLoading != null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return _buildErrorWidget(context, state.error!);
          }

          final sets = state.sets?.content;
          if (sets == null || sets.isEmpty) {
            return _buildEmptyWidget();
          }

          return _buildGrid(sets);
        },
      ),
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
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Text(
        'No items available',
        style: TextStyle(
          color: getColorSkin().grey,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildGrid(List<SetModel> sets) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 8.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.75,
      ),
      itemCount: sets.length,
      itemBuilder: (context, index) => ProductItem(set: sets[index]),
    );
  }
}