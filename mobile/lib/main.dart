import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/splash/view/splash_sreen.dart';
import 'package:mobile/ui/account/account_screen.dart';
import 'package:mobile/ui/blind_box_detail/widget/blind_box_detail_screen.dart';
import 'package:mobile/ui/cart/widget/cart_screen.dart';
import 'package:mobile/ui/checkout/checkout_screen.dart';
import 'package:mobile/ui/homepage/homepage_screen.dart';
import 'package:mobile/ui/common/bottom_navigation_bar.dart';
import 'package:mobile/ui/information/widget/feature_test_bottom.dart';
import 'package:mobile/ui/information/widget/search_test_bottom.dart';
import 'package:mobile/ui/login/login_screen.dart';
import 'package:mobile/ui/register/register_screen.dart';
import 'package:mobile/ui/reset_password/forgot_password_screen.dart';
import 'package:mobile/ui/reset_password/new_password_screen.dart';
import 'package:provider/provider.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_state.dart';
import 'cubit/dropdown_cubit/dropdown_cubit.dart';
import 'cubit/locale_cubit/locale_cubit.dart';
import 'data/repositories/auth_repository.dart';
import 'di/injection.dart';
import 'enum/enum.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final getIt = GetIt.instance;

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

NavigatorState get navigator => navigatorKey.currentState!;

late AppLinks _appLinks;
StreamSubscription<Uri>? _linkSubscription;

// Locale locale = const Locale('en', 'US');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initDeepLinks();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await Hive.openBox("authentication");
  configureDependencies();
  runApp(const MyApp());
}

Future<void> initDeepLinks() async {
  _appLinks = AppLinks();

  _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
    debugPrint('onAppLink: $uri');
    openAppLink(uri);
  });
}

void openAppLink(Uri uri) {
  if (uri.path == "${dotenv.env['BASE_URL']}/reset-password") {
    final token = uri.queryParameters["token"] ?? "";
    navigatorKey.currentContext?.go("/reset-password", extra: {"token": token});
  }
}


final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/main',
  routes: [
    // GoRoute(path: '/homepage', builder: (context, state) => const HomePageScreen()),
    GoRoute(path: '/forgot-password',builder: (context, state) =>  ForgotPasswordScreen()),
    GoRoute(path: '/reset-password', builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        return NewPasswordScreen(token: token);
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/sign-up', builder: (context, state) =>  RegisterScreen()),
    GoRoute(path: '/account', builder: (context, state) =>  AccountScreen()),
    GoRoute(path: '/splash', builder: (context, state) =>  SplashScreen()),
    GoRoute(path: '/cart', builder: (context, state) => CartScreen()),
    GoRoute(
      path: '/blind-box-detail/:id',
      builder: (context, state) {
        final blindBoxId = int.parse(state.pathParameters['id'] ?? '0');
        return ProductDetailScreen(blindBoxId: blindBoxId);
      },
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(path: 'home', builder: (context, state) => const HomePageScreen()),
        GoRoute(path: 'search', builder: (context, state) => const SearchScreen()),
        GoRoute(path: 'cart', builder: (context, state) => const CartScreen()),
        GoRoute(path: 'new-releases', builder: (context, state) => const FeatureScreen()),
        GoRoute(path: 'account', builder: (context, state) => AccountScreen()),
      ],
    ),
    GoRoute(path: '/checkout', builder: (context, state) => CheckoutScreen()),

  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiProvider(
        providers: [
          Provider<AuthRepository>(
            create: (_) => getIt<AuthRepository>(),
          ),
          BlocProvider(
            create: (context) => getIt<AuthenticationBloc>()
              ..add(AuthenticationSubscriptionRequested()),
          ),
          BlocProvider(create: (_) =>getIt<LocaleCubit>()),
          BlocProvider(create: (_) => getIt<DropdownCubit>()),
          BlocProvider(create: (_) => CartCubit()),
        ],
        child: const AppView(),
      ),
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
          localizationsDelegates: [
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
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    context.go('/main');
                    break;
                  case AuthenticationStatus.unauthenticated:
                    context.go('/main');
                    break;
                  case AuthenticationStatus.unknown:
                    context.go('/splash');
                    break;
                }
              },
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
