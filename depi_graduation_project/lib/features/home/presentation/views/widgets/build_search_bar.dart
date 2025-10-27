import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/utils/styles/app_text_styles.dart';

class BuildSearchBar extends StatelessWidget {
  const BuildSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Find things you\'re interested in',
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: Colors.grey,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
