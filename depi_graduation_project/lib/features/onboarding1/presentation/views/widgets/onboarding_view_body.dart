import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whatsapp/core/helper/app_logger.dart';
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

//use ValueNotifier to update the UI when the page changes
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  late final List<Map<String, String>> _onboardingData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _onboardingData = [
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

  void _nextPage() {
    if (_currentPageNotifier.value < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      GetStorage().write('isOnBoardingSeen', true);
      context.go(RoutesName.welcome);
    }
  }

  void _skip() {
    GetStorage().write('isOnBoardingSeen', true);
    context.go(RoutesName.welcome);
  }

  @override
  void dispose() {
    /// dispose the ValueNotifier to avoid memory leaks
    _currentPageNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No rebild the widget when the data changes
    AppLogger.log('onboarding data: $_onboardingData');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// ---------------- PAGE VIEW ----------------
            PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,

              //update the ValueNotifier when the page changes
              onPageChanged: (i) => _currentPageNotifier.value = i,
              itemBuilder: (_, index) {
                final item = _onboardingData[index];
                return Column(
                  children: [
                    /// ----------- IMAGE -----------
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      child: Center(
                        child: Image.asset(
                          item['image']!,
                          height: 0.45.sh,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            height: 0.45.sh,
                            decoration: BoxDecoration(
                              color: AppColors.lightGray.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .illustrationMissing,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// ----------- DOTS -----------
                    //Rebuild the dots only
                    ValueListenableBuilder<int>(
                      valueListenable: _currentPageNotifier,
                      builder: (context, currentPage, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _onboardingData.length,
                            (dot) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: currentPage == dot ? 12.w : 8.w,
                              height: currentPage == dot ? 12.w : 8.w,
                              decoration: BoxDecoration(
                                color: currentPage == dot
                                    ? AppColors.primaryBlue
                                    : AppColors.lightGray,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24.h),

                    /// ----------- CONTENT -----------
                    /// No rebild the widget when the data changes
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 32.h,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40.r),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']!,
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkText,
                              ),
                            ),
                            SizedBox(height: 16.h),

                            Text(
                              item['desc']!,
                              style: TextStyle(
                                fontSize: 18.sp,
                                height: 1.4,
                                color: AppColors.darkText.withOpacity(0.8),
                              ),
                            ),

                            const Spacer(),

                            /// ----------- NEXT BUTTON -----------
                            Center(
                              child: GestureDetector(
                                onTap: _nextPage,
                                child: Container(
                                  width: 50.w,
                                  height: 50.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primaryBlue,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 12,
                                        color: Colors.black.withOpacity(0.15),
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 34.sp,
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

            /// ---------------- SKIP BUTTON ----------------
            Positioned(
              top: 10.h,
              right: 10.w,
              child: TextButton(
                onPressed: _skip,
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
