import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/core/widgets/password_field.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_state.dart';
import 'package:whatsapp/features/profile/presentation/views/widgets/custom_button.dart';
import 'package:whatsapp/features/profile/presentation/views/widgets/profile_image_picker.dart';

class EditProfileViewBody extends StatefulWidget {
  const EditProfileViewBody({super.key});

  @override
  State<EditProfileViewBody> createState() => _EditProfileViewBodyState();
}

class _EditProfileViewBodyState extends State<EditProfileViewBody> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  File? _newImageFile;
  String? _currentAvatarUrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<UserCubit>().state;
    if (state is UserLoaded) {
      nameController.text = state.user.fullName;
      emailController.text = state.user.email;
      _currentAvatarUrl = state.user.avatarUrl;
      passwordController.text = 'Password Obse';
    }
  }

  void _updatePickedImage(File? file) {
    setState(() {
      _newImageFile = file;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final state = context.read<UserCubit>().state;
    if (state is UserLoaded) {
      final updatedUser = state.user.copyWith(fullName: nameController.text);

      await context.read<UserCubit>().updateUserProfile(
        updatedUser,
        _newImageFile,
      );

      // if (mounted) {
      //   context.push(RoutesName.profileView);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.darkBlue,
            ),
          );

          if (mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 10.h),

              ProfileImagePicker(
                onImagePicked: _updatePickedImage,
                initialAvatarUrl: _currentAvatarUrl,
              ),

              SizedBox(height: 24.h),

              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextFormField(
                        controller: nameController,
                        hintText: 'Name',
                        focusNode: nameFocus,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextFormField(
                        controller: emailController,
                        hintText: 'Email',
                        focusNode: emailFocus,
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PasswordField(
                        controller: passwordController,
                        hintText: 'Password',
                        focusNode: passwordFocus,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 68.h),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      backGroungColor: AppColors.orange,
                      text: 'Save',
                      textColor: Colors.white,
                      onPressed: _handleSave,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      backGroungColor: Colors.white,
                      text: 'Cancel',
                      textColor: AppColors.darkBlue,
                      outLine: const BorderSide(
                        color: AppColors.darkBlue,
                        width: 1,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
