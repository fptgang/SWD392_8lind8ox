import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/ui/auth/widget/auth_tab.dart';
import 'package:mobile/ui/homepage/widget/homepage_screen.dart';
import 'di/injection.dart';
import 'package:hive_flutter/hive_flutter.dart';

//ui -> bloc -> repository -> data provider (openapi generated code)

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  // await configureDependencies();
  await Hive.initFlutter();
  await Hive.openBox("authentication");
  configureDependencies();
  // final authRepository = getIt<AuthRepository>();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final AuthRepository authRepository;
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: '8lind 8ox',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePageScreen(),
        );
      },
    );
  }
}
