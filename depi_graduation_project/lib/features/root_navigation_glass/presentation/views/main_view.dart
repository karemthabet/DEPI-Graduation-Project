import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/home/presentation/views/home_view.dart';
import 'package:whatsapp/features/profile/presentation/views/profile_veiw.dart';

import 'package:whatsapp/features/root_navigation_glass/presentation/views/widgets/custom_glass_nav_bar.dart';
import 'package:whatsapp/features/visit_Screen/presentation/pages/visit_list_screen.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeView(),
      const VisitListScreen(),
      Center(
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
        ),
      ),
      const ProfileVeiw(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
