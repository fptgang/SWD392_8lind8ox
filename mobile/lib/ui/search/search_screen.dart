import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/blocs/search/search_bloc.dart';
import 'package:mobile/data/datasources/local/search_local_datasource.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:mobile/ui/search/widget/search_result.dart';

import '../../blocs/blindbox_list/blindboxes_event.dart';
import '../../blocs/search/search_event.dart';
import '../../di/injection.dart';
import '../core/theme/theme.dart';
import 'widget/custom_search_bar.dart';
import 'widget/recent_searches.dart';
import 'widget/search_tab_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => SearchScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(
        getIt<BlindBoxRepository>(),
        getIt<SearchLocalDatasource>(),
      )..add(InitializeSearch()),
      child: Scaffold(
        backgroundColor: getColorSkin().backgroundColor,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Column(
            children: const [
              SizedBox(height: 8),
              _SearchHeader(),
              SearchTabBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RecentSearches(),
                      SearchResults(),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
        onPressed: () => context.pop(),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: CustomSearchBar(
              defaultText: "Search products...",
            ),
          ),
        ],
      ),
    );
  }
}

