import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/core/constants/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LogoWithText extends StatelessWidget {
  final String text;
  const LogoWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(ImageManager.logo, fit: BoxFit.contain),
          SizedBox(height: 10.h),
          Text(
            text,
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
