import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart';
import 'routes/app_router.dart';

void main() {
  // Build every dependency (Dio, repositories, use cases, providers) once,
  // in the right order, before the app starts.
  InjectionContainer.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final di = InjectionContainer.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: di.authProvider),
        ChangeNotifierProvider.value(value: di.profileProvider),
      ],
      child: ScreenUtilInit(
        // Design size the UI was built against - flutter_screenutil scales
        // every .w/.h/.sp/.r call relative to this.
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Clean Architecture Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorSchemeSeed: Colors.blueAccent,
              useMaterial3: true,
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
              ),
            ),
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
