import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/general_404_page/general_404_page.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/splash/presentation/views/splash_view.dart';

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
    ],
  );
}
