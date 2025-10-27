import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/utils/assets/app_assets.dart';
import 'package:whatsapp/core/utils/styles/app_text_styles.dart';

class BuildProfileSection extends StatelessWidget {
  const BuildProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundImage: const AssetImage(AppAssets.imagesMyPhoto),
        ),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Kareem Thabet',
              style: AppTextStyles.titleMedium(
                context,
              ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4.h),
            Text(
              'Welcome to Guidee',
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: Colors.grey,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
