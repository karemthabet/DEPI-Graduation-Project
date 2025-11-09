import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        if (state is PlacesLoaded) {
          // Filter categories that have at least one place
          final availableCategories = AppConstants.categories.entries
              .where((entry) => 
                  state.categorized.containsKey(entry.key) && 
                  state.categorized[entry.key]!.isNotEmpty)
              .toList();

          if (availableCategories.isEmpty) {
            return SizedBox(
              height: 110.h,
              child: Center(
                child: Text(
                  'لا توجد فئات متاحة',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ),
            );
          }

          return SizedBox(
            height: 110.h,
            child: ListView.builder(
              itemCount: availableCategories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = availableCategories[index].key;
                final categoryName = availableCategories[index].value;
                final placesCount = state.categorized[category]?.length ?? 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
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
                    count: placesCount,
                  ),
                );
              },
            ),
          );
        }

        // Show loading or empty state
        return SizedBox(
          height: 110.h,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

 String _getCategoryImage(String category) {
  switch (category) {
    case 'tourist_attraction':
      return 'assets/images/Ellipse 11 (1).png';
    case 'historical':
      return 'assets/images/Ellipse 11 (1).png';
    case 'museum':
      return 'assets/images/Ellipse 11 (1).png';
    case 'restaurant':
      return 'assets/images/Ellipse 11 (1).png';
    case 'cafe':
      return 'assets/images/Ellipse 11 (1).png';
    case 'hotel':
      return 'assets/images/Ellipse 11 (1).png';
    case 'park':
      return 'assets/images/Ellipse 11 (1).png';
    case 'shopping_mall':
      return 'assets/images/Ellipse 11 (1).png';
    default:
      return 'assets/images/Ellipse 11.png';
  }
}

}
