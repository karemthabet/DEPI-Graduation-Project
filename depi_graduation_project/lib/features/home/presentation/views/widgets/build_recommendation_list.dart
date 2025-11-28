import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/recommendation_card.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/recommendation_shimmer.dart';

class BuildRecommendationList extends StatelessWidget {
  const BuildRecommendationList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesCubit, PlacesState>(
      builder: (context, state) {
        // Loading state - show shimmer
        if (state is PlacesLoading) {
          return const RecommendationShimmer();
        }

        // Loaded state - show recommendations
        if (state is PlacesLoaded) {
          final recommendations = state.topRecommendations;

          // Empty state - no recommendations available
          if (recommendations.isEmpty) {
            return SizedBox(
              height: 200.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.recommend_outlined,
                      size: 48.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No Recommendations Available',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Check back later for top places',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success state - display recommendations
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: recommendations.length,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            itemBuilder: (context, index) {
              final place = recommendations[index];
              final imageUrl =
                  place.photoReference != null
                      ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place.photoReference}&key=AIzaSyA3FifUzz1TsB2bknK0VARH_45PT_AuyMw'
                      : 'https://www.legrand.com.eg/modules/custom/legrand_ecat/assets/img/no-image.png';

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: GestureDetector(
                  onTap: () {
                    final itemModel = ItemModel(
                      id: place.placeId,
                      name: place.name,
                      location: place.vicinity,
                      image: imageUrl,
                      rating: place.rating?.toString() ?? '0.0',
                      openNow: place.openingHours?.openNow ?? false,
                      description:
                          place.description ?? 'No description available',
                    );
                    context.push(
                      RoutesName.categoriesViewDetails,
                      extra: itemModel,
                    );
                  },
                  child: RecommendationCard(
                    title: place.name,
                    location: place.vicinity,
                    rating: place.rating ?? 0.0,
                    imageUrl: imageUrl,
                    isFullWidth: true,
                  ),
                ),
              );
            },
          );
        }

        // Error state - show error message
        if (state is PlacesError) {
          return SizedBox(
            height: 200.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: Colors.red[400],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Failed to load recommendations',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.red[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<PlacesCubit>().reload();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Initial state - show shimmer
        return const RecommendationShimmer();
      },
    );
  }
}
