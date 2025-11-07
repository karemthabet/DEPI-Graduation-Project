import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/features/splash/presentation/views/widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SplashViewBody(),
    );
  }
}
