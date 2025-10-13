import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/Cached/secure_storage.dart';
import 'package:whatsapp/core/functions/device_size.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/core/utils/styles/app_text_styles.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    super.initState();
    checkAuthAndNavigate();
  }

  Future<void> checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    // Use the storage methods
    final token = await SecureStorageService.getAccessToken();

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      if (context.mounted) {
        context.go(RoutesName.login);
      }
    } else {
      if (context.mounted) {
        context.go(RoutesName.homePage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = screenHeight(context);
    final width = screenWidth(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   AppAssets.imagesLogo,
          //   width: width * 0.4,
          //   height: height * 0.2,
          //   fit: BoxFit.contain,
          // ),
          SizedBox(height: height * 0.001),
          Text(
            'Chat App',
            style: AppTextStyles.displayLarge(
              context,
            ).copyWith(color: AppColors.success),
          ),
        ],
      ),
    );
  }
}
