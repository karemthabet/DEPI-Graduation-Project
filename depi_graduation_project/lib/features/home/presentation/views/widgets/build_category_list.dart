import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_category_item.dart';

class BuildCategoryList extends StatelessWidget {
  const BuildCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        itemCount: 20,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap:
                () => context.push(
                  RoutesName.categoriesView,
                  extra: 'Tourist Attractions',
                ),
            child: const BuildCategoryItem(
              title: 'Tourist Attractions',
              image:
                  'https://cdn.alweb.com/thumbs/travel/article/fit710x532/%D8%A7%D9%84%D8%A3%D9%87%D8%B1%D8%A7%D9%85%D8%A7%D8%AA-%D8%A3%D9%87%D9%85-%D9%85%D8%B9%D9%84%D9%85-%D8%B3%D9%8A%D8%A7%D8%AD%D9%8A-%D8%B9%D9%84%D9%8A%D9%83-%D8%B2%D9%8A%D8%A7%D8%B1%D8%AA%D9%87-%D9%81%D9%8A-%D9%85%D8%B5%D8%B1.jpg',
            ),
          );
        },
      ),
    );
  }
}
