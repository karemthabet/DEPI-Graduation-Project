import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/recently_viewed_card.dart';

class BuildRecentlyViewed extends StatelessWidget {
  const BuildRecentlyViewed({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      itemCount: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final uniqueId = '${DateTime.now().millisecondsSinceEpoch}_$index';
        final itemModel = ItemModel(
          description:
              'Visit the Grand Egyptian Museum to learn about the history of ancient Egypt.',
          location: 'Giza, near the Pyramids',
          name: 'Grand Egyptian Museum ${index + 1}',
          rating: '4.5',
          image:
              'https://cdn.alweb.com/thumbs/travel/article/fit710x532/%D8%A7%D9%84%D8%A3%D9%87%D8%B1%D8%A7%D9%85%D8%A7%D8%AA-%D8%A3%D9%87%D9%85-%D9%85%D8%B9%D9%84%D9%85-%D8%B3%D9%8A%D8%A7%D8%AD%D9%8A-%D8%B9%D9%84%D9%8A%D9%83-%D8%B2%D9%8A%D8%A7%D8%B1%D8%AA%D9%87-%D9%81%D9%8A-%D9%85%D8%B5%D8%B1.jpg',
          openNow: true,
        );

        return GestureDetector(
          onTap: () =>
              context.push(RoutesName.categoriesViewDetails, extra: itemModel),
          child: RecentlyViewedCard(
            itemModel: itemModel,
            heroTag: 'recently_viewed_$uniqueId',
          ),
        );
      },
    );
  }
}
