import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/setup_service_locator.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/views/home_view.dart';
import 'package:whatsapp/features/profile/presentation/views/profile_veiw.dart';
import 'package:whatsapp/features/root_navigation_glass/presentation/views/widgets/custom_glass_nav_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    Center(child: IconButton(onPressed: () {}, icon: const Icon(Icons.menu))),
    Center(
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.favorite_border),
      ),
    ),
    const ProfileVeiw(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
    
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
