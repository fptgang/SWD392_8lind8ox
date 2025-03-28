import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/detail/blocs/blindbox_detail_event.dart';
import 'package:mobile/feature/detail/widgets/loading.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';
import 'package:confetti/confetti.dart';

import 'blocs/blindbox_detail_bloc.dart';
import 'blocs/blindbox_detail_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final int blindBoxId;

  const ProductDetailScreen({super.key, required this.blindBoxId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<BlindBoxDetailBloc>().add(FetchBlindBoxDetail(widget.blindBoxId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartBloc = getIt<CartGlobalBloc>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BlindBoxDetailBloc>(),
        ),
        BlocProvider.value(
          value: cartBloc,
        ),
      ],
      child: const _PageControllerProvider(
        child: _ProductDetailView(),
      ),
    );
  }
}

class _PageControllerProvider extends StatefulWidget {
  final Widget child;

  const _PageControllerProvider({
    super.key,
    required this.child,
  });

  @override
  State<_PageControllerProvider> createState() =>
      _PageControllerProviderState();
}

class _PageControllerProviderState extends State<_PageControllerProvider> {
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PageControllerInherited(
      pageController: pageController,
      child: widget.child,
    );
  }
}

class _PageControllerInherited extends InheritedWidget {
  final PageController pageController;

  const _PageControllerInherited({
    super.key,
    required this.pageController,
    required super.child,
  });

  static _PageControllerInherited of(BuildContext context) {
    final _PageControllerInherited? result =
        context.dependOnInheritedWidgetOfExactType<_PageControllerInherited>();
    assert(result != null, 'No _PageControllerInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_PageControllerInherited oldWidget) =>
      pageController != oldWidget.pageController;
}

class _ProductDetailView extends StatefulWidget {
  const _ProductDetailView();

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));
  bool _isShaking = false;
  bool _hasRevealed = false;
  int _shakesCount = 0;
  final int _requiredShakes = 3;

  @override
  void initState() {
    super.initState();

    // Initialize shake animation controller
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Create a curved animation for more natural shaking
    _shakeAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticIn,
      ),
    );

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reverse();
      } else if (status == AnimationStatus.dismissed && _isShaking) {
        _shakeController.forward();
        _shakesCount++;

        if (_shakesCount >= _requiredShakes && !_hasRevealed) {
          _hasRevealed = true;
          _isShaking = false;
          _confettiController.play();
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _startShaking() {
    if (!_isShaking && !_hasRevealed) {
      setState(() {
        _isShaking = true;
        _shakesCount = 0;
      });
      _shakeController.forward();
    }
  }

  void _stopShaking() {
    if (_isShaking) {
      setState(() {
        _isShaking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageController = _PageControllerInherited.of(context).pageController;

    return BlocBuilder<BlindBoxDetailBloc, BlindBoxDetailState>(
      builder: (context, state) {
        if (state is BlindBoxLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is BlindBoxErrorState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: getColorSkin().primaryRed650,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: getColorSkin().white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: SelectableText.rich(
                TextSpan(
                  text: state.error,
                  style: const TextStyle(color: Colors.red),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is BlindBoxDataState) {
          return Stack(
            children: [
              _buildBlindBoxDetailLoadedState(context, state, pageController),

              // Confetti overlay
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  maxBlastForce: 5,
                  minBlastForce: 1,
                  emissionFrequency: 0.05,
                  numberOfParticles: 20,
                  gravity: 0.2,
                  colors: const [
                    Colors.red,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                    Colors.yellow,
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBlindBoxDetailLoadedState(BuildContext context,
      BlindBoxDataState state, PageController pageController) {
    // Get mystery toy rarity probabilities
    final Map<String, double> rarityChances = {
      'REGULAR': 0.70, // 70% chance for regular toy
      'SECRET': 0.30, // 30% chance for secret toy
    };

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Soft yellow background
      appBar: AppBar(
        backgroundColor: getColorSkin().primaryRed650,
        elevation: 0,
        title: Text(
          '${state.blindBox.name ?? 'Mystery Box'}',
          style: TextStyle(
              color: getColorSkin().white,
              fontFamily: 'Bubblegum',
              fontSize: 22),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getColorSkin().white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image with shake animation
            GestureDetector(
              onLongPress: _startShaking,
              onLongPressEnd: (_) => _stopShaking(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Box shadow
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                      // Animated image
                      AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _isShaking
                                ? _shakeAnimation.value * pi / 180
                                : 0.0,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _hasRevealed
                                ? Colors.transparent
                                : const Color(0xFFFF9800),
                            border: Border.all(
                              color: const Color(0xFFE65100),
                              width: 8,
                            ),
                            image:
                                state.images != null && state.images!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(state
                                            .images![state.selectedImageIndex]),
                                        fit: BoxFit.cover,
                                        opacity: _hasRevealed ? 1.0 : 0.3,
                                      )
                                    : null,
                          ),
                          child: _hasRevealed
                              ? null
                              : const Center(
                                  child: Text(
                                    '?',
                                    style: TextStyle(
                                      fontFamily: 'Bubblegum',
                                      fontSize: 120,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black45,
                                          offset: Offset(5.0, 5.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Instructions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFFFB74D), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _hasRevealed
                        ? "You revealed it!"
                        : "Shake to reveal your toy!",
                    style: TextStyle(
                      fontFamily: 'Bubblegum',
                      fontSize: 22,
                      color: _hasRevealed
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF57C00),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hasRevealed
                        ? "Congratulations! You've discovered what's inside!"
                        : "Long press and hold on the box to shake it! Can you guess what's inside?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  if (!_hasRevealed) ...[
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: _shakesCount / _requiredShakes,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF9800)),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Shakes: $_shakesCount/$_requiredShakes",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),

            // Product details
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          state.blindBox.name ?? 'Mystery Box',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ),
                      Text(
                        '${state.sku?.price ?? 0} đ',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Description
                  Text(
                    state.blindBox.description ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Rarity chances
                  const Text(
                    'Mystery Toy Chances:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rarity progress bars
                  ...rarityChances.entries.map((entry) {
                    Color barColor;
                    switch (entry.key) {
                      case 'SECRET':
                        barColor = const Color(0xFFAD1457); // Pink
                        break;
                      default:
                        barColor = const Color(0xFF66BB6A); // Green
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key.capitalize(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${(entry.value * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: barColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: entry.value,
                            minHeight: 15,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(barColor),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0B2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () {
                    // Add wish list functionality
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Color(0xFFE65100),
                    size: 28,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Add to cart functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().primaryRed650,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: getColorSkin().white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
