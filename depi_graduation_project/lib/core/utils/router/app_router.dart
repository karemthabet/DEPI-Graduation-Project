import 'package:go_router/go_router.dart';
import 'package:whatsapp/features/onboarding1/onboarding_view.dart';
import '../../general_404_page/general_404_page.dart';
import 'routes_name.dart';
import '../../../features/splash/presentation/views/splash_view.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutesName.splash,
    errorBuilder: (context, state) => const General404Page(),
    routes: [
      GoRoute(
        name: RoutesName.splash,
        path: RoutesName.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        name: RoutesName.onboarding,
        path: RoutesName.onboarding, // Define a distinct path for this route
        builder: (context, state) => const OnboardingView(),
      ),
    ],
  );
}
