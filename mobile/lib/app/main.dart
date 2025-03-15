import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/app/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';
import 'package:mobile/app/main_screen.dart';
import 'package:mobile/feature/auth/login/login_screen.dart';
import 'package:mobile/feature/auth/register/register_screen.dart';
import 'package:mobile/feature/auth/reset_password/forgot_password_screen.dart';
import 'package:mobile/feature/auth/reset_password/new_password_screen.dart';
import 'package:mobile/feature/cart/cart_screen.dart';
import 'package:mobile/feature/cart/cubits/cart_cubit.dart';
import 'package:mobile/feature/checkout/checkout_screen.dart';
import 'package:mobile/feature/detail/blind_box_detail_screen.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/feature/home/blocs/set/set_bloc.dart';
import 'package:mobile/feature/home/homepage_screen.dart';
import 'package:mobile/feature/order/screens/order_history_screen.dart';
import 'package:mobile/feature/order/screens/order_tracking_screen.dart';
import 'package:mobile/feature/profile/profile_screen.dart';
import 'package:mobile/feature/search/search_screen.dart';
import 'package:mobile/feature/sets/set_screen.dart';
import 'package:mobile/feature/splash/view/splash_sreen.dart';

import '../feature/profile/cubits/dropdown_cubit.dart';
import '../utils/enum/enum.dart';
import 'blocs/authentication/authentication_state.dart';
import 'cubits/locale_cubit.dart';
import 'di/injection.dart';

// Global instances
final GetIt getIt = GetIt.instance;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late AppLinks _appLinks;
StreamSubscription<Uri>? _linkSubscription;

void main() async {
  await _initializeApp();
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize environment variables
  await dotenv.load(fileName: ".env");

  // Initialize local storage
  await Hive.initFlutter();
  await Hive.openBox("authentication");

  // Initialize deep linking
  await _initDeepLinks();

  // Initialize dependency injection
  await _initDependencyInjection();
}

Future<void> _initDeepLinks() async {
  _appLinks = AppLinks();
  _linkSubscription = _appLinks.uriLinkStream.listen(_handleDeepLink);
}

void _handleDeepLink(Uri uri) {
  debugPrint('Received deep link: $uri');
  if (uri.path == "${dotenv.env['BASE_URL']}/reset-password") {
    final token = uri.queryParameters["token"] ?? "";
    navigatorKey.currentContext?.go("/reset-password", extra: {"token": token});
  }
}

Future<void> _initDependencyInjection() async {
  // Register LocaleCubit if not already registered
  if (!getIt.isRegistered<LocaleCubit>()) {
    getIt.registerSingleton<LocaleCubit>(LocaleCubit());
  }

  // Configure other dependencies
  await configureDependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) => _buildProviders(),
    );
  }

  Widget _buildProviders() {
    final localeCubit = getIt<LocaleCubit>();
    final dropdownCubit = DropdownCubit(localeCubit);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: localeCubit),
        BlocProvider(
          create: (context) => getIt<AuthenticationBloc>()
            ..add(AuthenticationSubscriptionRequested()),
        ),
        BlocProvider.value(value: dropdownCubit),
        BlocProvider(create: (_) => getIt<CartCubit>()),
        BlocProvider(create: (_) => getIt<BlindBoxesListBloc>()),
        BlocProvider(create: (_) => getIt<SetBloc>()),
        BlocProvider(create: (_) => getIt<CartGlobalBloc>()),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('vi', 'VN'),
          ],
          locale: locale,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: _handleAuthStateChanges,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }

  void _handleAuthStateChanges(
      BuildContext context, AuthenticationState state) {
    debugPrint('Auth state changed: ${state.status}');

    Future.microtask(() {
      try {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            AppRouter.router.replace('/main', extra: {'index': 0});
            break;
          case AuthenticationStatus.unauthenticated:
            AppRouter.router.replace('/main');
          case AuthenticationStatus.unknown:
            AppRouter.router.go('/splash');
            break;
        }
      } catch (e) {
        debugPrint('Error during navigation: $e');
      }
    });
  }
}

// Extracted router configuration to a separate class
class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/main',
    routes: [
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return NewPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => ProfileScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => CartScreen(),
      ),
      GoRoute(
        path: '/blind-box-detail/:id',
        builder: (context, state) {
          final blindBoxId = int.parse(state.pathParameters['id'] ?? '0');
          return ProductDetailScreen(blindBoxId: blindBoxId);
        },
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) {
          final int initialIndex = state.extra != null && state.extra is Map
              ? (state.extra as Map)['index'] ?? 0
              : 0;
          return MainScreen(initialIndex: initialIndex);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePageScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/new-releases',
            builder: (context, state) => const SetScreen(),
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) => ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => CheckoutScreen(),
      ),
      GoRoute(
        path: '/orders-history',
        builder: (context, state) => MyOrdersScreen(),
      ),
      GoRoute(
        path: '/order-history-detail/:id',
        builder: (context, state) => OrderDetailScreen(
          orderId: state.pathParameters['id'] ?? '',
          status: OrderStatusEnum.DELIVERED,
        ),
      ),
    ],
  );
}
