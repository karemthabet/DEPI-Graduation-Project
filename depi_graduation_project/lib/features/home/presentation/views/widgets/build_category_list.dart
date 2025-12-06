import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/features/home/presentation/cubit/places_cubit.dart';
import 'package:whatsapp/features/home/presentation/views/places_list_view.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_category_item.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/category_shimmer.dart';
import 'package:whatsapp/l10n/app_localizations.dart';

class BuildCategoryList extends StatelessWidget {
  const BuildCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesCubit, PlacesState>(
      builder: (context, state) {
        // Loading state - show shimmer
        if (state is PlacesLoading) {
          return const CategoryShimmer();
        }

        // Loaded state - show categories
        if (state is PlacesLoaded) {
          final availableCategories = state.availableCategories;

          // Empty state - no categories available
          if (availableCategories.isEmpty) {
            return SizedBox(
              height: 110.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 40.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppLocalizations.of(context)!.noCategoriesFound,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success state - display categories
          return SizedBox(
            height: 110.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: availableCategories.length,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemBuilder: (context, index) {
                final categoryKey = availableCategories.keys.elementAt(index);
                final categoryName = availableCategories.values.elementAt(
                  index,
                );
                final count = state.categorized[categoryKey]?.length ?? 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<PlacesCubit>(),
                          child: PlacesListView(
                            categoryKey: categoryKey,
                            categoryName: categoryName,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: BuildCategoryItem(
                      title: categoryName,
                      image: _getCategoryImage(categoryKey),
                      count: count,
                    ),
                  ),
                );
              },
            ),
          );
        }

        // Error state - show error message
        if (state is PlacesError) {
          return SizedBox(
            height: 110.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 40.sp,
                    color: Colors.red[400],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppLocalizations.of(context)!.failedToLoadCategories,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Initial state - show shimmer
        return const CategoryShimmer();
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
