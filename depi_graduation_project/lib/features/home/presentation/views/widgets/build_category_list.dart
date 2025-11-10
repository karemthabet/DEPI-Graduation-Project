import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:whatsapp/core/utils/constants/app_constants.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/views/places_list_view.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_category_item.dart';

class BuildCategoryList extends StatelessWidget {
  const BuildCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesCubit, PlacesState>(
      builder: (context, state) {
        if (state is PlacesLoading) {
          return SizedBox(
            height: 110.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Skeletonizer(
                  enabled: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: const BuildCategoryItem(
                      title: 'Loading...',
                      image: 'assets/images/others.webp',
                      count: 0,
                    ),
                  ),
                );
              },
            ),
          );
        }

        if (state is PlacesLoaded) {
          final availableCategories =
              AppConstants.categories.entries
                  .where(
                    (entry) =>
                        state.categorized.containsKey(entry.key) &&
                        state.categorized[entry.key]!.isNotEmpty,
                  )
                  .toList();

          availableCategories.sort((a, b) {
            if (a.key == 'others') return 1;
            if (b.key == 'others') return -1;
            return 0;
          });

          if (availableCategories.isEmpty) {
            return SizedBox(
              height: 110.h,
              child: Center(
                child: Text(
                  'No Categories Found',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ),
            );
          }

          return SizedBox(
            height: 110.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableCategories.length,
              itemBuilder: (context, index) {
                final category = availableCategories[index].key;
                final categoryName = availableCategories[index].value;
                final count = state.categorized[category]?.length ?? 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: context.read<PlacesCubit>(),
                              child: PlacesListView(
                                categoryKey: category,
                                categoryName: categoryName,
                              ),
                            ),
                      ),
                    );
                  },
                  child: BuildCategoryItem(
                    title: categoryName,
                    image: _getCategoryImage(category),
                    count: count,
                  ),
                );
              },
            ),
          );
        }

        if (state is PlacesError) {
          return Center(
            child: Text(
              'Error: ${state.failure.errMessage}',
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  String _getCategoryImage(String category) {
    switch (category) {
      case 'tourist_attraction':
        return 'assets/images/tourist.png';
      case 'historical':
        return 'assets/images/hiorestic.png';
      case 'museum':
        return 'assets/images/museum.png';
      case 'restaurant':
        return 'assets/images/pngtree-restaurant-interior-cartoon-png-image_15045864.png';
      case 'cafe':
        return 'assets/images/pngtree-delicious-cappuccino-coffee-cup-with-frothy-latte-art-and-scattered-roasted-png-image_14844699.png';
      case 'hotel':
        return 'assets/images/hotel-png-11554023952cxktw5vjtr.png';
      case 'park':
        return 'assets/images/images.png';
      case 'shopping_mall':
        return 'assets/images/7806057.png';
      case 'library':
        return 'assets/images/library.jpeg';
      case 'mosque':
        return 'assets/images/ai-generative-golden-mosque-illustration-free-png.png';
      case 'cinema':
        return 'assets/images/movie-theatre-png-13.png';
      case 'others':
        return 'assets/images/others.webp';
      default:
        return 'assets/images/others.webp';
    }
  }
}
