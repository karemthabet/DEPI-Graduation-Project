import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/general_404_page/general_404_page.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/login/presentation/views/sign_in_view.dart';
import 'package:whatsapp/features/login/presentation/views/welcome_view.dart';
import 'package:whatsapp/features/login/presentation/views/signup_view.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutesName.welcome,
    errorBuilder: (context, state) => const General404Page(),
    routes: [
      GoRoute(
        name: RoutesName.welcome,
        path: RoutesName.welcome,
        builder: (context, state) => const WelcomeView(),
      ),
       GoRoute(
        name: RoutesName.login,
        path: RoutesName.login,
        builder: (context, state) => const SignInView(),
      ),
       GoRoute(
        name: RoutesName.signUp,
        path: RoutesName.signUp,
        builder: (context, state) => const SignUpView(),
      ),
     
    ],
  );
}
