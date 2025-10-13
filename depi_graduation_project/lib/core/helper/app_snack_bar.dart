import 'package:flutter/material.dart';

/// SnackBarType
enum SnackBarType { success, error, warning, info }

/// AppSnackBar
/// ويدجت جاهزة لعرض رسائل SnackBar بشكل منسق وسهل
/// تستخدم في أي مكان في الأبلكيشن
class AppSnackBar {
  /// الدالة الأساسية لعرض SnackBar
  static Future<void> show(
    BuildContext context,
    String text, {
    SnackBarType type = SnackBarType.success,
    Duration duration = const Duration(seconds: 2),
  }) {
    Color color;
    IconData icon;

    switch (type) {
      case SnackBarType.error:
        color = Colors.redAccent;
        icon = Icons.error_outline;
        break;
      case SnackBarType.warning:
        color = Colors.orange;
        icon = Icons.warning_amber_rounded;
        break;
      case SnackBarType.info:
        color = Colors.blueAccent;
        icon = Icons.info_outline;
        break;
      case SnackBarType.success:
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
    }

    // إلغاء أي SnackBar ظاهر حاليًا
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // عرض SnackBar جديد
    return ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: duration,
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .closed;
  }


  static Future<void> success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(context, message, type: SnackBarType.success, duration: duration);

  static Future<void> error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(context, message, type: SnackBarType.error, duration: duration);

  static Future<void> warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(context, message, type: SnackBarType.warning, duration: duration);

  static Future<void> info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(context, message, type: SnackBarType.info, duration: duration);
}

/* ================================
   📌 Usage Examples
   ================================


// رسالة نجاح
AppSnackBar.success(context, "تمت العملية بنجاح");

// رسالة خطأ
AppSnackBar.error(context, "حدث خطأ في الاتصال بالسيرفر");

// رسالة تحذير
AppSnackBar.warning(context, "الإنترنت ضعيف");

// رسالة معلومات
AppSnackBar.info(context, "يوجد تحديث جديد متاح");

// باستخدام show مباشرة وتحديد النوع
AppSnackBar.show(context, "Custom SnackBar", type: SnackBarType.info);
*/
