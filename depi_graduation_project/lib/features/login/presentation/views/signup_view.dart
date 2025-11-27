import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';   
import 'package:whatsapp/core/utils/router/routes_name.dart';
import 'widgets/password_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // Add controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final supabase = Supabase.instance.client; 

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

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
              Positioned(
                top: 14,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 10),

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

              _buildTextField(
                controller: nameController,
                icon: Icons.person_outline,
                hintText: 'Name',
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: emailController,
                icon: Icons.email_outlined,
                hintText: 'Email',
              ),
              const SizedBox(height: 16),

              PasswordField(
                controller: passController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              PasswordField(
                controller: confirmPassController,
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                isConfirmPassword: true,
              ),

              const SizedBox(height: 24),

              _buildSignUpButton(),

              const SizedBox(height: 16),

              _buildContinueWithText(),

              const SizedBox(height: 16),

              _buildGoogleButton(),

              const SizedBox(height: 24),

              _buildAlreadyHaveAccount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  // ============================================================
  // 🔥 MODIFIED — SUPABASE SIGN UP LOGIC
  // ============================================================
  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final name = nameController.text.trim();
          final email = emailController.text.trim();
          final password = passController.text.trim();
          final confirmPassword = confirmPassController.text.trim();

          // Basic validation
          if (name.isEmpty || email.isEmpty || password.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("All fields are required")),
            );
            return;
          }

          if (password != confirmPassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Passwords do not match")),
            );
            return;
          }

          try {
            final response = await supabase.auth.signUp(
              email: email,
              password: password,
              data: {
                'name': name,
              },
            );

            // SUCCESS
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sign up successful")),
            );

            // Navigate when success
            context.go(RoutesName.mainView);

          } on AuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message)),
            );
          }
        },
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
