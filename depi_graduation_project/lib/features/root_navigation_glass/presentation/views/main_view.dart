

import 'package:flutter/material.dart';
import 'package:whatsapp/features/root_navigation_glass/presentation/views/widgets/custom_glass_nav_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  final List<Widget> _screens = const [
    Center(child: Text('🏠 Home Screen', style: TextStyle(fontSize: 22))),
    Center(child: Text('🔍 Search Screen', style: TextStyle(fontSize: 22))),
    Center(child: Text('❤️ Favorites Screen', style: TextStyle(fontSize: 22))),
    Center(child: Text('👤 Profile Screen', style: TextStyle(fontSize: 22))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
