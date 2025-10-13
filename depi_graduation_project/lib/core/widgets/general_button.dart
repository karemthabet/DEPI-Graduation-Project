import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/utils/styles/app_text_styles.dart';

/// 🔘 GeneralButton — زر عام مرن وقابل لإعادة الاستخدام
class GeneralButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;
  final bool isFullWidth;
  final Widget? icon; // لعرض أيقونة بجانب النص

  const GeneralButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
    this.borderColor,
    this.height = 50,
    this.borderRadius = 10,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.padding,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height.h,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              onPressed == null
                  ? backgroundColor.withOpacity(0.4)
                  : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            side:
                borderColor != null
                    ? BorderSide(color: borderColor!, width: 1.2)
                    : BorderSide.none,
          ),
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: 8.w)],
            Text(
              text,
              style: AppTextStyles.bodyMedium(context).copyWith(
                fontSize: fontSize.sp,
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppButtons {
  /// 🔵 Primary Button
  static GeneralButton primary({
    required String text,
    VoidCallback? onPressed,
    Color backgroundColor = Colors.blue,
    Color textColor = Colors.white,
    double borderRadius = 12,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    double height = 50,
    bool isFullWidth = true,
  }) {
    return GeneralButton(
      text: text,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onPressed: onPressed,
      borderRadius: borderRadius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      isFullWidth: isFullWidth,
    );
  }

  /// 🟢 With Icon Button
  static GeneralButton withIcon({
    required String text,
    required IconData icon,
    VoidCallback? onPressed,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
    double borderRadius = 12,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    double height = 50,
    bool isFullWidth = true,
    Color? borderColor,
  }) {
    return GeneralButton(
      text: text,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: Icon(icon, color: textColor, size: fontSize.sp + 2),
      onPressed: onPressed,
      borderRadius: borderRadius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      borderColor: borderColor,
      isFullWidth: isFullWidth,
    );
  }

  /// ⚫ Disabled Button
  static GeneralButton disabled({
    required String text,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    double borderRadius = 12,
    double fontSize = 16,
    double height = 50,
    bool isFullWidth = true,
  }) {
    return GeneralButton(
      text: text,
      backgroundColor: backgroundColor,
      textColor: textColor,
      onPressed: null,
      borderRadius: borderRadius,
      fontSize: fontSize,
      height: height,
      isFullWidth: isFullWidth,
    );
  }
}
