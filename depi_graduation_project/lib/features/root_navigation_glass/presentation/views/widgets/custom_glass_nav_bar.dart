// import 'package:flutter/material.dart';
// import 'package:whatsapp/core/utils/colors/app_colors.dart';
//
// class CustomBottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//
//   const CustomBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: AppColors.unselectionNavBarColor,
//         borderRadius: BorderRadius.circular(40),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Icons.home, 0),
//           _buildNavItem(Icons.menu, 1),
//           _buildNavItem(Icons.favorite, 2),
//           _buildNavItem(Icons.person, 3),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNavItem(IconData icon, int index) {
//     final bool isSelected = index == currentIndex;
//
//     return GestureDetector(
//       onTap: () => onTap(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         width: 46,
//         height: 46,
//         decoration: BoxDecoration(
//           color: isSelected
//               ? AppColors.selectionNavBarColor
//               : Colors.transparent,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           icon,
//           size: 26,
//           color: isSelected
//               ? AppColors.primaryColor
//               : AppColors.greyDark.withOpacity(0.9),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.darkBlue.withOpacity(0.50),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Colors.white.withOpacity(0.0),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                Image.asset('assets/images/Home.png', height: 24, width: 24),

                0,
              ),
              _buildNavItem(
                Image.asset('assets/images/list.png', height: 24, width: 24),

                1,
              ),
              _buildNavItem(
                Image.asset('assets/images/heart.png', height: 24, width: 24),
                2,
              ),
              _buildNavItem(
                Image.asset(
                  'assets/images/profileIcon.png',
                  height: 24,
                  width: 24,
                ),

                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(Widget iconWidget, int index) {
    final bool isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.selectionNavBarColor
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(child: iconWidget),
      ),
    );
  }
}
