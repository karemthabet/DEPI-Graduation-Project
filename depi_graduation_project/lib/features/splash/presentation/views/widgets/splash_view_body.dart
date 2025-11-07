import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/Cached/secure_storage.dart';
import 'package:whatsapp/core/utils/assets/app_assets.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation; // Image 1 (slides down)
  late Animation<Offset> _slideAnimation2; // Image 2 (slides up)
  late Animation<double> _fadeAnimation2; // Fade for Image 2

  @override
  void initState() {
    super.initState();

    // Total duration for both animations to complete: 5000ms (5 seconds)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // 1. Image 1 slides down (0.0 → 0.5)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -3.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    
    // 2. Image 2 slides up (0.5 → 1.0)
    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(0, 3.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // 3. Fade-in animation for Image 2 (0.5 → 1.0)
    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.linear),
      ),
    );

    // Start animation
    _animationController.forward();

    // Start navigation after delay
    _checkAuthAndNavigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait only 5 seconds before navigation
    await Future.delayed(const Duration(seconds: 5));

    final token = await SecureStorageService.getAccessToken();

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      context.go(RoutesName.onboarding);
    } else {
      context.go(RoutesName.mainView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Image 1: slides from top
          SlideTransition(
            position: _slideAnimation,
            child: Image.asset(
              AppAssets.imagesImage,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),

          /// Image 2: slides from bottom + fades in
          FadeTransition(
            opacity: _fadeAnimation2,
            child: SlideTransition(
              position: _slideAnimation2,
              child: Image.asset(
                AppAssets.imagesGuide,
                width: 80,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
