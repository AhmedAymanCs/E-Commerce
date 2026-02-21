import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: ColorManager.primaryColor,
    scaffoldBackgroundColor: ColorManager.scafoldBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorManager.scafoldBackgroundColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontWeight: FontWeightManager.semiBold,
        fontSize: 25,
        color: ColorManager.primaryColor,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: ColorManager.primaryColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorManager.primaryColor,
        textStyle: TextStyle(fontWeight: FontWeightManager.medium),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ColorManager.primaryColor,
    ),
  );
}
