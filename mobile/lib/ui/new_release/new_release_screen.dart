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
    return MaterialPageRoute<void>(builder: (_) => const NewReleasesScreen());
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SetBloc>()..add(GetSets(1)),
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
      elevation: 2,
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
          fontSize: 18.sp,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: getColorSkin().white),
          onPressed: () {
            // Handle search action
          },
        ),
      ],
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16.r),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        // Will be implemented to refresh content
        await Future.delayed(const Duration(seconds: 1));
        return;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: BlocBuilder<SetBloc, SetState>(
          builder: (context, state) {
            if (state is SetLoadingState && state.isLoading) {
              return _buildLoadingIndicator();
            }

            if (state is SetLoadingState && state.error != null) {
              return _buildErrorWidget(context, state.error!);
            }

            if (state is SetDataState) {
              final sets = state.sets?.content ?? [];
              if (sets.isEmpty) {
                return _buildEmptyWidget();
              }
              return _buildGrid(sets);
            }
            
            return _buildLoadingIndicator();
          }
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(getColorSkin().primaryRed650),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading new releases...',
            style: TextStyle(
              color: getColorSkin().grey,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: getColorSkin().primaryRed600,
            size: 48.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'Something went wrong',
            style: TextStyle(
              color: getColorSkin().black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: getColorSkin().grey,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => context.read<SetBloc>().add(GetSets(1)),
            icon: Icon(Icons.refresh, color: getColorSkin().white),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: getColorSkin().primaryRed600,
              foregroundColor: getColorSkin().white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            color: getColorSkin().grey,
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No new releases available',
            style: TextStyle(
              color: getColorSkin().black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new products',
            style: TextStyle(
              color: getColorSkin().grey,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<SetModel> sets) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 8.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.75,
      ),
      itemCount: sets.length,
      itemBuilder: (context, index) => ProductItem(set: sets[index]),
    );
  }
}