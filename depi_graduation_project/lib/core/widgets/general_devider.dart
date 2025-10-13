import 'package:flutter/material.dart';

/// 🔹 GeneralDivider — فاصل عام ومرن
/// يمكن استخدامه أفقي أو عمودي + قابل للتخصيص الكامل
class GeneralDivider extends StatelessWidget {
  final double thickness;
  final double? width;
  final double? height;
  final double indent;
  final double endIndent;
  final Color? color;
  final bool isVertical;
  final bool dashed; // لتفعيل النمط المتقطع (dashed)
  final double dashWidth;
  final double dashSpace;
  final double opacity;

  const GeneralDivider({
    super.key,
    this.thickness = 1,
    this.indent = 16,
    this.endIndent = 16,
    this.color,
    this.isVertical = false,
    this.dashed = false,
    this.dashWidth = 6,
    this.dashSpace = 4,
    this.opacity = 1.0,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor =
        (color ?? Colors.grey.shade400).withOpacity(opacity.clamp(0, 1));

    if (dashed) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final totalLength =
              isVertical ? (height ?? constraints.maxHeight) : (width ?? constraints.maxWidth);
          final dashCount = (totalLength / (dashWidth + dashSpace)).floor();

          return Padding(
            padding: EdgeInsetsDirectional.only(
              start: indent,
              end: endIndent,
            ),
            child: Flex(
              direction: isVertical ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(dashCount, (_) {
                return SizedBox(
                  width: isVertical ? thickness : dashWidth,
                  height: isVertical ? dashWidth : thickness,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: dividerColor),
                  ),
                );
              }),
            ),
          );
        },
      );
    }

    // 🔸 Divider عادي
    return Padding(
      padding: EdgeInsetsDirectional.only(start: indent, end: endIndent),
      child: isVertical
          ? VerticalDivider(
              color: dividerColor,
              thickness: thickness,
              width: width ?? thickness,
            )
          : Divider(
              color: dividerColor,
              thickness: thickness,
              height: height,
            ),
    );
  }
}
