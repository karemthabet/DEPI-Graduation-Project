// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:whatsapp/core/utils/styles/app_text_styles.dart';
import 'package:whatsapp/core/widgets/general_arrow_back.dart';
import 'package:whatsapp/features/home/presentation/views/widgets/build_recently_viewed.dart';

class CategoriesViewBody extends StatelessWidget {
  const CategoriesViewBody({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
          child: Column(
            children: [
              const GeneralArrowBack(),
              Text(title, style: AppTextStyles.titleLarge(context)),
              SizedBox(height: 20.h),
              const BuildRecentlyViewed(),
            ],
          ),
        ),
      ),
    );
  }
}
