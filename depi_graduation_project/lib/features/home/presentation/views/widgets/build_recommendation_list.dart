import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/recommendation_card.dart';

class BuildRecommendationList extends StatelessWidget {
  const BuildRecommendationList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: const RecommendationCard(
              title: 'Grand Egyptian Museum',
              location: 'Giza, near the Pyramids',
              rating: 4.8,
              imageUrl:
                  'https://cdn.alweb.com/thumbs/travel/article/fit710x532/%D8%A7%D9%84%D8%A3%D9%87%D8%B1%D8%A7%D9%85%D8%A7%D8%AA-%D8%A3%D9%87%D9%85-%D9%85%D8%B9%D9%84%D9%85-%D8%B3%D9%8A%D8%A7%D8%AD%D9%8A-%D8%B9%D9%84%D9%8A%D9%83-%D8%B2%D9%8A%D8%A7%D8%B1%D8%AA%D9%87-%D9%81%D9%8A-%D9%85%D8%B5%D8%B1.jpg',
            ),
          );
        },
      ),
    );
  }
}
