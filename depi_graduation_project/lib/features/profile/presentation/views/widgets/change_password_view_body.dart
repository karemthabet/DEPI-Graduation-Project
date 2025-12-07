import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'package:whatsapp/core/widgets/password_field.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_cubit.dart';
import 'package:whatsapp/features/profile/presentation/cubit/user_state.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
import 'package:whatsapp/core/services/network_checker.dart';

class ChangePasswordViewBody extends StatefulWidget {
  const ChangePasswordViewBody({super.key});

  @override
  State<ChangePasswordViewBody> createState() => _ChangePasswordViewBodyState();
}

class _ChangePasswordViewBodyState extends State<ChangePasswordViewBody> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final oldPasswordFocus = FocusNode();
  final newPasswordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    oldPasswordFocus.dispose();
    newPasswordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    final oldPass = oldPasswordController.text;
    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

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

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordMismatch),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.allFieldsRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Call Cubit
    context.read<UserCubit>().changePassword(oldPass, newPass);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.darkBlue,
            ),
          );
          Navigator.pop(context);
        } else if (state is UserError) {
          String errorMessage = state.message;
          if (state.message.contains('The old password is incorrect')) {
            errorMessage = AppLocalizations.of(context)!.incorrectPassword;
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is UserLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Old Password
              Text(
                AppLocalizations.of(context)!.oldPassword,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PasswordField(
                  controller: oldPasswordController,

                  focusNode: oldPasswordFocus,
                ),
              ),
              const SizedBox(height: 16),

              // New Password
              Text(
                AppLocalizations.of(context)!.newPassword,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PasswordField(
                  controller: newPasswordController,
                  focusNode: newPasswordFocus,
                ),
              ),
              const SizedBox(height: 16),

              // Confirm New Password
              Text(
                AppLocalizations.of(context)!.confirmNewPassword,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PasswordField(
                  controller: confirmPasswordController,

                  focusNode: confirmPasswordFocus,
                ),
              ),

              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE26D),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    foregroundColor: AppColors.darkBlue,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.darkBlue,
                        )
                      : Text(
                          AppLocalizations.of(context)!.save,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
