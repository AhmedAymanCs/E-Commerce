import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/feature/auth/login/presentation/login_screen.dart';
import 'package:e_commerce/feature/auth/register/presentation/register_screen.dart';
import 'package:e_commerce/feature/home/presentation/home_screen.dart';
import 'package:e_commerce/feature/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
