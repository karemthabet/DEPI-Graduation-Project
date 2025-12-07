import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/l10n/app_localizations.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> getOnboardingData(BuildContext context) {
    return [
      {
        'image': 'assets/images/onboardingimg1.jpg',
        'title': AppLocalizations.of(context)!.onboardingTitle1,
        'desc': AppLocalizations.of(context)!.onboardingDesc1,
      },
      {
        'image': 'assets/images/onboardingimg2.jpg',
        'title': AppLocalizations.of(context)!.onboardingTitle2,
        'desc': AppLocalizations.of(context)!.onboardingDesc2,
      },
      {
        'image': 'assets/images/onboarding3.jpg',
        'title': AppLocalizations.of(context)!.onboardingTitle3,
        'desc': AppLocalizations.of(context)!.onboardingDesc3,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final onboardingData = getOnboardingData(context);

    // Need to define _nextPage here or make it accept data/context if needed,
    // but _pageController is part of state, so it's fine.
    // However, _nextPage used onboardingData.length.
    // I can just check _currentPage against hardcoded 3 or get length from local var.
    // Better to define _nextPage closure or method that checks the local data length.

    void nextPage() {
      if (_currentPage < onboardingData.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        context.go(RoutesName.welcome);
      }
    }

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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
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
                                  AppLocalizations.of(
                                    context,
                                  )!.illustrationMissing,
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
                      children: List.generate(onboardingData.length, (
                        dotIndex,
                      ) {
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
                            ''  , // الطريقة الصحيحة للحصول على النص
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
                              '', // الطريقة الصحيحة للحصول على النص
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
                                onTap: nextPage,
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
                  AppLocalizations.of(context)!.skip,
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
