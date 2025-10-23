import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_category_list.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_profile_section.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_recently_viewed.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_recommendation_list.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_search_bar.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BuildProfileSection(),
              SizedBox(height: 20.h),

              const BuildSearchBar(),
              SizedBox(height: 24.h),

              Text(
                'Browse By Category',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),

              const BuildCategoryList(),

              SizedBox(height: 20.h),

              Text(
                'Top Recommendations',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              const BuildRecommendationList(),

              SizedBox(height: 20.h),

              Text(
                'Recently Viewed',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              const BuildRecentlyViewed(),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
