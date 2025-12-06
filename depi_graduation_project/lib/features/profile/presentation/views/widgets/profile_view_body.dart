import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_state.dart';
import 'package:whatsapp/core/localization/cubit/locale_cubit.dart';
import 'package:whatsapp/l10n/app_localizations.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  void showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        log('Bottom Sheet Built');
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseLanguage,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Image.asset(
                  'assets/images/egflag.png',
                  width: 32,
                  height: 32,
                ),
                title: Text(AppLocalizations.of(context)!.arabic),
                onTap: () {
                  context.read<LocaleCubit>().changeLocale(const Locale('ar'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/usflag.png',
                  width: 32,
                  height: 32,
                ),
                title: Text(AppLocalizations.of(context)!.english),
                onTap: () {
                  context.read<LocaleCubit>().changeLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().loadUserProfile();
    });
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoggedOut) {
          if (mounted) {
            context.go(RoutesName.login);
          }
        }
      },

      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          String name = AppLocalizations.of(context)!.guest;
          String email = '';
          String? profileImage = 'assets/images/profile.png';

          if (state is UserLoaded) {
            name = state.user.fullName;
            email = state.user.email;
            profileImage = state.user.avatarUrl;
          } else if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.darkBlue),
            );
          } else if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 50, color: Colors.grey),
                  const SizedBox(height: 16),

                  Text(
                    AppLocalizations.of(context)!.errorLoadingProfile,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.go(RoutesName.login);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.goToLogin,
                      style: const TextStyle(color: AppColors.darkBlue),
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 48.sp, horizontal: 16.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 44.r,
                        backgroundImage:
                            profileImage != null && profileImage.isNotEmpty
                            ? CachedNetworkImageProvider(profileImage)
                                  as ImageProvider
                            : const AssetImage('assets/images/profile.png'),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: InkWell(
                        onTap: () => context.push(RoutesName.editProfileView),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: AppColors.darkBlue,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  email,
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

                BlocBuilder<LocaleCubit, LocaleState>(
                  builder: (context, localeState) {
                    final currentLocale = Localizations.localeOf(
                      context,
                    ).languageCode;
                    final displayLanguage = currentLocale == 'ar'
                        ? 'Arabic'
                        : 'English';

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.language,
                        size: 24.sp,
                        color: AppColors.darkBlue,
                      ),
                      title: Text(
                        AppLocalizations.of(
                          context,
                        )!.languageWithCode(displayLanguage),
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
                      onTap: () => showLanguagePicker(context),
                    );
                  },
                ),

                SizedBox(height: 16.h),

                // 🚪 Log out
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.logout,
                    size: 24.sp,
                    color: AppColors.darkBlue,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.logOut,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  onTap: () {
                    context.read<UserCubit>().signOutUser();
                    context.go(RoutesName.login);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
