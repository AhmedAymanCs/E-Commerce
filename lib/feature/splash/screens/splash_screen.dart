import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/core/constants/image_manager.dart';
import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/feature/splash/logic/cubit.dart';
import 'package:e_commerce/feature/splash/logic/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SplashCubit(getIt<SecureStorageHelper>())..startSplash(),
      child: BlocListener<SplashCubit, SplashStates>(
        listener: (context, state) {
          if (state is SplashAuthenticatedState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homeRoute,
              (_) => false,
              arguments: state.userModel,
            );
          } else if (state is SplashLoginState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginRoute,
              (_) => false,
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                SvgPicture.asset(
                  ImageManager.logo,
                  height: 150.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.h),
                Text(
                  StringManager.appName,
                  style: TextStyle(
                    fontWeight: FontWeightManager.bold,
                    fontSize: FontSize.s35,
                  ),
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
