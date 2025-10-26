import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/general_404_page/general_404_page.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/calender_view.dart';
import 'package:whatsapp/features/chat_view.dart';
import 'package:whatsapp/features/home_view.dart';
import 'package:whatsapp/features/profile_view.dart';
import 'package:whatsapp/features/root_navigation_glass/presentation/views/main_view.dart';
import 'package:whatsapp/features/splash/presentation/views/splash_view.dart';
import 'package:whatsapp/features/login/presentation/views/widgets/login_view.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutesName.login,
    errorBuilder: (context, state) => const General404Page(),
    routes: [
      GoRoute(
        name: RoutesName.login,
        path: RoutesName.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: RoutesName.mainView,
        path: RoutesName.mainView,
        builder: (context, state) => const MainView(),
      ),
      GoRoute(
        name: RoutesName.calenderView,
        path: RoutesName.calenderView,
        builder: (context, state) => const CalenderView(),
      ),
      GoRoute(
        name: RoutesName.homePage,
        path: RoutesName.homePage,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        name: RoutesName.profileView,
        path: RoutesName.profileView,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        name: RoutesName.chatList,
        path: RoutesName.chatList,
        builder: (context, state) => const ChatView(),
      ),
    ],
  );
}
