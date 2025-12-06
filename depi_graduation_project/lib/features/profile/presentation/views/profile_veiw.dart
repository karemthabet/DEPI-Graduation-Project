import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/features/profile/presentation/views/widgets/profile_view_body.dart';

import 'package:whatsapp/l10n/app_localizations.dart';

class ProfileVeiw extends StatelessWidget {
  const ProfileVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            color: AppColors.darkBlue,
          ),
        ),
        centerTitle: true,
      ),
      body: const ProfileViewBody(),
    );
  }
}
