import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFormField extends StatefulWidget {
  final String? title;
  final String hint;
  final IconData? preicon;
  final Function()? onPressed;
  final bool? obscure;
  const CustomFormField({
    super.key,
    this.title,
    required this.hint,
    this.preicon,
    this.onPressed,
    this.obscure,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title ?? ''),
        SizedBox(height: widget.title == null ? 0 : 5.h),
        TextFormField(
          obscureText: widget.obscure ?? false,
          cursorColor: ColorManager.primaryColor,
          decoration: InputDecoration(
            prefixIcon: widget.preicon != null
                ? Icon(widget.preicon!, color: ColorManager.gray500)
                : null,
            suffixIcon: widget.obscure != null
                ? IconButton(
                    onPressed: widget.onPressed,
                    icon: Icon(
                      widget.obscure! ? Icons.visibility : Icons.visibility_off,
                      color: ColorManager.gray500,
                    ),
                  )
                : null,
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: ColorManager.gray500,
              fontSize: FontSize.s14,
              fontWeight: FontWeightManager.regular,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.textField,
              borderSide: BorderSide(color: ColorManager.primaryColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.textField,
              borderSide: BorderSide(color: ColorManager.red),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.textField,
              borderSide: BorderSide(color: ColorManager.red),
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.textField,
              borderSide: BorderSide(color: ColorManager.gray500),
            ),
          ),
        ),
      ],
    );
  }
}
