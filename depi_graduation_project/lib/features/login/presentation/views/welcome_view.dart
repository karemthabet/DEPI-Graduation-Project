import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/features/login/presentation/views/sign_in_view.dart';
import 'package:whatsapp/core/utils/router/routes_name.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w), // Using ScreenUtil for responsive padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40.h),

                _buildLogo(),

                SizedBox(height: 30.h),

                _buildTitle(),

                SizedBox(height: 8.h),

                _buildSubtitle(),

                SizedBox(height: 56.h),

                _buildLoginButton(context),

                SizedBox(height: 30.h),

                _buildSignUpButton(context),

                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: () {
                    context.push(RoutesName.mainView);
                  },
                  child: const Text('Continue as Guest')),


                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for Logo Image
  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      height: 300.h,
      width: 300.w,
      fit: BoxFit.contain,
    );
  }

  // Widget for Title Text
  Widget _buildTitle() {
    return Text(
      'Start Your Egyptian Journey',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF243E4B),
        height: 1.1,
        letterSpacing: 0.3,
      ),
    );
  }

  // Widget for Subtitle Text
  Widget _buildSubtitle() {
    return Text(
      'Explore ancient wonders, hidden gems,\nand timeless treasures',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF4F6C7A),
        height: 1.3,
      ),
    );
  }

  // Widget for Log In Button
  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
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
          backgroundColor: const Color(0xFFFFE26D),
          foregroundColor: const Color(0xFF243E4B),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'Log In',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF243E4B),
          ),
        ),
      ),
    );
  }

  // Widget for Sign Up Button
  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          context.push(RoutesName.signUp);
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          side: const BorderSide(
            color: Color(0xFFFFC552),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Text(
          'Sign Up',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF243E4B),
          ),
        ),
      ),
    );
  }

}