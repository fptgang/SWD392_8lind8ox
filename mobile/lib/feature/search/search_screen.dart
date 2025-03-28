import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/datasources/local/search_local_datasource.dart';
import 'package:mobile/data/repositories/blindbox_repository.dart';
import 'package:mobile/feature/search/blocs/search_bloc.dart';
import 'package:mobile/feature/search/blocs/search_event.dart';
import 'package:mobile/feature/search/blocs/search_state.dart';
import 'package:mobile/feature/search/widget/custom_search_bar.dart';
import 'package:mobile/feature/search/widget/recent_searches.dart';
import 'package:mobile/feature/search/widget/search_result.dart';
import 'package:mobile/feature/search/widget/search_tab_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SearchScreen());
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
        body: SafeArea(
          child: Column(
            children: const [
              SizedBox(height: 8),
              _SearchHeader(),
              SearchTabBar(),
              Expanded(
                child: _SearchBody(),
              ),
            ],
          ),
        ),
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
      child: CustomSearchBar(
        defaultText:
            AppLocalizations.of(context)?.search ?? "Search products...",
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          RecentSearches(),
          SearchResults(),
        ],
      ),
    );
  }
}
