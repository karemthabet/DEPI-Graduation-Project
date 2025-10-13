import 'package:flutter/material.dart';
import '../utils/themes/app_theme.dart';

abstract class ThemeCubitState {
  ThemeData get themeData;
}

class ThemeCubitInitial extends ThemeCubitState {
  @override
  ThemeData get themeData => AppTheme.light;
}

class DarkThemeState extends ThemeCubitState {
  @override
  ThemeData get themeData => AppTheme.dark;
}

class LightThemeState extends ThemeCubitState {
  @override
  ThemeData get themeData => AppTheme.light;
}
