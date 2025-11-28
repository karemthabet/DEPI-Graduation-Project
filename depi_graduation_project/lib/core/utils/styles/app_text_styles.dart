import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🎨 AppTextStyles
///
/// - تستخدم خط Inter مع fallback للخطوط الافتراضية
/// - تدعم Light و Dark themes
/// - مرنة وسهلة التخصيص لأي مشروع
///
/// الاستخدام:
/// ```dart
/// Text(
///   'Welcome to ChatApp',
///   style: AppTextStyles.titleLarge(context).copyWith(color: Colors.green),
/// );
/// ```
class AppTextStyles {
  /// 🟢 Heading 1
  static TextStyle displayLarge(BuildContext context) =>
      _baseStyle(context, size: 32, weight: FontWeight.bold);

  /// 🟢 Heading 2
  static TextStyle displayMedium(BuildContext context) =>
      _baseStyle(context, size: 24, weight: FontWeight.w600);

  /// 🟢 Title Large
  static TextStyle titleLarge(BuildContext context) =>
      _baseStyle(context, size: 20, weight: FontWeight.w600);

  /// 🟢 Title Medium
  static TextStyle titleMedium(BuildContext context) =>
      _baseStyle(context, size: 18, weight: FontWeight.w500);

  /// 🟢 Body main text
  static TextStyle bodyLarge(BuildContext context) =>
      _baseStyle(context, size: 16, weight: FontWeight.normal);

  /// 🟢 Secondary body text
  static TextStyle bodyMedium(BuildContext context) =>
      _baseStyle(context, size: 14, weight: FontWeight.normal);

  /// 🟢 Small body text
  static TextStyle bodySmall(BuildContext context) =>
      _baseStyle(context, size: 12, weight: FontWeight.normal);

  /// 🟢 Label / Buttons
  static TextStyle labelLarge(BuildContext context) =>
      _baseStyle(context, size: 12, weight: FontWeight.w500);

  static TextStyle appBarTitle(BuildContext context) =>
      _baseStyle(context, size: 12, weight: FontWeight.w500);

  /// 🧩 Base method (auto adapts color and handles offline font loading)
  static TextStyle _baseStyle(
    BuildContext context, {
    required double size,
    required FontWeight weight,
  }) {
    final color =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;

    // Use GoogleFonts with fallback to prevent errors when offline
    return GoogleFonts.getFont(
      'Inter',
      fontSize: size.sp,
      fontWeight: weight,
      color: color,
    ).copyWith(
      // Add fallback fonts in case Inter fails to load (offline scenario)
      fontFamilyFallback: const ['Roboto', 'Arial', 'sans-serif'],
    );
  }
}
