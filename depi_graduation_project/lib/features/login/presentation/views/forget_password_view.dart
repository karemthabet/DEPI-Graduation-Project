import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// تعريفات الألوان المستخدمة
const Color primaryColor = Color(0xFFFFE26D); // #FFE26D (الأصفر)
const Color darkBlueColor = Color(0xFF243E4B); // #243E4B (الأزرق الداكن)
const Color borderColor = Color(0xFFE8E8E8); // لون إطار محايد خفيف

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkBlueColor),
          onPressed: () => Navigator.of(context).pop(), // للرجوع
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title: "Forgot password?"
              Text(
                'Forgot password?',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: darkBlueColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 50),

              // 1. Email Field
              _buildEmailInputField(context),

              const SizedBox(height: 16),

              // Instruction Text
              Text(
                'We will send you a message to set or reset your new password',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: darkBlueColor,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // 2. Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement password reset submission logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // اللون الأصفر الأساسي
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    foregroundColor: darkBlueColor,
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkBlueColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت مساعدة لبناء حقل الإيميل
  Widget _buildEmailInputField(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.inter(
        color: darkBlueColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        hintText: 'Email',
        hintStyle: GoogleFonts.inter(
          color: darkBlueColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(Icons.email_outlined, color: darkBlueColor),
        // خصائص الإطار
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: borderColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: darkBlueColor,
            width: 1.0,
          ), // إطار داكن عند التركيز
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: borderColor, width: 1.0),
        ),
      ),
    );
  }
}
