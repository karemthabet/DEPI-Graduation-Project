import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';

abstract class AppTheme {
 static ThemeData get light {
   return ThemeData(
     useMaterial3: true,
     scaffoldBackgroundColor: AppColors.error
     
   );
 }
  static ThemeData get dark {
   return ThemeData(
     useMaterial3: true,
          scaffoldBackgroundColor: AppColors.primaryColor

     
   );
 }
}
