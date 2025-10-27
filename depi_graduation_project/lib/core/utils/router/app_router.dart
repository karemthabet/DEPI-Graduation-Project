import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/general_404_page/general_404_page.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/profile/presentation/views/edit_profile_view.dart';
import 'package:whatsapp/features/profile/presentation/views/profile_veiw.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutesName.profileView,
    errorBuilder: (context, state) => const General404Page(),
    routes: [
     
     
      
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
    
      
    ],
  );
}
