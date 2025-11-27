import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/home/data/models/item_model.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/recommendation_card.dart';
import 'package:whatsapp/features/home/data/models/place_model.dart';

class BuildRecommendationList extends StatelessWidget {
  final List<PlaceModel> recommendations;

  const BuildRecommendationList({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemBuilder: (context, index) {
          final place = recommendations[index];
          final imageUrl = place.photoReference != null
              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place.photoReference}&key=AIzaSyA3FifUzz1TsB2bknK0VARH_45PT_AuyMw'
              : 'https://www.legrand.com.eg/modules/custom/legrand_ecat/assets/img/no-image.png';

          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () {
                final itemModel = ItemModel(
                  id: place.placeId,
                  name: place.name,
                  location: place.vicinity,
                  image: imageUrl,
                  rating: place.rating?.toString() ?? '0.0',
                  openNow: place.openingHours?.openNow ?? false,
                  description: place.description ?? 'No description available',
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
              ),
            ),
          );
        },
      ),
    );
  }
}
