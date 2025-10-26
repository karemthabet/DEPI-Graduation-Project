import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
import 'widgets/language_option_item.dart';

class LanguageProfileView extends StatefulWidget {
  const LanguageProfileView({super.key});

  @override
  State<LanguageProfileView> createState() => _LanguageProfileViewState();
}

class _LanguageProfileViewState extends State<LanguageProfileView> {
  String selectedLanguage = 'English';

  void onLanguageSelected(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Language',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LanguageOptionItem(
              title: 'Arabic',
              flagPath: 'assets/images/egflag.png',
              isSelected: selectedLanguage == 'Arabic',
              onTap: () => onLanguageSelected('Arabic'),
            ),
            const SizedBox(height: 16),
            LanguageOptionItem(
              title: 'English',
              flagPath: 'assets/images/usflag.png',
              isSelected: selectedLanguage == 'English',
              onTap: () => onLanguageSelected('English'),
            ),
          ],
        ),
      ),
    );
  }
}
