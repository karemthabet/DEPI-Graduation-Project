import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';

class ProfileVeiw extends StatelessWidget {
  const ProfileVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            color: AppColors.darkBlue,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.sp, horizontal: 16.sp),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          Dialog(child: Image.asset('assets/images/auth.png')),
                    );
                  },
                  child: CircleAvatar(
                    radius: 44.r,
                    backgroundImage: const AssetImage('assets/images/auth.png'),
                  ),
                ),

                SizedBox(width: 20.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      context.push(RoutesName.editProfileView);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Marina',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'mmmmm774@gmail.com',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: AppColors.darkBlue,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.sp,
                          color: AppColors.darkBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.language,
                size: 24.sp,
                color: AppColors.darkBlue,
              ),
              title: Text(
                'Language',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: AppColors.darkBlue,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: AppColors.darkBlue,
              ),
              onTap: () {
                context.push(RoutesName.languageProfileView);
              },
            ),
            SizedBox(height: 16.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.logout,
                size: 24.sp,
                color: AppColors.darkBlue,
              ),
              title: Text(
                'Log out',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  color: AppColors.darkBlue,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
