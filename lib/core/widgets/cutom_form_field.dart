import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFormField extends StatelessWidget {
  final String? title;
  final String hint;
  final IconData? preicon;
  final VoidCallback? onPressed;
  final TextInputType? keyboardType;
  final bool obscure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    this.title,
    required this.hint,
    this.preicon,
    this.onPressed,
    this.keyboardType,
    this.obscure = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeightManager.medium,
            ),
          ),
          SizedBox(height: 5.h),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscure,
          cursorColor: ColorManager.primaryColor,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: preicon != null
                ? Icon(preicon, color: ColorManager.gray500)
                : null,
            suffixIcon: onPressed != null
                ? IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                      color: ColorManager.gray500,
                    ),
                  )
                : null,
            hintText: hint,
            hintStyle: TextStyle(
              color: ColorManager.gray500,
              fontSize: FontSize.s14,
              fontWeight: FontWeightManager.regular,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.textField,
              borderSide: BorderSide(color: ColorManager.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.textField,
              borderSide: BorderSide(color: ColorManager.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.textField,
              borderSide: BorderSide(color: ColorManager.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.textField,
              borderSide: BorderSide(color: ColorManager.gray500),
            ),
          ),
        ),
      ],
    );
  }
}
