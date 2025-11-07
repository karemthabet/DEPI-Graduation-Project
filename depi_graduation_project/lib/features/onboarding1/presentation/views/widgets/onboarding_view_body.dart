import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboardingimg1.jpg',
      'title': 'Discover Famous\nLandmarks',
      'desc': 'Explore Egypt’s iconic attractions, \n from ancient wonders to modern gems'
    },
    {
      'image': 'assets/images/onboardingimg2.jpg',
      'title': 'Plan Your Journey',
      'desc': 'Create and customize your own visit list with museums, malls, hidden gems, and iconic landmarks.',
    },
    {
      'image': 'assets/images/onboarding3.jpg',
      'title': 'Navigate With Ease',
      'desc': 'Get map directions, live alerts, and instant notifications when you’re near a landmark.',
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
                      context.go(RoutesName.welcome);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// --- MAIN PAGEVIEW CONTENT ---
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final item = onboardingData[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// IMAGE SECTION
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                      child: Center(
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.contain,
                          height: 0.45.sh,
                          width: 0.8.sw,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 0.45.sh,
                              width: 0.8.sw,
                              decoration: BoxDecoration(
                                color: AppColors.lightGray.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Center(
                                child: Text(
                                  'Illustration Missing',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    /// DOTS INDICATOR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(onboardingData.length, (dotIndex) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == dotIndex
                                ? AppColors.primaryBlue
                                : AppColors.lightGray,
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 20.h),

                    /// CONTENT CARD
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: 32.h,
                          left: 32.w,
                          right: 32.w,
                          bottom: 40.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.r),
                            topRight: Radius.circular(40.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TITLE
                            Text(
                              item['title']!,
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkText,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 16.h),

                            /// DESCRIPTION
                            Text(
                              item['desc']!,
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: AppColors.darkText.withOpacity(0.8),
                                height: 1.4,
                              ),
                            ),

                            const Spacer(),

                            /// NEXT BUTTON
                            Center(
                              child: GestureDetector(
                                onTap: _nextPage,
                                child: Container(
                                  width: 64.w,
                                  height: 64.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32.r),
                                    border: Border.all(
                                      color: AppColors.primaryBlue,
                                      width: 2.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 32.sp,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            /// --- SKIP BUTTON ---
            Positioned(
              top: 10.h,
              right: 10.w,
              child: TextButton(
                onPressed: () {
                 context.go(RoutesName.welcome);
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
