import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/data/datasources/local/search_local_datasource.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import '../../cubit/blindbox_list_cubit/blindbox_list_cubit.dart';
import '../../di/injection.dart';
import '../core/theme/theme.dart';
import 'widget/search_tab_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const SearchScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlindBoxesCubit(getIt<BlindBoxRepository>(), getIt<SearchLocalDatasource>()),
      child: Scaffold(
        backgroundColor: getColorSkin().backgroundColor,
        appBar: AppBar(
          backgroundColor: getColorSkin().primaryRed650,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.search,
            style: TextStyle(
              color: getColorSkin().white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: getColorSkin().backgroundColor),
            onPressed: () => context.push('/main/home'),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // const Expanded(
                    //   child: CustomSearchBar(
                    //     defaultText: "Labubu",
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SearchTabBar(),
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // RecentSearches(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
