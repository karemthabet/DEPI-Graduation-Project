import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 🧱 GeneralCard — ويدجت عامة لعرض الكروت بشكل مرن وقابل لإعادة الاستخدام
/// تقدر تستخدمها لأي نوع من العناصر: منتج، رسالة، إعداد... إلخ
class GeneralCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Gradient? gradient;
  final bool enableRippleEffect;

  const GeneralCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12,
    this.color,
    this.border,
    this.boxShadow,
    this.onTap,
    this.width,
    this.height,
    this.alignment,
    this.gradient,
    this.enableRippleEffect = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? Theme.of(context).cardColor) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: border,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.r,
                spreadRadius: 1.r,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: child,
    );

    if (onTap == null) return card;

    return enableRippleEffect
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius.r),
            child: card,
          )
        : GestureDetector(onTap: onTap, child: card);
  }
}
