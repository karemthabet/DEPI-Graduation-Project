import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.controller,
    this.onSaved,
    this.validator,
    this.hintText = 'Password',
    this.textInputType = TextInputType.text,
    this.focusNode,
    this.obscureColor = Colors.grey,
    this.textStyle,
    this.hintStyle,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
  });

  final TextEditingController? controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String hintText;
  final TextInputType textInputType;
  final FocusNode? focusNode;
  final Color obscureColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.textInputType,
      obscureText: !isPasswordVisible,
      cursorColor: widget.obscureColor,
      style: widget.textStyle ??
          theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
              fontSize: 14,
            ),
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
        focusedBorder: widget.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.obscureColor, width: 1.5),
            ),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
        // 👇 الأيقونة بتفضل ظاهرة دايمًا
        suffixIcon: IconButton(
          splashRadius: 20,
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: widget.obscureColor,
          ),
        ),
      ),
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter ${widget.hintText}';
            }
            return null;
          },
      onSaved: widget.onSaved,
    );
  }
}
