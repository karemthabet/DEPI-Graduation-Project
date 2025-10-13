import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.onSaved,
    this.validator,
    this.hintText = '',
    this.textInputType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.textStyle,
    this.hintStyle,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.cursorColor,
    this.contentPadding,
    this.fillColor,
    this.filled = false,
  });

  /// Basic field behavior
  final TextEditingController? controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  /// Visual customization
  final String hintText;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final bool enabled;

  /// Style customization
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final Color? cursorColor;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLines,
      cursorColor: cursorColor ?? AppColors.primaryColor,
      style: textStyle ??
          theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
              fontSize: 14.sp,
            ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: fillColor,
        contentPadding:
            contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.grey),
            ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintText';
            }
            return null;
          },
      onSaved: onSaved,
    );
  }
}
