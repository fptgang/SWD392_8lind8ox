import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/splash/view/splash_sreen.dart';
import 'package:mobile/ui/homepage/widget/homepage_screen.dart';
import 'package:mobile/ui/login/login_screen.dart';
import 'package:mobile/ui/reset_password/new_password_screen.dart';
import 'package:provider/provider.dart';
// import 'package:uni_links/uni_links.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_state.dart';
import 'blocs/deeplink/deeplink_bloc.dart';
import 'blocs/deeplink/deeplink_event.dart';
import 'blocs/deeplink/deeplink_state.dart';
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
          // BlocProvider(
          //   create: (context) => getIt<DeeplinkBloc>()
          //     ..add(GetInitialDeepLink()),
          // ),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return MultiBlocListener(
          listeners: [
            // Listen to AuthenticationBloc
            BlocListener<AuthenticationBloc, AuthenticationState>(
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
                    navigator.pushAndRemoveUntil<void>(
                      SplashScreen.route(),
                          (route) => false,
                    );
                    break;
                }
              },
            ),

            // Listen to DeepLinkBloc
          // BlocListener<DeeplinkBloc, DeeplinkState>(
          //   listener: (context, state) {
          //     if (state is InitialDeepLinkFound) {
          //       final token = state.token;
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => NewPasswordScreen(token: token),
          //         ),
          //       );
          //     } else if (state is DeepLinkError) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text(state.error)),
          //       );
          //     }
          //   }, // Your main app widget tree
          // ),

          ],
          child: child ?? const SizedBox.shrink(),
        );
      },
      onGenerateRoute: (_) => SplashScreen.route(),
    );
  }
}

