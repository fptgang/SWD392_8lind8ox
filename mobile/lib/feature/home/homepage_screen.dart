import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                getColorSkin().primaryRed650,
                getColorSkin().primaryRed600.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) => const Text(
                '8lind 8ox',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              context.push('/main/search');
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.push('/cart');
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: getColorSkin().lightOrange,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              getColorSkin().lightOrange100.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: RefreshIndicator(
          color: getColorSkin().primaryRed600,
          onRefresh: () async {
            debugPrint('📱 Refreshing all data');
            _refreshData(context);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kToolbarHeight + 16), // Space for AppBar
                _buildWelcomeHeader(context),
                _buildPromotionsCarousel(context),
                const SizedBox(height: 24),
                _buildBlindBoxesSection(context),
                const SizedBox(height: 24),
                _buildSetsSection(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to 8lind 8ox',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: getColorSkin().primaryRed600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover unique blind box collectibles',
            style: TextStyle(
              fontSize: 16,
              color: getColorSkin().darkGrey,
            ),
          ),
        ],
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
          return _buildPromotionsLoadingWidget(context);
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
            SectionTitle(
              title: 'Hot Promotions',
              onSeeAll: () {
                // TODO: Navigate to all promotions screen
              },
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: promotions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: PromotionCard(
                      promotion: promotions[index],
                      onTap: () {
                        // context.push('/blind-box-detail/${blindBox.blindBoxId}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPromotionsLoadingWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Hot Promotions'),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ShimmerLoading(),
              );
            },
          ),
        ),
      ],
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
          return _buildBlindBoxesLoadingWidget(context);
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
              title: 'Trending Blind Boxes',
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
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: BlindBoxCard(
                      blindBox: blindBoxes[index],
                      onTap: () {
                        context.push(
                            '/blind-box-detail/${blindBoxes[index].blindBoxId}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlindBoxesLoadingWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Trending Blind Boxes'),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ShimmerLoading(),
              );
            },
          ),
        ),
      ],
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
          return _buildSetsLoadingWidget(context);
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
              title: 'Popular Sets',
              onSeeAll: () {
                context.push('/main/new-releases');
              },
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: sets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SetCard(
                      set: sets[index],
                      onTap: () {
                        debugPrint(
                            '📱 Navigating to ToyDetailScreen with setId: ${sets[index].setId}');
                        context.push('/toy/${sets[index].setId}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSetsLoadingWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Popular Sets'),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ShimmerLoading(),
              );
            },
          ),
        ),
      ],
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

// Shimmer loading effect for loading states
class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            color: Colors.grey[300],
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: AnimationController(
                vsync: Navigator.of(context),
                duration: const Duration(milliseconds: 1500),
              )..repeat(),
              builder: (context, child) {
                return FractionallySizedBox(
                  widthFactor: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[100]!,
                          Colors.grey[300]!,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: getColorSkin().errorRed,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: getColorSkin().darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: getColorSkin().primaryRed600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
