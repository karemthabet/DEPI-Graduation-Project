import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_category_list.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_profile_section.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_recently_viewed.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_recommendation_list.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_search_bar.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    super.initState();
    // Load places when the home view is initialized
    context.read<PlacesCubit>().loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PlacesCubit, PlacesState>(
        builder: (context, state) {
          // Show error dialog if there's a location/permission error
          if (state is PlacesError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.failure.errMessage.contains('إذن') || 
                  state.failure.errMessage.contains('GPS')) {
                _showLocationErrorDialog(context, state.failure.errMessage);
              }
            });
          }

          return SingleChildScrollView(
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
          );
        },
      ),
    );
  }

  void _showLocationErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ في الموقع'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PlacesCubit>().loadPlaces();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
