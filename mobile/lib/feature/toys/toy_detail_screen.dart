import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/blocs/cart/cart_event.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/data/models/slot_model.dart';
import 'package:mobile/data/models/toy_model.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/data/repositories/toy_repository.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:video_player/video_player.dart';

class ToyDetailScreen extends StatefulWidget {
  final int setId;

  const ToyDetailScreen({
    Key? key,
    required this.setId,
  }) : super(key: key);

  @override
  State<ToyDetailScreen> createState() => _ToyDetailScreenState();
}

class _ToyDetailScreenState extends State<ToyDetailScreen>
    with SingleTickerProviderStateMixin {
  // Repositories
  final ToyRepository _toyRepository = getIt<ToyRepository>();
  final SetRepository _setRepository = getIt<SetRepository>();
  final CartGlobalBloc _cartBloc = getIt<CartGlobalBloc>();

  // Data models
  SetModel? _set;
  List<SlotModel> _slots = [];

  // UI state
  bool _isLoading = true;
  bool _isError = false;
  int? _selectedSlotId;
  int? _selectedToyId;
  bool _isShaking = false;

  // Video state
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;

  // Animation
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;

  final List<Color> _confettiColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    developer.log('ToyDetailScreen initialized with setId: ${widget.setId}',
        name: 'ToyDetailScreen');
    _loadSetData();

    // Setup shake animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed && _isShaking) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _loadSetData() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      final set = await _setRepository.getSetById(widget.setId);

      // Log detailed information about the set
      developer.log('First set details:', name: 'ToyScreen');
      developer.log('  - ID: ${set.setId}', name: 'ToyScreen');
      developer.log('  - BlindBox: ${set.blindBox.name}', name: 'ToyScreen');
      developer.log('  - Price: ${set.sku.price}', name: 'ToyScreen');
      developer.log(
          '  - Stock: ${set.sku.stock ?? 'N/A'} (check if stock field is mapped correctly)',
          name: 'ToyScreen');
      developer.log('  - SKU ID: ${set.sku.skuId}', name: 'ToyScreen');
      developer.log('  - Slots count: ${set.slots.length}', name: 'ToyScreen');

      // Debug slot states
      developer.log('Debugging slot states:', name: 'ToyDetailScreen');
      for (int i = 0; i < set.slots.length; i++) {
        final slot = set.slots[i];
        developer.log(
            'Slot ${i + 1} (ID: ${slot.slotId}) - Raw state: "${slot.state}" - Type: ${slot.state.runtimeType}',
            name: 'ToyDetailScreen');
      }

      // Log available enum values
      developer.log('Available enum values:', name: 'ToyDetailScreen');
      developer.log('AVAILABLE = ${SlotStateEnum.AVAILABLE}',
          name: 'ToyDetailScreen');
      developer.log('RESERVED = ${SlotStateEnum.RESERVED}',
          name: 'ToyDetailScreen');
      developer.log('OPENED = ${SlotStateEnum.OPENED}',
          name: 'ToyDetailScreen');

      // Log slot
      setState(() {
        _set = set;
        _slots = set.slots;
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Error loading set data: $e',
          name: 'ToyDetailScreen', error: e);
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  void _startShaking(int slotId) {
    if (_isShaking) return;

    setState(() {
      _isShaking = true;
      _selectedSlotId = slotId;
    });

    _animationController.forward();

    // Simulate shaking for 3 seconds
    Timer(const Duration(seconds: 3), () {
      _stopShaking();
    });
  }

  void _stopShaking() {
    setState(() {
      _isShaking = false;
    });
    _animationController.stop();
    _animationController.reset();
  }

  void _addToCart(SlotModel slot) {
    if (slot.slotId == null) return;

    developer.log(
        'Adding to cart - Slot ID: ${slot.slotId}, Position: ${slot.position}',
        name: 'ToyDetailScreen');

    // Get position and ensure it's a non-null string
    final slotPosition = slot.position != null ? slot.position.toString() : '?';

    final cartItem = CartItemModel(
      id: DateTime.now().millisecondsSinceEpoch,
      productName: '${_set?.blindBox.name ?? "Blind Box"} - Slot $slotPosition',
      price: _set?.sku.price ?? 0,
      image: _set?.sku.image?.imageUrl ?? '',
      quantity: 1,
      skuId: _set?.sku.skuId,
      slotId: slot.slotId,
    );

    _cartBloc.add(AddItemToCart(cartItem));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart: Slot $slotPosition'),
        backgroundColor: getColorSkin().deepGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _playProofVideo(ToyModel toy) async {
    // Find the slot that contains this toy
    final slot = _slots.firstWhere(
      (s) => s.toy?.toyId == toy.toyId,
      orElse: () => SlotModel(),
    );

    final videoUrl = slot.video?.url;
    if (videoUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No proof video available for this toy'),
          backgroundColor: getColorSkin().errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isVideoPlaying = true;
      _selectedToyId = toy.toyId;
    });

    // Initialize video controller
    _videoController = VideoPlayerController.network(videoUrl);

    try {
      await _videoController!.initialize();
      _videoController!.play();

      // Force a rebuild
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing video: ${e.toString()}'),
          backgroundColor: getColorSkin().errorRed,
        ),
      );
      _closeVideo();
    }
  }

  void _closeVideo() {
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;

    setState(() {
      _isVideoPlaying = false;
      _selectedToyId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorSkin().primaryRed650,
        title: Text(
          _set?.blindBox.name ?? 'Blind Box Set',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorSkin().primaryRed600,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getColorSkin().primaryRed600),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? _buildLoading()
          : _isError
              ? _buildError()
              : _isVideoPlaying
                  ? _buildVideoPlayer()
                  : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: getColorSkin().primaryRed600,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading blind box set...',
            style: TextStyle(
              fontSize: 18,
              color: getColorSkin().darkGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: getColorSkin().errorRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 20,
              color: getColorSkin().darkGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadSetData,
            style: ElevatedButton.styleFrom(
              backgroundColor: getColorSkin().primaryRed600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            getColorSkin().lightOrange100,
            getColorSkin().lightYellow,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Set info
          if (_set != null) _buildSetInfo(),

          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: getColorSkin().primaryRed600,
                    unselectedLabelColor: getColorSkin().darkGrey,
                    indicatorColor: getColorSkin().primaryRed600,
                    tabs: const [
                      Tab(
                        text: "Available",
                        icon: Icon(Icons.card_giftcard),
                      ),
                      Tab(
                        text: "Reserved",
                        icon: Icon(Icons.pending_outlined),
                      ),
                      Tab(
                        text: "Opened",
                        icon: Icon(Icons.toys),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Available boxes tab
                        _buildUnopenedBoxesTab(),

                        // Reserved boxes tab
                        _buildReservedBoxesTab(),

                        // Opened toys tab
                        _buildRevealedToysTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetInfo() {
    final imageUrl = _set?.sku.image?.imageUrl ??
        (_set?.blindBox.images?.isNotEmpty == true
            ? _set!.blindBox.images![0].imageUrl
            : null);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: getColorSkin().lightGrey,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: getColorSkin().grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            _set?.blindBox.name ?? "Unknown Set",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: getColorSkin().primaryRed600,
            ),
          ),
          if (_set?.blindBox.description != null) ...[
            const SizedBox(height: 8),
            Text(
              _set!.blindBox.description!,
              style: TextStyle(
                fontSize: 16,
                color: getColorSkin().darkGrey,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildUnopenedBoxesTab() {
    // Use exact string format from API
    final availableSlots = _slots
        .where((slot) =>
            slot.state != null && slot.state == SlotStateEnum.AVAILABLE)
        .toList();

    developer.log('Available slots count: ${availableSlots.length}',
        name: 'ToyDetailScreen');
    for (var slot in availableSlots) {
      developer.log(
          'Available Slot ID: ${slot.slotId}, Position: ${slot.position}, Raw state: "${slot.state}"',
          name: 'ToyDetailScreen');
    }

    if (availableSlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: getColorSkin().lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No available boxes',
              style: TextStyle(
                fontSize: 18,
                color: getColorSkin().darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All boxes in this set have been reserved or opened',
              style: TextStyle(
                fontSize: 14,
                color: getColorSkin().grey,
              ),
            ),
            const SizedBox(height: 24),
            // Add debug section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Info (Total slots: ${_slots.length}):',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._slots.take(5).map((slot) => Text(
                          'Slot ${slot.position}: State="${slot.state}" (${slot.slotId})',
                          style: const TextStyle(fontSize: 12),
                        )),
                    if (_slots.length > 5)
                      Text(
                        '... and ${_slots.length - 5} more slots',
                        style: const TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: availableSlots.length,
      itemBuilder: (context, index) {
        final slot = availableSlots[index];
        final isSelected = _selectedSlotId == slot.slotId;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: isSelected && _isShaking
                  ? Offset(_shakeAnimation.value, 0)
                  : Offset.zero,
              child: child,
            );
          },
          child: _buildBlindBoxCard(slot),
        );
      },
    );
  }

  Widget _buildReservedBoxesTab() {
    // Use exact string format from API
    final reservedSlots = _slots
        .where((slot) =>
            slot.state != null && slot.state == SlotStateEnum.RESERVED)
        .toList();

    developer.log('Reserved slots count: ${reservedSlots.length}',
        name: 'ToyDetailScreen');
    for (var slot in reservedSlots) {
      developer.log(
          'Reserved Slot ID: ${slot.slotId}, Position: ${slot.position}, Raw state: "${slot.state}"',
          name: 'ToyDetailScreen');
    }

    if (reservedSlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pending_outlined,
              size: 64,
              color: getColorSkin().lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No reserved boxes',
              style: TextStyle(
                fontSize: 18,
                color: getColorSkin().darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No boxes are currently being purchased',
              style: TextStyle(
                fontSize: 14,
                color: getColorSkin().grey,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: reservedSlots.length,
      itemBuilder: (context, index) {
        final slot = reservedSlots[index];
        return _buildBlindBoxCard(slot);
      },
    );
  }

  Widget _buildRevealedToysTab() {
    // First log all opened slots regardless of toy presence
    final allOpenedSlots = _slots
        .where(
            (slot) => slot.state != null && slot.state == SlotStateEnum.OPENED)
        .toList();

    developer.log('All opened slots count: ${allOpenedSlots.length}',
        name: 'ToyDetailScreen');

    // Log how many opened slots have null toys
    final openedSlotsWithNullToy =
        allOpenedSlots.where((slot) => slot.toy == null).toList();

    developer.log(
        'Opened slots with NULL toy: ${openedSlotsWithNullToy.length}',
        name: 'ToyDetailScreen');

    // The final filtered list for display
    final openedSlots = _slots
        .where((slot) =>
            slot.state != null &&
            slot.state == SlotStateEnum.OPENED &&
            slot.toy != null)
        .toList();

    developer.log('Opened slots with valid toys count: ${openedSlots.length}',
        name: 'ToyDetailScreen');
    for (var slot in openedSlots) {
      developer.log(
          'Opened Slot ID: ${slot.slotId}, Position: ${slot.position}, Toy: ${slot.toy?.name}, Raw state: "${slot.state}"',
          name: 'ToyDetailScreen');
    }

    if (openedSlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.toys_outlined,
              size: 64,
              color: getColorSkin().lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No revealed toys yet',
              style: TextStyle(
                fontSize: 18,
                color: getColorSkin().darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to open a box from this set!',
              style: TextStyle(
                fontSize: 14,
                color: getColorSkin().grey,
              ),
            ),
            // Add debug info for troubleshooting
            if (allOpenedSlots.isNotEmpty) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Debug Info:',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Found ${allOpenedSlots.length} opened slots but ${openedSlotsWithNullToy.length} have null toys',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: openedSlots.length,
      itemBuilder: (context, index) {
        final slot = openedSlots[index];
        return _buildRevealedToyCard(slot.toy!);
      },
    );
  }

  Widget _buildBlindBoxCard(SlotModel slot) {
    final isSelected = _selectedSlotId == slot.slotId;
    final slotPosition =
        slot.position != null ? slot.position.toString() : 'Unknown';

    // Use exact string format from API
    final isAvailable = slot.state == SlotStateEnum.AVAILABLE;
    final isReserved = slot.state == SlotStateEnum.RESERVED;

    // Set border color based on slot state
    Color borderColor;
    if (isSelected) {
      borderColor = getColorSkin().primaryRed600;
    } else if (isAvailable) {
      borderColor = getColorSkin().lightOrange;
    } else if (isReserved) {
      borderColor = Colors.amber;
    } else {
      borderColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: getColorSkin().white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: borderColor,
          width: isSelected ? 3 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Box Image
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    color: isAvailable
                        ? getColorSkin().lightOrange
                        : isReserved
                            ? Colors.amber.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                    child: Center(
                      child: Image.asset(
                        'assets/images/mystery_box.png',
                        fit: BoxFit.contain,
                        color: isAvailable
                            ? null
                            : isReserved
                                ? Colors.amber.withOpacity(0.9)
                                : Colors.grey.withOpacity(0.7),
                        colorBlendMode:
                            isAvailable ? BlendMode.srcIn : BlendMode.modulate,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.help_outline,
                            size: 60,
                            color: isAvailable
                                ? getColorSkin().primaryRed600
                                : isReserved
                                    ? Colors.amber
                                    : Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (isAvailable)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      onTap: () => slot.slotId != null
                          ? _startShaking(slot.slotId!)
                          : null,
                      child: Container(),
                    ),
                  ),
                if (isSelected && _isShaking)
                  ...List.generate(
                    15,
                    (index) {
                      final random = Random();
                      final color = _confettiColors[
                          random.nextInt(_confettiColors.length)];
                      final size = random.nextDouble() * 8 + 3;
                      final left = random.nextDouble() * 150;
                      final top = random.nextDouble() * 150;

                      return Positioned(
                        left: left,
                        top: top,
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                // Add status badge
                if (isReserved)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'RESERVED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Box Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Slot #$slotPosition',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${_set?.sku.price?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    color: isAvailable ? getColorSkin().deepGreen : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isAvailable ? () => _addToCart(slot) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAvailable
                          ? getColorSkin().primaryRed600
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(isAvailable
                        ? 'Add to Cart'
                        : isReserved
                            ? 'Reserved'
                            : 'Unavailable'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealedToyCard(ToyModel toy) {
    final isSecret = toy.rarity == ToyRarityEnum.SECRET;
    final imageUrl =
        toy.images?.isNotEmpty == true ? toy.images![0].imageUrl : null;

    // Find the slot that has this toy to check for a video
    final hasVideo = _slots
        .any((slot) => slot.toy?.toyId == toy.toyId && slot.video != null);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isSecret
              ? getColorSkin().primaryRed600
              : getColorSkin().deepGreen,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toy Image
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: getColorSkin().lightGrey,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: getColorSkin().grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: getColorSkin().lightGrey,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: getColorSkin().grey,
                          ),
                        ),
                ),
                if (hasVideo)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                        ),
                        onPressed: () => _playProofVideo(toy),
                      ),
                    ),
                  ),
                if (isSecret)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getColorSkin().primaryRed600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'SECRET',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Toy Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  toy.name ?? 'Unknown Toy',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                if (toy.weight != null)
                  Row(
                    children: [
                      Icon(
                        Icons.scale,
                        size: 16,
                        color: getColorSkin().grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Weight: ${toy.weight}g',
                        style: TextStyle(
                          fontSize: 14,
                          color: getColorSkin().darkGrey,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: getColorSkin().primaryRed600,
        ),
      );
    }

    // Find the toy from the selected slot
    final selectedToy = _slots
            .firstWhere((slot) => slot.toy?.toyId == _selectedToyId,
                orElse: () => SlotModel())
            .toy ??
        ToyModel(toyId: 0, name: 'Unknown');

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: _closeVideo,
            ),
            title: Text(
              'Proof Video: ${selectedToy.name}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_videoController!),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_videoController!.value.isPlaying) {
                            _videoController!.pause();
                          } else {
                            _videoController!.play();
                          }
                        });
                      },
                    ),
                    if (!_videoController!.value.isPlaying)
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          VideoProgressIndicator(
            _videoController!,
            allowScrubbing: true,
            padding: const EdgeInsets.all(16),
            colors: VideoProgressColors(
              playedColor: getColorSkin().primaryRed600,
              bufferedColor: getColorSkin().lightGrey,
              backgroundColor: Colors.grey.shade900,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_videoController!.value.isPlaying) {
                        _videoController!.pause();
                      } else {
                        _videoController!.play();
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.replay_10,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    final position = _videoController!.value.position;
                    final newPosition = position - const Duration(seconds: 10);
                    _videoController!.seekTo(newPosition);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.forward_10,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    final position = _videoController!.value.position;
                    final newPosition = position + const Duration(seconds: 10);
                    _videoController!.seekTo(newPosition);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
