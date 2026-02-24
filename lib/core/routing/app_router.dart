import 'package:e_commerce/core/models/user_model.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/feature/auth/forget_passoword/presentation/forget_password_screen.dart';
import 'package:e_commerce/feature/auth/login/presentation/login_screen.dart';
import 'package:e_commerce/feature/auth/register/presentation/register_screen.dart';
import 'package:e_commerce/feature/checkout/presentation/checkout_screen.dart';
import 'package:e_commerce/feature/home/presentation/layout.dart';
import 'package:e_commerce/feature/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeRoute:
        final arg = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => Layout(userModel: arg as UserModel),
        );
      case Routes.checkoutRoute:
        final arg = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            totalPrice: arg['totalPrice'],
            cartList: arg['cartList'],
          ),
        );
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.forgetPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordPage());
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
