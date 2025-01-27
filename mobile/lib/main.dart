import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/splash/view/splash_sreen.dart';
import 'package:mobile/ui/homepage/widget/homepage_screen.dart';
import 'package:mobile/ui/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_state.dart';
import 'data/repositories/auth_repository.dart';
import 'di/injection.dart';
import 'enum/enum.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

NavigatorState get navigator => navigatorKey.currentState!;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("authentication");
  configureDependencies();

  runApp(const MyApp());
}

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
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                navigator.pushAndRemoveUntil<void>(
                  HomePageScreen.route(),
                      (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                navigator.pushAndRemoveUntil<void>(
                  LoginScreen.route(),
                      (route) => false,
                );
                break;
              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashScreen.route(),
    );
  }
}