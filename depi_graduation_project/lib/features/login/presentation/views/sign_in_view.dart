import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'package:whatsapp/features/login/presentation/views/widgets/password_field.dart';
import 'package:whatsapp/l10n/app_localizations.dart';
import 'signup_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forget_password_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF243E4B);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back arrow
              IconButton(
                icon: const Icon(Icons.arrow_back, color: textColor),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 15),

              // Header text
              Text(
                AppLocalizations.of(context)!.welcomeBack,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF243E4B),
                  height: 1.17,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 100),

              // Email field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: AppLocalizations.of(context)!.email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              PasswordField(
                hintText: AppLocalizations.of(context)!.password,
                icon: Icons.lock_outline,
                controller: passwordController,
                isPassword: true,
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword,
                    style: const TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Log In button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    // Basic validation
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.authValidation,
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      // Supabase sign in
                      final response = await supabase.auth.signInWithPassword(
                        email: email,
                        password: password,
                      );

                      final user = response.user;

                      if (user == null) {
                        // Sign-in failed
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.invalidCredentials,
                            ),
                          ),
                        );
                        return;
                      }

                      // Check email verification
                      if (user.emailConfirmedAt == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.verifyEmail,
                            ),
                          ),
                        );
                        return;
                      }

                      // SUCCESS: Navigate to main view
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.loginSuccess,
                          ),
                        ),
                      );
                      context.go(RoutesName.mainView);
                    } on AuthException catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.message)));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unexpected error: $e')),
                      );
                    }
                  },
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
                    AppLocalizations.of(context)!.login,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF243E4B),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(child: Text(AppLocalizations.of(context)!.orContinue)),
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/images/google_icon.png',
                    height: 24,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.google,
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
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.noAccount),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpView()),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.signUp,
                      style: const TextStyle(
                        color: Color(0xFFFECD27),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
