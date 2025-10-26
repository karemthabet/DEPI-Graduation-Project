import 'package:flutter/material.dart';

abstract class AppColors {
  // Core
  static const Color primaryColor = Color(0xFF075E54);
  static const Color secondaryColor = Color(0xFF128C7E);

  // Neutrals
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color greyLight = Color(0xFFEEEEEE);
  static const Color greyDark = Color(0xFF6E6D6D);
  static const Color darkBlue = Color(0xFF243E4B);
  static const Color orange = Color(0xFFFFC107);

  // Status
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;

  // Components
  static const Color outlineInputBorder = Color(0xff6E6D6D);
  static const Color profileIcon = Color(0xffB3B3B3);
  static const Color cardBackground = Colors.white;
}
