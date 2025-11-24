import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/assets/app_assets.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/core/utils/styles/app_text_styles.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_state.dart';

class BuildProfileSection extends StatelessWidget {
  const BuildProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        String name = 'Guest';
        String? profileImage;

        if (state is UserLoaded) {
          name = state.user.name;
          profileImage = state.user.profileImage;
        }

        return Row(
          children: [
            GestureDetector(
              onTap: () {
                context.push(RoutesName.profileView);
              },
              child: CircleAvatar(
                radius: 25.r,
                backgroundImage: profileImage != null && profileImage.isNotEmpty
                    ? NetworkImage(profileImage) as ImageProvider
                    : const AssetImage(AppAssets.imagesMyPhoto),
              ),
            ),
            SizedBox(width: 14.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $name',
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
      },
    );
  }
}
