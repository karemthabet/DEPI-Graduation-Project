import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_view.dart';
import 'sign_in_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Logo Image
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 300,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                const SizedBox(height: 100),

                // Title
                Text(
                  'Start Your Egyptian Journey',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800, // أكثر Bold
                    color: const Color(0xFF243E4B),
                    height: 1.1, // تقليل المسافة بين السطور قليلاً
                    letterSpacing: 0.3, // تباعد بسيط بين الحروف مثل Figma
                  ),
                ),
                const SizedBox(height: 8), // بدل 12 في Figma
                // Subtitle
                Text(
                  'Explore ancient wonders, hidden gems,\nand timeless treasures',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4F6C7A), // أفتح شوية من العنوان
                    height: 1.3, // راحة بصرية بين السطور
                  ),
                ),
                const SizedBox(
                  height: 56,
                ), // بدل 60 لتقليل المسافة بين النص والأزرار
                // Log In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInView(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFFFE26D,
                      ), // اللون الأصفر من Figma
                      foregroundColor: const Color(0xFF243E4B),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ), // أطول قليلاً
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0, // شكل مسطح زي Figma
                    ),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF243E4B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpView(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(
                        color: Color(0xFFFFC552),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF243E4B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Continue as Guest
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Continue as Guest',
                    style: GoogleFonts.inter(
                      fontSize: 15.5,
                      decoration: TextDecoration.underline,
                      color: const Color(0xFF243E4B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
