import 'package:e_commerce/core/config/firebase_options.dart';
import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/routing/app_router.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/core/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDioLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringManager.appName,
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: Center(child: Text('Firebase Connected!'))),
        // initialRoute: Routes.homeRoute,
        // onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
