import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Color backGroungColor;
  final String text;
  final Color textColor;
  final BorderSide? outLine;
  final VoidCallback? onPressed;
  const CustomButton({
    super.key,
    required this.backGroungColor,
    required this.text,
    required this.textColor,
    required this.onPressed,
    this.outLine,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backGroungColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: outLine,
      ),
      child: Text(
        text,

        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
      ),
    );
  }
}
