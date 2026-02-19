import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/core/constants/image_manager.dart';
import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LogoWithText extends StatelessWidget {
  const LogoWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(ImageManager.logo, fit: BoxFit.contain),
          SizedBox(height: 10.h),
          Text(
            StringManager.subTitleLoginPage,
            style: TextStyle(
              fontSize: FontSize.s14,
              color: ColorManager.slate700,
              fontWeight: FontWeightManager.light,
            ),
          ),
        ],
      ),
    );
  }
}

class RememberMeAndForgotPassRow extends StatelessWidget {
  final bool rememberMeValue;
  final Function(bool?) checkBoxOnPressed;
  final Function() forgotPassOnPressed;
  const RememberMeAndForgotPassRow({
    super.key,
    required this.rememberMeValue,
    required this.checkBoxOnPressed,
    required this.forgotPassOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          value: rememberMeValue,
          onChanged: (value) => checkBoxOnPressed(value),
          activeColor: ColorManager.primaryColor,
        ),
        Text(StringManager.rememberMe),
        Spacer(),
        TextButton(
          onPressed: forgotPassOnPressed,
          child: Text(StringManager.forgotPassword),
        ),
      ],
    );
  }
}

class RegisterRow extends StatelessWidget {
  const RegisterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(StringManager.dontHaveAccount),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () {},
          child: Text(StringManager.signUp),
        ),
      ],
    );
  }
}
