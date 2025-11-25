import 'package:flutter/material.dart';
import 'package:whatsapp/features/FavouriteScreen/presentation/view/favourite_view.dart';
import 'package:whatsapp/features/home/presentation/views/home_view.dart';
import 'package:whatsapp/features/profile/presentation/views/profile_veiw.dart';
import 'package:whatsapp/features/root_navigation_glass/presentation/views/widgets/custom_glass_nav_bar.dart';
import 'package:whatsapp/features/visit_Screen/view/visit_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const VisitedView(),
    FavouriteView(userId: '22222222-2222-2222-2222-222222222222'),

    const ProfileVeiw(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          _screens[currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
