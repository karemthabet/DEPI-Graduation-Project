import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/styles/app_text_styles.dart';

class GeneralArrowBack extends StatelessWidget {
  const GeneralArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Row(
        children: [
          const Icon(Icons.arrow_back_ios),
          Text(
            'Back',
            style: AppTextStyles.labelLarge(context).copyWith(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
