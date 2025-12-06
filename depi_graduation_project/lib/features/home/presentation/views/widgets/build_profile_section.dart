import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/core/utils/styles/app_text_styles.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_state.dart';
import 'package:whatsapp/l10n/app_localizations.dart';

class BuildProfileSection extends StatelessWidget {
  const BuildProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        String name = AppLocalizations.of(context)!.guest;
        String? profileImage = 'assets/images/profile.png';

        if (state is UserLoaded) {
          name = state.user.fullName;
          profileImage = state.user.avatarUrl;
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
                    : const AssetImage('assets/images/profile.png'),
              ),
            ),
            SizedBox(width: 14.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.helloUser(name),
                  style: AppTextStyles.titleMedium(
                    context,
                  ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppLocalizations.of(context)!.welcomeToGuidee,
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
