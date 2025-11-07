import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/password_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow
              Positioned(
                top: 14,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                "Let's get\nstarted",
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF243E4B),
                  height: 1.1,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 40),

              // Name field
              _buildTextField(
                icon: Icons.person_outline,
                hintText: 'Name',
              ),
              const SizedBox(height: 16),

              // Email field
              _buildTextField(
                icon: Icons.email_outlined,
                hintText: 'Email',
              ),
              const SizedBox(height: 16),

              // Password field
              const PasswordField(
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              // Confirm Password field
              const PasswordField(
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                isConfirmPassword: true,
              ),
              const SizedBox(height: 24),

              // Sign Up Button
              _buildSignUpButton(),

              const SizedBox(height: 16),

              // "Or continue with" text
              _buildContinueWithText(),

              const SizedBox(height: 16),

              // Google Button
              _buildGoogleButton(),

              const SizedBox(height: 24),

              // Already have an account
              _buildAlreadyHaveAccount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
  }) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFE26D),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildContinueWithText() {
    return const Center(
      child: Text(
        'Or continue with',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF243E4B),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          'assets/images/google_icon.png',
          height: 24,
        ),
        label: Text(
          'Google',
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

  Widget _buildAlreadyHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(color: Color(0xFF243E4B)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Sign In',
            style: TextStyle(
              color: Color(0xFFFECD27),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
