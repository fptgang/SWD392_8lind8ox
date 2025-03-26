import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_event.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/feature/home/blocs/promotion/promotion_bloc.dart';
import 'package:mobile/feature/home/blocs/promotion/promotion_event.dart';
import 'package:mobile/feature/home/blocs/promotion/promotion_state.dart';
import 'package:mobile/feature/home/blocs/set/set_bloc.dart';
import 'package:mobile/feature/home/blocs/set/set_event.dart';
import 'package:mobile/feature/home/blocs/set/set_state.dart';
import 'package:mobile/feature/home/widgets/blindbox_card.dart';
import 'package:mobile/feature/home/widgets/promotion_card.dart';
import 'package:mobile/feature/home/widgets/section_title.dart';
import 'package:mobile/feature/home/widgets/set_card.dart';
import 'package:openapi/api.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('📱 Building HomePageScreen');
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlindBoxesListBloc>(
          create: (context) {
            debugPrint('📱 Creating BlindBoxesListBloc');
            final bloc = getIt<BlindBoxesListBloc>();
            bloc.add(
              FetchBlindBoxes(
                pageable: Pageable(
                  page: 0,
                  size: 10,
                  sort: [''],
                ),
              ),
            );
            return bloc;
          },
        ),
        BlocProvider<PromotionBloc>(
          create: (context) {
            debugPrint('📱 Creating PromotionBloc');
            final bloc = getIt<PromotionBloc>();
            bloc.add(
              FetchPromotions(
                pageable: Pageable(
                  page: 0,
                  size: 5,
                  sort: [''],
                ),
              ),
            );
            return bloc;
          },
        ),
        BlocProvider<SetBloc>(
          create: (context) {
            debugPrint('📱 Creating SetBloc');
            final bloc = getIt<SetBloc>();
            bloc.add(
              FetchSets(
                pageable: Pageable(
                  page: 0,
                  size: 10,
                  sort: [''],
                ),
              ),
            );
            return bloc;
          },
        ),
      ],
      child: _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('📱 Building _HomePageContent');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blind Box'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Navigate to cart screen
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          debugPrint('📱 Refreshing all data');
          _refreshData(context);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPromotionsCarousel(context),
              const SizedBox(height: 24),
              _buildBlindBoxesSection(context),
              const SizedBox(height: 24),
              _buildSetsSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionsCarousel(BuildContext context) {
    return BlocBuilder<PromotionBloc, PromotionState>(
      buildWhen: (previous, current) {
        debugPrint(
            '📱 PromotionBloc state changed: ${previous.status} -> ${current.status}');
        return previous.status != current.status ||
            previous.promotions != current.promotions;
      },
      builder: (context, state) {
        debugPrint(
            '📱 Building PromotionsCarousel with state: ${state.status}');
        if (state.status == PromotionStatus.loading &&
            state.promotions == null) {
          return const _PromotionsLoadingWidget();
        }

        if (state.status == PromotionStatus.failure) {
          debugPrint(
              '⚠️ PromotionBloc failed with error: ${state.errorMessage}');
          return _ErrorWidget(
            message: state.errorMessage ?? 'Failed to load promotions',
            onRetry: () => _refreshPromotions(context),
          );
        }

        final promotions = state.promotions?.content ?? [];
        debugPrint('📱 Loaded ${promotions.length} promotions');
        if (promotions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Promotions'),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: promotions.length,
                itemBuilder: (context, index) {
                  return PromotionCard(
                    promotion: promotions[index],
                    onTap: () {
                      // TODO: Navigate to promotion detail
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlindBoxesSection(BuildContext context) {
    return BlocBuilder<BlindBoxesListBloc, BlindBoxesListState>(
      buildWhen: (previous, current) {
        debugPrint(
            '📱 BlindBoxesListBloc state changed: ${previous.status} -> ${current.status}');
        return previous.status != current.status ||
            previous.blindBoxes != current.blindBoxes;
      },
      builder: (context, state) {
        debugPrint('📱 Building BlindBoxesSection with state: ${state.status}');
        if (state.status == BlindBoxesListStatus.loading &&
            state.blindBoxes == null) {
          return const _BlindBoxesLoadingWidget();
        }

        if (state.status == BlindBoxesListStatus.failure) {
          debugPrint(
              '⚠️ BlindBoxesListBloc failed with error: ${state.errorMessage}');
          return _ErrorWidget(
            message: state.errorMessage ?? 'Failed to load blind boxes',
            onRetry: () => _refreshBlindBoxes(context),
          );
        }

        final blindBoxes = state.blindBoxes?.content ?? [];
        debugPrint('📱 Loaded ${blindBoxes.length} blind boxes');
        if (blindBoxes.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: 'Blind Boxes',
              onSeeAll: () {
                // TODO: Navigate to all blind boxes screen
              },
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: blindBoxes.length,
                itemBuilder: (context, index) {
                  return BlindBoxCard(
                    blindBox: blindBoxes[index],
                    onTap: () {
                      // TODO: Navigate to blind box detail
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSetsSection(BuildContext context) {
    return BlocBuilder<SetBloc, SetState>(
      buildWhen: (previous, current) {
        debugPrint(
            '📱 SetBloc state changed: ${previous.status} -> ${current.status}');
        return previous.status != current.status ||
            previous.sets != current.sets;
      },
      builder: (context, state) {
        debugPrint('📱 Building SetsSection with state: ${state.status}');
        if (state.status == SetStatus.loading && state.sets == null) {
          return const _SetsLoadingWidget();
        }

        if (state.status == SetStatus.failure) {
          debugPrint('⚠️ SetBloc failed with error: ${state.errorMessage}');
          return _ErrorWidget(
            message: state.errorMessage ?? 'Failed to load sets',
            onRetry: () => _refreshSets(context),
          );
        }

        final sets = state.sets?.content ?? [];
        debugPrint('📱 Loaded ${sets.length} sets');
        if (sets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: 'Sets',
              onSeeAll: () {
                // TODO: Navigate to all sets screen
              },
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sets.length,
                itemBuilder: (context, index) {
                  return SetCard(
                    set: sets[index],
                    onTap: () {
                      // TODO: Navigate to set detail
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _refreshData(BuildContext context) {
    debugPrint('📱 Refreshing all data from UI');
    _refreshPromotions(context);
    _refreshBlindBoxes(context);
    _refreshSets(context);
  }

  void _refreshPromotions(BuildContext context) {
    debugPrint('📱 Refreshing promotions');
    BlocProvider.of<PromotionBloc>(context).add(
      RefreshPromotions(
        pageable: Pageable(
          page: 0,
          size: 5,
          sort: [''],
        ),
      ),
    );
  }

  void _refreshBlindBoxes(BuildContext context) {
    debugPrint('📱 Refreshing blind boxes');
    BlocProvider.of<BlindBoxesListBloc>(context).add(
      RefreshBlindBoxes(
        pageable: Pageable(
          page: 0,
          size: 10,
          sort: [''],
        ),
      ),
    );
  }

  void _refreshSets(BuildContext context) {
    debugPrint('📱 Refreshing sets');
    BlocProvider.of<SetBloc>(context).add(
      RefreshSets(
        pageable: Pageable(
          page: 0,
          size: 10,
          sort: [''],
        ),
      ),
    );
  }
}

class _PromotionsLoadingWidget extends StatelessWidget {
  const _PromotionsLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Promotions'),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BlindBoxesLoadingWidget extends StatelessWidget {
  const _BlindBoxesLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Blind Boxes'),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SetsLoadingWidget extends StatelessWidget {
  const _SetsLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Sets'),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
