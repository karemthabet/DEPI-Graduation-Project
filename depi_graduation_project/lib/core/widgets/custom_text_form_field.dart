import 'package:flutter/material.dart';

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
    this.focusNode,
    this.readOnly = false,
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
  final FocusNode? focusNode;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      focusNode: focusNode,
      enabled: enabled,
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLines,
      cursorColor: cursorColor ?? AppColors.darkBlue,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      readOnly: readOnly,
      style:
          textStyle ??
          theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            hintStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
              fontSize: 14,
            ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: filled,
        fillColor: fillColor,

        border:
            border ??
            OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: AppColors.darkBlue,
                width: 1.5,
              ),
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey),
            ),
      ),
      validator:
          validator ??
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
