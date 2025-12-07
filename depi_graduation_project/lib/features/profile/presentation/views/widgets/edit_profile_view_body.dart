import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:whatsapp/core/utils/colors/app_colors.dart';

import 'package:whatsapp/core/widgets/custom_text_form_field.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_state.dart';
import 'package:whatsapp/features/profile/presentation/views/widgets/custom_button.dart';
import 'package:whatsapp/features/profile/presentation/views/widgets/profile_image_picker.dart';
import 'package:whatsapp/core/services/network_checker.dart';

import 'package:whatsapp/l10n/app_localizations.dart';

class EditProfileViewBody extends StatefulWidget {
  const EditProfileViewBody({super.key});

  @override
  State<EditProfileViewBody> createState() => _EditProfileViewBodyState();
}

class _EditProfileViewBodyState extends State<EditProfileViewBody> {
  final nameController = TextEditingController();
  final nameFocus = FocusNode();
  File? _newImageFile;
  String? _currentAvatarUrl;
  String _initialName = '';
  bool _isImageRemoved = false;
  final ValueNotifier<bool> _isDataChangedNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    final state = context.read<UserCubit>().state;
    if (state is UserLoaded) {
      nameController.text = state.user.fullName;
      _initialName = state.user.fullName;
      _currentAvatarUrl = state.user.avatarUrl;
    }
    nameController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final name = nameController.text.trim();
    final nameChanged = nameController.text != _initialName;

    final imageChanged = _newImageFile != null || _isImageRemoved;

    _isDataChangedNotifier.value =
        name.isNotEmpty && (nameChanged || imageChanged);
  }

  void _updatePickedImage(File? file) {
    _newImageFile = file;
    if (file == null) {
      _isImageRemoved = true;
    } else {
      _isImageRemoved = false;
    }
    _checkForChanges();
  }

  @override
  void dispose() {
    nameController.dispose();
    nameFocus.dispose();
    _isDataChangedNotifier.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final state = context.read<UserCubit>().state;
    if (state is UserLoaded) {
       if (!await NetworkChecker.instance.isConnected()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.noInternetConnection),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final updatedUser = state.user.copyWith(fullName: nameController.text);

      await context.read<UserCubit>().updateUserProfile(
        updatedUser,
        _newImageFile,
        isProfileImageRemoved: _isImageRemoved,
      );
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
                    Text(
                      AppLocalizations.of(context)!.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextFormField(
                        controller: nameController,
                        hintText: AppLocalizations.of(context)!.name,
                        focusNode: nameFocus,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 68.h),

              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        final isLoading = state is UserLoading;
                        return ValueListenableBuilder<bool>(
                          valueListenable: _isDataChangedNotifier,
                          builder: (context, isDataChanged, child) {
                            return CustomButton(
                              backGroungColor: isDataChanged
                                  ?  const Color(0xFFFFE26D)
                                  : Colors.grey,
                              text: isLoading
                                  ? ''
                                  : AppLocalizations.of(context)!.save,
                              textColor: Colors.white,
                              onPressed: (isDataChanged && !isLoading)
                                  ? _handleSave
                                  : null,
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : null,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      backGroungColor: Colors.white,
                      text: AppLocalizations.of(context)!.cancel,
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
