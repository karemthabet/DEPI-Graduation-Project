import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/general_404_page/general_404_page.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/presentation/views/categories_view.dart';
import 'package:whatsapp/features/home/presentation/views/categories_view_details.dart';
import 'package:whatsapp/features/home/presentation/views/home_view.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/places_example_usage.dart';
import 'package:whatsapp/features/login/presentation/views/sign_in_view.dart';
import 'package:whatsapp/features/login/presentation/views/signup_view.dart';
import 'package:whatsapp/features/login/presentation/views/welcome_view.dart';
import 'package:whatsapp/features/root_navigation_glass/presentation/views/main_view.dart';
import 'package:whatsapp/features/profile/presentation/views/edit_profile_view.dart';
import 'package:whatsapp/features/profile/presentation/views/profile_veiw.dart';
import 'package:whatsapp/features/onboarding1/onboarding_view.dart';
import 'package:whatsapp/features/splash/presentation/views/splash_view.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutesName.mainView,
    errorBuilder: (context, state) => const General404Page(),
    routes: [
      GoRoute(
        name: RoutesName.mainView,
        path: RoutesName.mainView,
        builder: (context, state) => const MainView(),
      ),
      GoRoute(
        name: RoutesName.placesExample,
        path: RoutesName.placesExample,
        builder: (context, state) => const PlacesExampleUsage(),
      ),
      GoRoute(
        name: RoutesName.categoriesViewDetails,
        path: RoutesName.categoriesViewDetails,
        builder: (context, state) {
          final itemModel = state.extra as ItemModel;
          return CategoriesViewDetails(itemModel: itemModel);
        },
      ),
      GoRoute(
        name: RoutesName.categoriesView,
        path: RoutesName.categoriesView,
        builder: (context, state) {
          final String title = state.extra as String;
          return CategoriesView(title: title);
        },
      ),
      GoRoute(
        name: RoutesName.profileView,
        path: RoutesName.profileView,
        builder: (context, state) => const ProfileVeiw(),
      ),
      GoRoute(
        name: RoutesName.editProfileView,
        path: RoutesName.editProfileView,
        builder: (context, state) => const EditProfileView(),
      ),
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
      GoRoute(
        name: RoutesName.homeView,
        path: RoutesName.homeView,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        name: RoutesName.onboarding,
        path: RoutesName.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        name: RoutesName.splash,
        path: RoutesName.splash,
        builder: (context, state) => const SplashView(),
      ),
    ],
  );
}
