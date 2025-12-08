import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/helper/app_dialogs.dart';
import 'package:whatsapp/core/helper/app_snack_bar.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/login/presentation/cubit/auth_cubit.dart';
import 'package:whatsapp/features/login/presentation/cubit/auth_state.dart';
import 'package:whatsapp/features/login/presentation/views/widgets/password_field.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
import 'signup_view.dart';
import 'forget_password_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpView()),
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    final l10n = AppLocalizations.of(context)!;

    if (state is AuthSuccess) {
      AppSnackBar.success(context, l10n.loginSuccess);
      context.go(RoutesName.mainView);
    } else if (state is AuthFailure) {
      AppSnackBar.error(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BackButton(),
                const SizedBox(height: 15),
                _WelcomeHeader(text: l10n.welcomeBack),
                const SizedBox(height: 100),
                _EmailField(controller: _emailController),
                const SizedBox(height: 20),
                PasswordField(
                  hintText: l10n.password,
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 8),
                _ForgotPasswordButton(onPressed: _navigateToForgotPassword),
                const SizedBox(height: 10),
                // BlocConsumer محصور على LoginButton فقط
                BlocConsumer<AuthCubit, AuthState>(
                  listener: _handleAuthStateChanges,
                  builder: (context, state) {
                    return _LoginButton(
                      state: state,
                      onPressed: _handleSignIn,
                    );
                  },
                ),
                const SizedBox(height: 20),
                _OrContinueText(text: l10n.orContinue),
                const SizedBox(height: 15),
                const _GoogleButton(),
                const SizedBox(height: 20),
                _SignUpPrompt(onTap: _navigateToSignUp),
                const SizedBox(height: 10),
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
        fontWeight: FontWeight.w700,
        color: const Color(0xFF243E4B),
        height: 1.17,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined),
        hintText: l10n.email,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.email;
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _ForgotPasswordButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          l10n.forgotPassword,
          style: const TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final AuthState state;
  final VoidCallback onPressed;
  const _LoginButton({required this.state, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          foregroundColor: const Color(0xFF243E4B),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          l10n.login,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF243E4B),
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
    return Center(child: Text(text));
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          l10n.google,
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

class _SignUpPrompt extends StatelessWidget {
  final VoidCallback onTap;
  const _SignUpPrompt({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.noAccount),
        GestureDetector(
          onTap: onTap,
          child: Text(
            l10n.signUp,
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
