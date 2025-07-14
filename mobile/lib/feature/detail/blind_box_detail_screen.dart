import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/detail/blocs/blindbox_detail_event.dart';
import 'package:mobile/feature/detail/widgets/loading.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';

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
      if (context.mounted) {
        context
            .read<BlindBoxDetailBloc>()
            .add(FetchBlindBoxDetail(widget.blindBoxId));
      }
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

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

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
          return buildBlindBoxDetailLoadedState(context, state, pageController);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
