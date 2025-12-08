import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/helper/app_dialogs.dart';
import 'package:whatsapp/core/helper/app_logger.dart';
import 'package:whatsapp/core/helper/app_snack_bar.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/login/presentation/cubit/auth_cubit.dart';
import 'package:whatsapp/features/login/presentation/cubit/auth_state.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
import 'widgets/password_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      AppSnackBar.error(
        context,
        AppLocalizations.of(context)!.passwordsNoMatch,
      );
      return;
    }

    context.read<AuthCubit>().signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      AppSnackBar.warning(
        context,
        'You must confirm your email to login',
      );
      context.go(RoutesName.login);
    } else if (state is AuthFailure) {
      AppSnackBar.error(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    AppLogger.log('SignUpView build');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BackButton(),
                const SizedBox(height: 10),
                _WelcomeHeader(text: l10n.letsGetStarted),
                const SizedBox(height: 40),
                _NameField(controller: _nameController),
                const SizedBox(height: 16),
                _EmailField(controller: _emailController),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _passwordController,
                  hintText: l10n.password,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _confirmPasswordController,
                  hintText: l10n.confirmPassword,
                  icon: Icons.lock_outline,
                  isConfirmPassword: true,
                ),
                const SizedBox(height: 24),

                /// BlocConsumer
                BlocConsumer<AuthCubit, AuthState>(
                  listener: _handleAuthStateChanges,
                  builder: (context, state) {
                    return _SignUpButton(
                      state: state,
                      onPressed: _handleSignUp,
                    );
                  },
                ),
                const SizedBox(height: 16),
                _OrContinueText(text: l10n.orContinue),
                const SizedBox(height: 16),
                const _GoogleButton(),
                const SizedBox(height: 24),
                const _LoginPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== EXTRACTED WIDGETS ====================

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF243E4B)),
      onPressed: () => Navigator.pop(context),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  final String text;
  const _WelcomeHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF243E4B),
        height: 1.1,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController controller;
  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline),
        hintText: AppLocalizations.of(context)!.name,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name is required';
        }
        if (value.trim().length < 3) {
          return 'Name must be at least 3 characters';
        }
        return null;
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        hintText: AppLocalizations.of(context)!.email,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        if (!value.trim().endsWith('@gmail.com')) {
          return 'Email must be a valid @gmail.com address';
        }
        return null;
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final AuthState state;
  final VoidCallback onPressed;

  const _SignUpButton({required this.state, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (state is AuthLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFE26D)),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFE26D),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.signUp,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _OrContinueText extends StatelessWidget {
  final String text;
  const _OrContinueText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF243E4B),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          AppDialogs.showInfo(
            context,
            message: '!Google Sign In feature coming soon',
          );
        },
        icon: Image.asset(
          'assets/images/google_icon.png',
          height: 24,
        ),
        label: Text(
          AppLocalizations.of(context)!.google,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF243E4B),
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(
            color: Color(0xFF243E4B),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.alreadyHaveAccount,
          style: const TextStyle(color: Color(0xFF243E4B)),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context)!.login,
            style: const TextStyle(
              color: Color(0xFFFECD27),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
